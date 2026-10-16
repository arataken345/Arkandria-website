/* =========================================================================
 * The Asylum v2 — audio.js
 * Howler-based audio manager.
 *
 * - Ambient tracks crossfade per #AUDIO tag (id -> file from the manifest).
 * - SFX fire-and-forget per UI / bridge events.
 * - Manifest: assets/audio/audio-manifest.json (loaded when served over
 *   http; file:// falls back to the built-in map below).
 * - If an audio file is missing/unloadable, a subtle GENERATIVE drone
 *   (WebAudio, no assets needed) takes over so the game never goes silent
 *   and never throws.
 * - All failures are silent by design (horror must not console.error).
 * ========================================================================= */
(function () {
"use strict";

var BASE = "assets/audio/";

/* Baked snapshot of assets/audio/audio-manifest.json (2026-10-16).
 * Lets file:// play the real local files without a manifest fetch.
 * Regenerate if the manifest changes. */
var BAKED_MANIFEST = {
  ambient: {"amb_title":"amb_title.wav","amb_corridor":"amb_corridor.wav","amb_reception":"amb_reception.wav","amb_doorhub":"amb_doorhub.wav","amb_saferoom":"amb_saferoom.wav","amb_darkstare":"amb_darkstare.wav","amb_teddyroom":"amb_teddyroom.wav","amb_steeldoor":"amb_steeldoor.wav","amb_leftcorridor":"amb_leftcorridor.wav","amb_hall":"amb_hall.wav","amb_crates":"amb_crates.wav","amb_death":"amb_death.wav"},
  sfx: {"sfx_ui_click":"sfx_ui_click.wav","sfx_ui_hover":"sfx_ui_hover.wav","sfx_type_tick":"sfx_type_tick.wav","sfx_choice_appear":"sfx_choice_appear.wav","sfx_pickup":"sfx_pickup.wav","sfx_achievement":"sfx_achievement.wav","sfx_death_sting":"sfx_death_sting.wav","sfx_heal":"sfx_heal.wav","sfx_dice_roll":"sfx_dice_roll.wav","sfx_paper_rustle":"sfx_paper_rustle.wav","sfx_door_creak":"sfx_door_creak.wav","sfx_metal_clang":"sfx_metal_clang.wav","sfx_whisper":"sfx_whisper.wav","sfx_footstep":"sfx_footstep.wav","sfx_energy_low":"sfx_energy_low.wav","sfx_faint":"sfx_faint.wav","sfx_heartbeat":"sfx_heartbeat.wav","sfx_jumpscare":"sfx_jumpscare.wav"}
};

/* Built-in fallback: standard ids -> standard filenames.
 * The real manifest (assets/audio/audio-manifest.json) uses a flat schema:
 *   { "amb_corridor": {"file": "amb_corridor.wav", "ogg": "..."}, "sfx_ui_click": {...} }
 * and #AUDIO tags in the story use SHORT ids ("corridor"), resolved to
 * "amb_corridor" automatically. */
var FALLBACK_AMBIENT = {
  amb_title: "amb_title.wav", amb_corridor: "amb_corridor.wav",
  amb_reception: "amb_reception.wav", amb_doorhub: "amb_doorhub.wav",
  amb_saferoom: "amb_saferoom.wav", amb_darkstare: "amb_darkstare.wav",
  amb_teddyroom: "amb_teddyroom.wav", amb_steeldoor: "amb_steeldoor.wav",
  amb_leftcorridor: "amb_leftcorridor.wav", amb_hall: "amb_hall.wav",
  amb_crates: "amb_crates.wav", amb_death: "amb_death.wav"
};

/* Logical sfx ids used by bridge.js / ui.js -> concrete manifest keys. */
var LOGICAL_SFX = {
  click: "sfx_ui_click", page: "sfx_paper_rustle",
  choice_appear: "sfx_choice_appear", pickup: "sfx_pickup",
  achievement: "sfx_achievement", death_sting: "sfx_death_sting",
  faint: "sfx_faint", heal: "sfx_heal", eat: "sfx_heal",
  hurt: "sfx_energy_low", whisper: "sfx_whisper",
  checkpoint: "sfx_choice_appear", tier_up: "sfx_dice_roll",
  mental_up: "sfx_choice_appear", mental_down: "sfx_whisper",
  use_item: "sfx_ui_click", type_tick: "sfx_type_tick",
  footstep: "sfx_footstep", heartbeat: "sfx_heartbeat",
  dice: "sfx_dice_roll", energy_low: "sfx_energy_low",
  door: "sfx_door_creak", metal: "sfx_metal_clang",
  paper: "sfx_paper_rustle", unlock: "sfx_ui_click"
};

/* Generative drone presets per ambient id (Hz base, noise amount, LFO). */
var GEN_PRESETS = {
  amb_title:      { base: 55,  detune: 3, noise: 0.04, lfo: 0.04, gain: 0.14 },
  amb_corridor:   { base: 47,  detune: 6, noise: 0.10, lfo: 0.08, gain: 0.18 },
  amb_reception:  { base: 62,  detune: 2, noise: 0.05, lfo: 0.05, gain: 0.13 },
  amb_doorhub:    { base: 44,  detune: 5, noise: 0.08, lfo: 0.07, gain: 0.17 },
  amb_saferoom:   { base: 58,  detune: 4, noise: 0.05, lfo: 0.05, gain: 0.15 },
  amb_darkstare:  { base: 40,  detune: 7, noise: 0.12, lfo: 0.10, gain: 0.19 },
  amb_teddyroom:  { base: 52,  detune: 6, noise: 0.09, lfo: 0.09, gain: 0.16 },
  amb_steeldoor:  { base: 50,  detune: 5, noise: 0.08, lfo: 0.06, gain: 0.16 },
  amb_leftcorridor:{ base: 46, detune: 6, noise: 0.11, lfo: 0.08, gain: 0.17 },
  amb_hall:       { base: 52,  detune: 3, noise: 0.07, lfo: 0.06, gain: 0.16 },
  amb_crates:     { base: 48,  detune: 8, noise: 0.10, lfo: 0.12, gain: 0.17 },
  amb_death:      { base: 36,  detune: 9, noise: 0.15, lfo: 0.13, gain: 0.20 },
  amb_ward:       { base: 58,  detune: 4, noise: 0.05, lfo: 0.05, gain: 0.15 },
  amb_dark:       { base: 38,  detune: 8, noise: 0.14, lfo: 0.11, gain: 0.20 },
  amb_silence:    { base: 50,  detune: 2, noise: 0.02, lfo: 0.03, gain: 0.06 }
};

function lsGet(k) { try { return window.localStorage.getItem(k); } catch (e) { return null; } }
function lsSet(k, v) { try { window.localStorage.setItem(k, v); } catch (e) {} }

var AudioSys = {
  muted: lsGet("asylum_v2_muted") === "1",
  manifest: null,
  ambientId: null,
  _howl: null,          /* current ambient Howl */
  _gen: null,           /* generative engine nodes */
  _unlocked: false,

  init: function () {
    var self = this;
    this.manifest = { ambient: {}, sfx: {} };
    try {
      for (var bk in BAKED_MANIFEST.ambient) this.manifest.ambient[bk] = BAKED_MANIFEST.ambient[bk];
      for (var bs in BAKED_MANIFEST.sfx) this.manifest.sfx[bs] = BAKED_MANIFEST.sfx[bs];
    } catch (e) {}
    for (var k in FALLBACK_AMBIENT) {
      if (!this.manifest.ambient[k]) this.manifest.ambient[k] = FALLBACK_AMBIENT[k];
    }
    /* Try the JSON manifest only over http(s); file:// fetch is unreliable. */
    try {
      var proto = String(window.location.protocol || "");
      if (proto.indexOf("http") === 0 && typeof fetch === "function") {
        fetch("assets/audio/audio-manifest.json", { cache: "no-store" })
          .then(function (r) { return r.ok ? r.json() : null; })
          .then(function (m) { if (m) self._ingestManifest(m); })
          .catch(function () { /* silent: fallback stands */ });
      }
    } catch (e) {}
    try {
      if (typeof Howler !== "undefined") Howler.mute(this.muted);
    } catch (e) {}
  },

  /* Accepts the flat schema {id:{file,ogg}} as well as {ambient:{},sfx:{}}. */
  _ingestManifest: function (m) {
    var self = this;
    function put(key, val) {
      var file = null;
      if (typeof val === "string") file = val;
      else if (val && typeof val === "object") file = val.file || val.ogg || null;
      if (!file) return;
      if (key.indexOf("amb_") === 0) self.manifest.ambient[key] = file;
      else if (key.indexOf("sfx_") === 0) self.manifest.sfx[key] = file;
    }
    if (m.ambient && typeof m.ambient === "object") {
      for (var k in m.ambient) {
        var v = m.ambient[k];
        this.manifest.ambient[k.indexOf("amb_") === 0 ? k : "amb_" + k] =
          (typeof v === "string") ? v : (v && (v.file || v.ogg));
      }
    }
    if (m.sfx && typeof m.sfx === "object") {
      for (var s in m.sfx) {
        var w = m.sfx[s];
        this.manifest.sfx[s.indexOf("sfx_") === 0 ? s : "sfx_" + s] =
          (typeof w === "string") ? w : (w && (w.file || w.ogg));
      }
    }
    for (var key in m) {
      if (key === "ambient" || key === "sfx" || key.charAt(0) === "_") continue;
      put(key, m[key]);
    }
  },

  _ambientFile: function (id) {
    if (!id) return null;
    var M = this.manifest.ambient;
    return M[id] || M["amb_" + id] || FALLBACK_AMBIENT[id] || FALLBACK_AMBIENT["amb_" + id] || null;
  },

  _sfxFile: function (id) {
    if (!id) return null;
    var key = LOGICAL_SFX[id] || id;
    var M = this.manifest.sfx;
    /* accept logical ids ("click"), raw ids ("paper_rustle") and full
       manifest keys ("sfx_paper_rustle") */
    return M[key] || M["sfx_" + key] || M[id] || M["sfx_" + id] || null;
  },

  /* Must be called from a user gesture at least once. */
  unlock: function () {
    if (this._unlocked) return;
    this._unlocked = true;
    try {
      if (typeof Howler !== "undefined" && Howler.ctx && Howler.ctx.state === "suspended")
        Howler.ctx.resume();
    } catch (e) {}
    this._ensureGen();
  },

  isMuted: function () { return this.muted; },
  setMuted: function (m) {
    this.muted = !!m;
    lsSet("asylum_v2_muted", this.muted ? "1" : "0");
    try { if (typeof Howler !== "undefined") Howler.mute(this.muted); } catch (e) {}
    try { if (this._gen && this._gen.master) this._gen.master.gain.value = this.muted ? 0 : 1; } catch (e) {}
  },
  toggleMute: function () { this.setMuted(!this.muted); return this.muted; },

  /* ---------------- Ambient ---------------- */

  setAmbient: function (id) {
    if (!id || id === this.ambientId) return;
    this.ambientId = id;
    var file = this._ambientFile(id);
    this.unlock();
    if (!file) { this._playGenerative(id); return; }
    /* Try the real file; fall back to generative on load error. */
    var self = this;
    try {
      if (typeof Howl === "undefined") { this._playGenerative(id); return; }
      var h = new Howl({
        src: [BASE + file], loop: true, volume: 0.0, html5: false, preload: true,
        onload: function () {
          if (self.ambientId !== id) return; /* superseded */
          self._stopGenerative();
          self._fadeOutOldAmbient(function () {
            self._howl = h;
            try { h.play(); h.fade(0, self.muted ? 0 : 0.55, 2500); } catch (e) {}
          });
        },
        onloaderror: function () { if (self.ambientId === id) self._playGenerative(id); },
        onplayerror: function () { if (self.ambientId === id) self._playGenerative(id); }
      });
      h.load();
    } catch (e) { this._playGenerative(id); }
  },

  _fadeOutOldAmbient: function (done) {
    var old = this._howl;
    this._howl = null;
    if (!old) { done(); return; }
    try {
      var v = 0;
      try { v = old.volume(); } catch (e) {}
      old.fade(v, 0, 1200);
      old.once("fade", function () { try { old.stop(); old.unload(); } catch (e) {} done(); });
      setTimeout(function () { try { old.stop(); old.unload(); } catch (e) {} done(); }, 1600);
    } catch (e) { done(); }
  },

  stopAmbient: function () {
    this.ambientId = null;
    this._stopGenerative();
    var old = this._howl; this._howl = null;
    try { if (old) { old.stop(); old.unload(); } } catch (e) {}
  },

  /* ---------------- Generative drone (no assets) ---------------- */

  _ensureGen: function () {
    if (this._gen) {
      try { if (this._gen.ctx.state === "suspended") this._gen.ctx.resume(); } catch (e) {}
      return this._gen;
    }
    try {
      var AC = window.AudioContext || window.webkitAudioContext;
      if (!AC) return null;
      var ctx = new AC();
      var master = ctx.createGain();
      master.gain.value = this.muted ? 0 : 1;
      master.connect(ctx.destination);
      this._gen = { ctx: ctx, master: master, nodes: null };
      return this._gen;
    } catch (e) { return null; }
  },

  _playGenerative: function (id) {
    var g = this._ensureGen();
    if (!g) return;
    this._fadeOutOldAmbient(function () {});
    var p = GEN_PRESETS[id] || GEN_PRESETS["amb_" + id] || GEN_PRESETS.amb_corridor;
    var ctx = g.ctx;
    try {
      /* tear down previous drone */
      if (g.nodes) {
        var nn = g.nodes;
        try { nn.gain.gain.linearRampToValueAtTime(0.0001, ctx.currentTime + 1.2); } catch (e) {}
        setTimeout((function (n) { return function () {
          try { n.osc1.stop(); n.osc2.stop(); n.src.stop(); n.osc1.disconnect(); n.osc2.disconnect(); n.src.disconnect(); n.gain.disconnect(); } catch (e) {}
        }; })(nn), 1400);
      }
      var gain = ctx.createGain();
      gain.gain.value = 0.0001;
      gain.connect(g.master);

      var osc1 = ctx.createOscillator(); osc1.type = "sine"; osc1.frequency.value = p.base;
      var osc2 = ctx.createOscillator(); osc2.type = "sine"; osc2.frequency.value = p.base + p.detune;
      var og = ctx.createGain(); og.gain.value = 0.5;
      osc1.connect(og); osc2.connect(og); og.connect(gain);

      /* airy noise */
      var len = ctx.sampleRate * 2;
      var buf = ctx.createBuffer(1, len, ctx.sampleRate);
      var d = buf.getChannelData(0);
      for (var i = 0; i < len; i++) d[i] = Math.random() * 2 - 1;
      var src = ctx.createBufferSource(); src.buffer = buf; src.loop = true;
      var lp = ctx.createBiquadFilter(); lp.type = "lowpass"; lp.frequency.value = 320; lp.Q.value = 0.6;
      var ng = ctx.createGain(); ng.gain.value = p.noise;
      src.connect(lp); lp.connect(ng); ng.connect(gain);

      /* slow dread LFO on the filter */
      var lfo = ctx.createOscillator(); lfo.type = "sine"; lfo.frequency.value = p.lfo;
      var lg = ctx.createGain(); lg.gain.value = 160;
      lfo.connect(lg); lg.connect(lp.frequency);

      osc1.start(); osc2.start(); src.start(); lfo.start();
      gain.gain.linearRampToValueAtTime(p.gain, ctx.currentTime + 2.5);
      g.nodes = { gain: gain, osc1: osc1, osc2: osc2, src: src, lfo: lfo };
    } catch (e) {}
  },

  _stopGenerative: function () {
    var g = this._gen;
    if (!g || !g.nodes) return;
    var nn = g.nodes; g.nodes = null;
    try {
      var ctx = g.ctx;
      nn.gain.gain.linearRampToValueAtTime(0.0001, ctx.currentTime + 0.8);
      setTimeout(function () {
        try { nn.osc1.stop(); nn.osc2.stop(); nn.src.stop(); nn.lfo.stop(); nn.gain.disconnect(); } catch (e) {}
      }, 1000);
    } catch (e) {}
  },

  /* ---------------- SFX ---------------- */

  sfx: function (id, opts) {
    if (!id) return;
    this.unlock();
    var file = this._sfxFile(id);
    if (!file) return;
    try {
      if (typeof Howl === "undefined") return;
      var o = opts || {};
      var h = new Howl({
        src: [BASE + file], loop: false,
        volume: Math.max(0, Math.min(1, o.gain != null ? o.gain : 0.7)),
        html5: false, preload: true
      });
      h.play();
      /* release after a while; failures stay silent */
      setTimeout(function () { try { h.unload(); } catch (e) {} }, 12000);
    } catch (e) {}
  }
};

if (typeof window !== "undefined") window.AudioSys = AudioSys;
if (typeof module !== "undefined" && module.exports) module.exports = AudioSys;

})();
