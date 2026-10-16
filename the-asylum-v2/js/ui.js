/* =========================================================================
 * The Asylum v2 — ui.js
 * Rendering, cinematic transitions, typewriter, HUD, inventory,
 * achievements, save slots, death/respawn, tutorial.
 * Depends on: ink.js (global inkjs), bridge.js (global Bridge),
 *             audio.js (global AudioSys), localforage.
 * ========================================================================= */
(function () {
"use strict";

/* ---------------- Bilingual UI strings ---------------- */
var STR = {
  id: {
    subtitle: "Rumah sakit jiwa yang terlupakan.",
    new_game: "Permainan Baru", continue: "Lanjutkan", tutorial: "Tutorial",
    enter: "Masuki", back: "Kembali", next: "Lanjut", skip: "Lewati",
    close: "Tutup", understood: "Mengerti", menu: "Menu Utama",
    confirm_new: "Mulai permainan baru? Progres yang belum disimpan akan hilang.",
    death_title: "KAU MATI",
    death_story: "Kegelapan mengambilmu.",
    death_count: "Kematian",
    respawn: "Bangkit di Checkpoint Terakhir",
    restart: "Mulai dari Awal",
    no_checkpoint: "Tidak ada checkpoint — mulai dari awal.",
    faint_title: "Kesadaran Hilang",
    inv_title: "Tas", inv_empty: "Tasmu kosong.",
    inv_use: "Pakai", inv_equip: "Pasang", inv_unequip: "Lepas",
    eq_title: "Perlengkapan",
    eq_empty: "— kosong —",
    achv_title: "Pencapaian",
    achv_locked: "Terkunci",
    achv_unlocked_title: "Pencapaian Terbuka",
    save_title: "Penyimpanan",
    slot_empty: "Kosong",
    slot_save: "Simpan", slot_load: "Muat", slot_delete: "Hapus",
    slot_saved: "Tersimpan",
    save_confirm_overwrite: "Timpa simpanan ini?",
    delete_confirm: "Hapus simpanan ini?",
    end_title: "— TAMAT —",
    end_sub: "Sampel berakhir di sini. Cerita penuh menyusul.",
    end_stats: "Perjalananmu",
    play_again: "Main Lagi",
    hud_mental: "Mental", hud_energy: "Energi", hud_status: "Status",
    knots: "Adegan", lang_label: "ID",
    tut_progress: function (a, b) { return "Langkah " + a + " / " + b; },
    tut_start: "Mulai Bermain",
    checkpoint_saved: "Checkpoint",
    obtained: "Mendapat",
    autosave_note: "Otomatis tersimpan di checkpoint.",
    game_menu: "Menu",
    settings: "Pengaturan",
    language: "Bahasa",
    sound: "Suara",
    sound_on: "Nyala",
    sound_off: "Mati",
    text_speed: "Kecepatan Teks",
    speed_lambat: "Lambat",
    speed_normal: "Normal",
    speed_cepat: "Cepat",
    back_to_hub: "Kembali ke Ambang",
    back_to_title: "Menu Judul",
    hub_kicker: "ARKANDRIA · AMBANG PERTAMA",
    quit_to_title_confirm: "Kembali ke menu judul? Progres yang belum disimpan akan hilang."
  },
  en: {
    subtitle: "The forgotten asylum.",
    new_game: "New Game", continue: "Continue", tutorial: "Tutorial",
    enter: "Enter", back: "Back", next: "Next", skip: "Skip",
    close: "Close", understood: "Understood", menu: "Main Menu",
    confirm_new: "Start a new game? Unsaved progress will be lost.",
    death_title: "YOU DIED",
    death_story: "The darkness took you.",
    death_count: "Deaths",
    respawn: "Rise at Last Checkpoint",
    restart: "Start Over",
    no_checkpoint: "No checkpoint — starting over.",
    faint_title: "Unconscious",
    inv_title: "Bag", inv_empty: "Your bag is empty.",
    inv_use: "Use", inv_equip: "Equip", inv_unequip: "Unequip",
    eq_title: "Gear",
    eq_empty: "— empty —",
    achv_title: "Achievements",
    achv_locked: "Locked",
    achv_unlocked_title: "Achievement Unlocked",
    save_title: "Save Data",
    slot_empty: "Empty",
    slot_save: "Save", slot_load: "Load", slot_delete: "Delete",
    slot_saved: "Saved",
    save_confirm_overwrite: "Overwrite this save?",
    delete_confirm: "Delete this save?",
    end_title: "— THE END —",
    end_sub: "The sample ends here. The full story follows.",
    end_stats: "Your journey",
    play_again: "Play Again",
    hud_mental: "Mind", hud_energy: "Energy", hud_status: "Status",
    knots: "Scenes", lang_label: "EN",
    tut_progress: function (a, b) { return "Step " + a + " / " + b; },
    tut_start: "Begin",
    checkpoint_saved: "Checkpoint",
    obtained: "Obtained",
    autosave_note: "Autosaved at checkpoints.",
    game_menu: "Menu",
    settings: "Settings",
    language: "Language",
    sound: "Sound",
    sound_on: "On",
    sound_off: "Off",
    text_speed: "Text Speed",
    speed_lambat: "Slow",
    speed_normal: "Normal",
    speed_cepat: "Fast",
    back_to_hub: "Back to the Threshold",
    back_to_title: "Title Screen",
    hub_kicker: "ARKANDRIA · FIRST THRESHOLD",
    quit_to_title_confirm: "Quit to the title screen? Unsaved progress will be lost."
  }
};

var TUT_STEPS = [
  { t: { id: "Selamat Datang di The Asylum", en: "Welcome to The Asylum" },
    h: { id: "Kau terbangun di rumah sakit jiwa yang terbengkalai — dan sesuatu di sini memperhatikanmu.<br><br>Tujuanmu hanya satu: <b>bertahan hidup</b>. Setiap pilihan adalah takdir. Tidak ada tombol kembali.",
         en: "You wake in an abandoned asylum — and something here is watching you.<br><br>Your goal is one: <b>survive</b>. Every choice is fate. There is no back button." } },
  { t: { id: "Membaca", en: "Reading" },
    h: { id: "Cerita ditulis sebagai <b>teks narasi</b> yang muncul huruf demi huruf. Bacalah perlahan — petunjuk sering tersembunyi di detail kecil.<br><br>Ketuk teks untuk melewati animasi ketik.",
         en: "The story unfolds as <b>narrative text</b>, letter by letter. Read slowly — clues often hide in small details.<br><br>Tap the text to skip the typing animation." } },
  { t: { id: "Memilih", en: "Choosing" },
    h: { id: "Setiap pilihan membuka <b>jalan yang berbeda</b>. Di desktop, tekan <b>1–9</b> untuk memilih cepat.<br><br>Beberapa pilihan <b>terkunci</b> saat kau terluka atau panik — tubuh dan pikiranmu ikut menentukan.",
         en: "Each choice opens a <b>different path</b>. On desktop, press <b>1–9</b> to choose quickly.<br><br>Some choices stay <b>locked</b> while you are wounded or panicking — your body and mind decide too." } },
  { t: { id: "Kondisimu", en: "Your Condition" },
    h: { id: "Perhatikan bilah atas:<br>• <b>Status</b> — Aman, Bahaya, atau Terluka.<br>• <b>Mental</b> — dari Tenang hingga Hancur; bisa memburuk <i>dan</i> pulih.<br>• <b>Energi</b> — setiap langkah mengurasnya. Makan untuk pulih.",
         en: "Watch the top bar:<br>• <b>Status</b> — Safe, Danger, or Wounded.<br>• <b>Mind</b> — from Calm to Shattered; it can worsen <i>and</i> recover.<br>• <b>Energy</b> — every step drains it. Eat to recover." } },
  { t: { id: "Tubuhmu", en: "Your Body" },
    h: { id: "Luka tercatat dalam empat jalur — <b>Stress, Keracunan, Pendarahan, Kelelahan</b> — dari Ringan hingga Ekstrim.<br><br>Di tingkat Ekstrim, tubuhmu mulai <b>mengambil alih</b> pilihanmu.",
         en: "Harm is tracked on four tracks — <b>Stress, Poisoning, Bleeding, Exhaustion</b> — from Mild to Extreme.<br><br>At Extreme, your body starts <b>overriding</b> your choices." } },
  { t: { id: "Tas & Perlengkapan", en: "Bag & Gear" },
    h: { id: "Tombol <b>🎒</b> membuka tasmu. Makanan dan perban bisa <b>dipakai</b> langsung. Senjata harus <b>dipasang</b> di slot perlengkapan agar berguna.",
         en: "The <b>🎒</b> button opens your bag. Food and bandages can be <b>used</b> directly. Weapons must be <b>equipped</b> in the gear slot to matter." } },
  { t: { id: "Kematian", en: "Death" },
    h: { id: "Kematian bukanlah akhir. Kau akan <b>bangkit di checkpoint terakhir</b> — tapi setiap kematian menaikkan <b>Death Count</b>.<br><br>Jagalah tetap rendah. Itu menentukan <b>akhir</b> ceritamu.",
         en: "Death is not the end. You will <b>rise at your last checkpoint</b> — but every death raises your <b>Death Count</b>.<br><br>Keep it low. It decides the <b>ending</b> of your story." } },
  { t: { id: "Menyimpan", en: "Saving" },
    h: { id: "Progres <b>tersimpan otomatis</b> di setiap checkpoint. Kau juga bisa menyimpan manual di <b>3 slot</b> lewat tombol 💾.",
         en: "Progress <b>autosaves</b> at every checkpoint. You can also save manually into <b>3 slots</b> via the 💾 button." } }
];

/* ---------------- Helpers ---------------- */
function $(sel, root) { return (root || document).querySelector(sel); }
function el(tag, cls, html) {
  var e = document.createElement(tag);
  if (cls) e.className = cls;
  if (html != null) e.innerHTML = html;
  return e;
}
function esc(s) {
  return String(s == null ? "" : s).replace(/[&<>"']/g, function (c) {
    return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c];
  });
}
function reducedMotion() {
  try { return window.matchMedia("(prefers-reduced-motion: reduce)").matches; }
  catch (e) { return false; }
}

/* ---------------- Text speed (feedback Kaze: default jauh lebih lambat) ---------------- */
var TEXT_SPEEDS = {
  lambat: { step: 1, ms: 48 },  /* ~21 char/detik */
  normal: { step: 1, ms: 30 },  /* ~33 char/detik */
  cepat:  { step: 2, ms: 16 }   /* ~125 char/detik (kecepatan lama) */
};
var TEXT_SPEED_KEYS = ["lambat", "normal", "cepat"];
var DEFAULT_TEXT_SPEED = "lambat";

/* ---------------- UI ---------------- */
var UI = {
  story: null,
  lang: "id",
  kicker: "", tag: "",
  typeTimer: null,
  typeQueue: [],
  typing: false,
  dead: false,
  eventQueue: [],      /* modal-grade events waiting (tutpop/faint) */
  achvToastQueue: [],
  achvToastShowing: false,
  lastCheckpointView: null
};

function t(key) {
  var v = (STR[UI.lang] || STR.id)[key];
  return typeof v === "function" ? v : (v == null ? key : v);
}
function tf(key, a, b) {
  var v = (STR[UI.lang] || STR.id)[key];
  return typeof v === "function" ? v(a, b) : v;
}

/* ============ Boot ============ */
UI.init = function () {
  if (this._inited) return; /* idempoten: cegah double wire/listeners */
  this._inited = true;
  var self = this;
  try { localforage.config({ name: "asylum_v2", storeName: "asylum_v2" }); } catch (e) {}
  try { AudioSys.init(); } catch (e) {}
  try { Bridge.loadSettings(); } catch (e) {}
  Bridge.reset("id");
  this.lang = "id";
  var unlockOnce = function () { try { AudioSys.unlock(); } catch (e) {} };
  document.addEventListener("pointerdown", unlockOnce, { once: true });
  document.addEventListener("keydown", function (e) { self.onKey(e); });
  try { this.initAtmosphere(); } catch (e) {}
  this.boot();
};

/* ============ Title (overlay above the cold open) ============ */
UI.hideTitle = function () {
  var o = $("#title-overlay");
  if (o) { o.classList.add("hidden"); o.innerHTML = ""; }
};
UI.showTitle = function () {
  var self = this;
  this.dead = false;
  try { AudioSys.setAmbient("title"); } catch (e) {}
  var overlay = $("#title-overlay");
  overlay.classList.remove("hidden");
  overlay.innerHTML = "";
  var wrap = el("div", "screen title-screen");
  wrap.innerHTML =
    '<div class="title-flicker">' +
      '<div class="hub-kicker">' + esc(t("hub_kicker")) + '</div>' +
      '<div class="title-kicker">' + esc(t("subtitle")) + '</div>' +
      '<h1 class="game-title">THE ASYLUM</h1>' +
      '<div class="title-rule"><span></span><i>✦</i><span></span></div>' +
    '</div>' +
    '<div class="title-menu">' +
      '<button class="btn-choice big" id="btnNew">' + esc(t("new_game")) + '</button>' +
      '<button class="btn-choice big" id="btnContinue">' + esc(t("continue")) + '</button>' +
      '<button class="btn-choice big ghost" id="btnTut">' + esc(t("tutorial")) + '</button>' +
    '</div>' +
    '<div class="title-foot">' +
      '<button class="mini-btn" id="btnLang">' + esc(UI.lang === "id" ? "EN" : "ID") + '</button>' +
      '<button class="mini-btn" id="btnMuteTitle">' + (AudioSys.isMuted() ? "🔇" : "🔊") + '</button>' +
      '<a class="mini-btn hub-link" href="../">⛩ ' + esc(t("back_to_hub")) + '</a>' +
    '</div>';
  overlay.appendChild(wrap);

  $("#btnNew").onclick = function () {
    /* cold open alone (knotsVisited<=1) doesn't count as progress */
    if (Bridge.S && (Bridge.S.knotsVisited > 1 || (Bridge.S.items || []).length > 0)) {
      if (!window.confirm(t("confirm_new"))) return;
    }
    self.startNew();
  };
  $("#btnContinue").onclick = function () { self.continueGame(); };
  $("#btnTut").onclick = function () { self.openTutorial(function () {}); };
  $("#btnLang").onclick = function () { self.toggleLang(); self.showTitle(); };
  $("#btnMuteTitle").onclick = function () {
    var m = AudioSys.toggleMute();
    $("#btnMuteTitle").textContent = m ? "🔇" : "🔊";
  };
  try { AudioSys.sfx("page"); } catch (e) {}
};

UI.toggleLang = function () {
  this.lang = this.lang === "id" ? "en" : "id";
  Bridge.lang = this.lang;
  document.documentElement.lang = this.lang;
};

/* ============ Story lifecycle ============ */
UI.storyJson = function () {
  return this.lang === "id" ? window.STORY_ID : window.STORY_EN;
};

UI.startNew = function () {
  Bridge.reset(this.lang);
  this.kicker = ""; this.tag = "";
  this._lastTag = ""; this._gameStarted = false;
  this.dead = false;
  this.loadStoryFresh();
  this.hideTitle();
  Bridge.unlockAchv("wake_up");
  this.beginFromKnot(window.STORY_START_KNOT || "prolog2");
};

/* Boot: play the cold open (prolog1 -> END), then reveal the title overlay. */
UI.boot = function () {
  this.loadStoryFresh();
  this.coldOpen = true;
  $("#hud").classList.remove("visible");
  $("#dock").classList.remove("visible");
  this.advance();
};

/* Jump to an entry knot (safe when the knot is absent, e.g. sample story). */
UI.beginFromKnot = function (knot) {
  try { this.story.ChoosePathString(knot); }
  catch (e) { /* keep default position */ }
  this._gameStarted = true;
  $("#hud").classList.add("visible");
  $("#dock").classList.add("visible");
  this.advance(); /* renderKnot wraps its own cinematic transition */
};

UI.loadStoryFresh = function () {
  var json = this.storyJson();
  this.story = new inkjs.Story(json);
  Bridge.bindAll(this.story);
  /* Never let a story-content slip crash the game: inkjs throws when no
     onError handler is assigned. With a handler, the story simply ends and
     the UI shows the ending screen. (Known part1 case: a hub knot whose
     sticky choices are all exhausted has no fallback divert.) */
  try {
    this.story.onError = function () { /* recorded silently; UI treats as ending */ };
  } catch (e) {}
};

UI.continueGame = function () {
  var self = this;
  /* prefer autosave, then newest manual slot */
  var keys = ["asylum_v2_auto", "asylum_v2_slot_1", "asylum_v2_slot_2", "asylum_v2_slot_3"];
  (function next(i) {
    if (i >= keys.length) { self.startNew(); return; }
    try {
      localforage.getItem(keys[i]).then(function (raw) {
        if (raw) self.loadFromSerialized(raw);
        else next(i + 1);
      }).catch(function () { next(i + 1); });
    } catch (e) { next(i + 1); }
  })(0);
};

UI.loadFromSerialized = function (raw) {
  var inkJson;
  try { inkJson = Bridge.deserialize(raw); }
  catch (e) { this.startNew(); return; }
  this.lang = Bridge.lang || "id";
  document.documentElement.lang = this.lang;
  this.loadStoryFresh();
  try { this.story.state.LoadJson(inkJson); }
  catch (e) { this.startNew(); return; }
  this.dead = false;
  this.hideTitle();
  this._gameStarted = true;
  $("#hud").classList.add("visible");
  $("#dock").classList.add("visible");
  var self = this;
  /* Re-render current position: continue forward from restored state. */
  this.cinematic(function () { self.renderPosition(); });
};

/* Respawn: restore the last CHECKPOINT snapshot (ink ToJson/LoadJson + JS
   state), then jump to the death knot's mapped respawn target, if any
   (d5_trap -> hub_exit, s12_panic -> s12_hub). Falls back to re-rendering
   the checkpoint view, or a fresh start when nothing is available. */
UI.respawn = function () {
  var target = Bridge.respawnTargetFor(Bridge.deathKnot);
  var cp = Bridge.hasCheckpoint() ? Bridge.checkpoints[Bridge.lastCheckpoint] : null;
  if (!cp && !target) { this.startNew(); return; }
  if (cp) {
    try { this.story.state.LoadJson(cp.ink); } catch (e) { /* keep current position */ }
    Bridge.restoreState(cp.state);
  }
  var self = this;
  this.hideDeath(function () {
    self.dead = false;
    var jumped = false;
    if (target) {
      try { self.story.ChoosePathString(target); jumped = true; }
      catch (e) { jumped = false; }
    }
    if (jumped) {
      self.kicker = ""; self.tag = "";
      self.advance();
    } else if (cp && cp.view) {
      self.renderSavedView(cp.view);
    } else {
      self.renderPosition();
    }
  });
};

/* ============ Core advance loop ============ */
UI.advance = function () {
  Bridge.onKnotAdvance();
  this.renderPosition();
};

/* Drain story content at the CURRENT position (no forced forward step). */
UI.renderPosition = function () {
  var story = this.story;
  var paras = [], tags = [];
  this.knotMajor = false; /* F2: drop cap hanya jika knot bertag #MAJOR */
  var guard = 0;
  try {
    while (story.canContinue && guard++ < 200) {
      var line = story.Continue();
      var ct = story.currentTags || [];
      for (var i = 0; i < ct.length; i++) tags.push(ct[i]);
      if (line && line.trim()) paras.push(line.trim());
    }
  } catch (e) { paras.push("…"); }
  this.handleTags(tags);
  var choices = [];
  try {
    choices = story.currentChoices.map(function (c) { return { index: c.index, text: c.text, sourcePath: c.sourcePath || "" }; });
  } catch (e) {}
  var ended = !story.canContinue && choices.length === 0;
  this.renderKnot(paras, choices, ended, tags);
};

UI.handleTags = function (tags) {
  for (var i = 0; i < tags.length; i++) {
    var raw = String(tags[i] || "");
    /* tag berformat KEY:val ATAU bare KEY (mis. MAJOR) */
    var m = raw.match(/^([A-Z_]+)(?::([\s\S]*))?$/);
    if (!m) continue;
    var key = m[1], val = (m[2] || "").trim();
    if (key === "KICKER") this.kicker = val;
    else if (key === "TAG") { this.tag = val; this.updateLocation(); }
    else if (key === "AUDIO") { try { AudioSys.setAmbient(val); } catch (e) {} }
    else if (key === "SFX") { try { AudioSys.sfx(val); } catch (e) {} }  /* one-shot */
    else if (key === "IMAGE") this.setScene(val);
    else if (key === "STATUS") Bridge.applyStatusTag(val);
    else if (key === "MAJOR") this.knotMajor = true;
  }
  this.renderHUD();
};

UI.setScene = function (id) {
  var scene = $("#scene");
  if (!scene) return;
  var name = String(id || "").replace(/^bg_/, "").replace(/[^a-z0-9]/gi, "") || "default";
  var known = ["default", "corridor", "ward", "hall", "dark", "reception", "doorhub",
    "saferoom", "darkstare", "teddyroom", "steeldoor", "leftcorridor", "crates", "death", "title"];
  if (known.indexOf(name) < 0) name = "default";
  var next = "scene-" + name;
  if (scene.className !== next) {
    scene.className = next;
    /* restart the Ken Burns drift so every arrival feels like a new shot */
    try {
      scene.style.animation = "none";
      void scene.offsetWidth;
      scene.style.animation = "";
    } catch (e) {}
  }
};

/* ============ Atmospheric depth: fog, dust, parallax ============ */
UI.reducedMotion = function () {
  try { return window.matchMedia("(prefers-reduced-motion: reduce)").matches; } catch (e) { return false; }
};

UI.initAtmosphere = function () {
  var fg = $("#scene-fg");
  if (fg && !fg.dataset.built) {
    fg.dataset.built = "1";
    var mk = function (cls, extra) {
      var d = document.createElement("div");
      d.className = cls;
      for (var k in extra) d.style[k] = extra[k];
      fg.appendChild(d);
    };
    mk("fog", {});
    mk("fog f2", {});
    /* dust motes rising through the light */
    for (var i = 0; i < 16; i++) {
      var s = (1.5 + Math.random() * 2.5).toFixed(1) + "px";
      mk("mote", {
        left: (Math.random() * 100).toFixed(1) + "%",
        top: (20 + Math.random() * 80).toFixed(1) + "%",
        width: s, height: s,
        animationDuration: (9 + Math.random() * 16).toFixed(1) + "s",
        animationDelay: (-Math.random() * 20).toFixed(1) + "s",
        opacity: (0.25 + Math.random() * 0.5).toFixed(2)
      });
    }
  }
  /* mouse parallax — layers drift at different depths */
  if (this.reducedMotion()) return;
  try {
    if (!window.matchMedia("(pointer: fine)").matches) return;
  } catch (e) { return; }
  if (this._parallaxOn) return;
  this._parallaxOn = true;
  var root = document.documentElement, raf = 0, tx = 0, ty = 0;
  var apply = function () {
    raf = 0;
    root.style.setProperty("--px", tx.toFixed(3));
    root.style.setProperty("--py", ty.toFixed(3));
  };
  document.addEventListener("mousemove", function (e) {
    tx = (e.clientX / window.innerWidth - 0.5) * 2;
    ty = (e.clientY / window.innerHeight - 0.5) * 2;
    if (!raf) raf = requestAnimationFrame(apply);
  }, { passive: true });
};

/* Cinematic location title card when the #TAG changes. */
UI.showLocCard = function (tag) {
  var card = $("#loc-card");
  if (!card || !tag || this.reducedMotion()) return;
  card.innerHTML = '<div class="lc-inner"><div class="lc-name">' + esc(tag.toUpperCase()) +
    '</div><div class="lc-rule"><span></span><i>◆</i><span></span></div></div>';
  card.classList.remove("show");
  void card.offsetWidth;
  card.classList.add("show");
};

/* Cinematic letterbox transition around a content swap. */
UI.cinematic = function (swapFn) {
  var self = this;
  if (reducedMotion()) { swapFn(); return; }
  document.body.classList.add("transitioning");
  setTimeout(function () {
    try { swapFn(); } finally {
      setTimeout(function () { document.body.classList.remove("transitioning"); }, 120);
    }
  }, 420);
};

UI.renderKnot = function (paras, choices, ended, tags) {
  var self = this;
  this.stopTypewriter();
  var view = { paras: paras.slice(), choices: choices.map(function (c) { return c.text; }),
               kicker: this.kicker, tag: this.tag, major: !!this.knotMajor };
  this.lastCheckpointView = view;

  this.cinematic(function () {
    self.buildKnotDOM(paras, choices, ended);
    self.drainBridgeEvents();
  });
};

UI.renderSavedView = function (view) {
  var self = this;
  this.stopTypewriter();
  this.kicker = view.kicker || ""; this.tag = view.tag || "";
  this.knotMajor = !!view.major;
  this.updateLocation();
  var choices = [];
  try {
    choices = this.story.currentChoices.map(function (c) { return { index: c.index, text: c.text, sourcePath: c.sourcePath || "" }; });
  } catch (e) {}
  this.cinematic(function () {
    /* paragraphs shown statically (already read once), choices live */
    self.buildKnotDOM(view.paras, choices, false, true);
    self.drainBridgeEvents();
  });
};

UI.buildKnotDOM = function (paras, choices, ended, instant) {
  var self = this;
  var area = $("#story");
  if (!area) {
    area = el("div"); area.id = "story";
    $("#app").appendChild(area);
  }
  area.innerHTML = "";
  if (this.kicker) {
    var k = el("div", "kicker", esc(this.kicker));
    area.appendChild(k);
  }
  var body = el("div", "narrative" + (this.knotMajor ? " major" : ""));
  area.appendChild(body);
  var choiceBox = el("div", "choices");
  area.appendChild(choiceBox);

  /* typewriter queue */
  this.typeQueue = paras.map(function (p) { return { el: null, text: p, parent: body }; });
  this.typeNext(instant);

  /* choices appear after typing completes */
  var showChoices = function () {
    if (ended) { self.showEnding(); return; }
    /* hardcoded choice locks (bridge.js CHOICE_LOCKS), keyed by knot name
       from the choices' sourcePath (e.g. "d5_1c.0.27" -> "d5_1c") */
    var knot = (choices.length && choices[0].sourcePath)
      ? Bridge.knotNameOf(choices[0].sourcePath) : null;
    var locked = knot ? Bridge.lockedChoiceIndices(knot) : [];
    choices.forEach(function (c, i) {
      var isLocked = locked.indexOf(i) >= 0;
      var b = el("button", "btn-choice" + (isLocked ? " locked" : ""), "");
      b.innerHTML = '<span class="cnum">' + (isLocked ? "🔒" : (i + 1)) + '</span><span>' + esc(c.text) + "</span>";
      if (isLocked) {
        b.disabled = true;
        b.setAttribute("aria-disabled", "true");
      } else {
        b.onclick = function () { self.choose(c.index); };
      }
      choiceBox.appendChild(b);
      /* staggered entrance */
      if (!reducedMotion()) {
        b.style.animationDelay = (i * 90) + "ms";
        b.classList.add("choice-in");
      }
    });
  };
  this._afterType = function () {
    /* cold open finished -> reveal the title overlay (not choices/ending) */
    if (self.coldOpen) { self.coldOpen = false; self.showTitle(); return; }
    if (!ended && choices.length) { try { AudioSys.sfx("choice_appear", { gain: 0.5 }); } catch (e) {} }
    showChoices();
  };
  body.onclick = function () { self.skipTypewriter(); };
};

UI.textSpeed = function () {
  var k = Bridge.settings && Bridge.settings.textSpeed;
  return TEXT_SPEEDS[k] || TEXT_SPEEDS[DEFAULT_TEXT_SPEED];
};

UI.typeNext = function (instant) {
  var self = this;
  var item = this.typeQueue.shift();
  if (!item) {
    this.typing = false;
    if (this._afterType) { var f = this._afterType; this._afterType = null; f(); }
    return;
  }
  var p = el("p", "para");
  item.parent.appendChild(p);
  this.typing = true;
  if (instant || reducedMotion()) {
    p.textContent = item.text;
    this.typeNext(instant);
    return;
  }
  var speed = this.textSpeed();
  var i = 0, text = item.text, sinceTick = 0;
  var tick = function () {
    i += speed.step;
    sinceTick += speed.step;
    p.textContent = text.slice(0, i);
    if (sinceTick >= 6) { sinceTick = 0; try { AudioSys.sfx("type_tick", { gain: 0.10 }); } catch (e) {} }
    if (i >= text.length) {
      self.typeTimer = null;
      setTimeout(function () { self.typeNext(instant); }, 160);
    } else {
      self.typeTimer = setTimeout(tick, speed.ms);
    }
  };
  this._typeSkip = function () {
    if (self.typeTimer) { clearTimeout(self.typeTimer); self.typeTimer = null; }
    p.textContent = text;
    setTimeout(function () { self.typeNext(instant); }, 60);
  };
  tick();
};

UI.skipTypewriter = function () {
  if (this.typing && this._typeSkip) this._typeSkip();
};

/* Complete every queued paragraph instantly (used by Esc). */
UI.finishTyping = function () {
  if (this.typeTimer) { clearTimeout(this.typeTimer); this.typeTimer = null; }
  while (this.typeQueue.length) {
    var item = this.typeQueue.shift();
    var p = el("p", "para");
    p.textContent = item.text;
    item.parent.appendChild(p);
  }
  this.typing = false;
  this._typeSkip = null;
  if (this._afterType) { var f = this._afterType; this._afterType = null; f(); }
};

UI.stopTypewriter = function () {
  if (this.typeTimer) { clearTimeout(this.typeTimer); this.typeTimer = null; }
  this.typeQueue = [];
  this.typing = false;
  this._typeSkip = null;
  this._afterType = null;
};

UI.choose = function (index) {
  if (this.dead || this.typing) return;
  var self = this;
  try { AudioSys.sfx("click"); } catch (e) {}
  Bridge.spendForChoice();
  try { this.story.ChooseChoiceIndex(index); }
  catch (e) { return; }
  this.advance();
};

UI.onKey = function (e) {
  if (this.dead) return;
  var title = $("#title-overlay");
  if (title && !title.classList.contains("hidden")) return; /* title overlay up */
  /* modal open? let it handle keys */
  if ($(".modal-open")) {
    if (e.key === "Escape") this.closeModal();
    return;
  }
  if (e.key === "Escape") {
    /* Esc saat mengetik = selesaikan teks dulu (seperti klik); Esc saat idle = buka menu. */
    if (this._gameStarted && !this.coldOpen) {
      if (this.typing) this.finishTyping();
      else this.openGameMenu();
    }
    return;
  }
  if (e.key >= "1" && e.key <= "9") {
    var btns = document.querySelectorAll("#story .btn-choice");
    var i = parseInt(e.key, 10) - 1;
    if (btns[i]) { btns[i].click(); }
  }
};

/* ============ Bridge event drain ============ */
UI.drainBridgeEvents = function () {
  var evs = Bridge.drainEvents();
  for (var i = 0; i < evs.length; i++) this.handleEvent(evs[i]);
  this.renderHUD();
  this.pumpQueues();
};

UI.handleEvent = function (ev) {
  switch (ev.t) {
    case "toast":
      this.toast(Bridge.L(ev.msg), ev.kind);
      break;
    case "float":
      this.floatText(ev.text, ev.kind);
      break;
    case "sfx":
      try { AudioSys.sfx(ev.id); } catch (e) {}
      break;
    case "hud":
      break; /* batched at end of drain */
    case "achv":
      this.achvToastQueue.push(ev.id);
      break;
    case "tutpop":
      this.eventQueue.push(ev);
      break;
    case "checkpoint":
      this.onCheckpoint(ev.name);
      break;
    case "faint":
      this.eventQueue.push(ev);
      break;
    case "death":
      this.onDeath(ev.reason);
      break;
  }
};

/* Modal-grade events are shown one at a time, in order. */
UI.pumpQueues = function () {
  var self = this;
  /* achievement toasts first */
  if (!this.achvToastShowing && this.achvToastQueue.length) {
    var id = this.achvToastQueue.shift();
    this.showAchvToast(id, function () { self.pumpQueues(); });
    return;
  }
  if (this._modalOpen) return;
  var ev = this.eventQueue.shift();
  if (!ev) return;
  if (ev.t === "tutpop") this.showTutPop(ev.id, function () { self.pumpQueues(); });
  else if (ev.t === "faint") this.showFaint(ev, function () { self.pumpQueues(); });
};

/* ============ Checkpoint ============ */
UI.onCheckpoint = function (name) {
  var self = this;
  if (Bridge.takeCheckpoint(name)) {
    /* attach the current view so respawn re-renders faithfully */
    var cp = Bridge.checkpoints[name];
    if (cp && this.lastCheckpointView) cp.view = JSON.parse(JSON.stringify(this.lastCheckpointView));
    this.toast(t("checkpoint_saved") + ": " + name, "good");
    try { AudioSys.sfx("checkpoint"); } catch (e) {}
    /* autosave */
    try {
      var raw = Bridge.serialize();
      localforage.setItem("asylum_v2_auto", raw).catch(function () {});
    } catch (e) {}
  }
};

/* ============ Death ============ */
UI.onDeath = function (reason) {
  if (this.dead) return;
  this.dead = true;
  this.stopTypewriter();
  var self = this;
  var text = reason === "faint"
    ? Bridge.L(Bridge.FAINT_TEXT.killed)
    : t("death_story");
  setTimeout(function () { self.showDeath(text); }, 900);
};

UI.showDeath = function (text) {
  var self = this;
  document.body.classList.add("dead-veil");
  var root = $("#modal-root");
  root.innerHTML = "";
  var m = el("div", "modal-open death-screen");
  m.innerHTML =
    '<div class="death-inner">' +
      '<div class="death-title">' + esc(t("death_title")) + '</div>' +
      '<p class="death-text">' + esc(text) + '</p>' +
      '<div class="death-count">' + esc(t("death_count")) + ': <b>' + Bridge.S.deaths + '</b></div>' +
      '<div class="btnrow">' +
        ((Bridge.hasCheckpoint() || Bridge.respawnTargetFor(Bridge.deathKnot))
          ? '<button class="btn-choice big" id="btnRespawn">' + esc(t("respawn")) + '</button>'
          : "") +
        '<button class="btn-choice big ghost" id="btnRestart">' + esc(t("restart")) + '</button>' +
        '<button class="btn-choice big ghost" id="btnMenu">' + esc(t("menu")) + '</button>' +
      '</div>' +
    '</div>';
  root.appendChild(m);
  this._modalOpen = true;
  var rs = $("#btnRespawn");
  if (rs) rs.onclick = function () { self.respawn(); };
  $("#btnRestart").onclick = function () { self.hideDeath(function () { self.startNew(); }); };
  $("#btnMenu").onclick = function () {
    self.hideDeath(function () {
      document.body.classList.remove("dead-veil");
      $("#hud").classList.remove("visible");
      $("#dock").classList.remove("visible");
      self.showTitle();
    });
  };
};

UI.hideDeath = function (cb) {
  document.body.classList.remove("dead-veil");
  $("#modal-root").innerHTML = "";
  this._modalOpen = false;
  if (cb) cb();
};

/* Jump the story to a named knot; if the knot is missing, show death instead. */
UI.gotoKnotOrDeath = function (knot, deathReason) {
  var ok = true;
  try { this.story.ChoosePathString(knot); }
  catch (e) { ok = false; }
  if (ok) {
    this.kicker = ""; this.tag = "";
    this.advance(); /* renderKnot wraps its own cinematic transition */
  } else {
    this.onDeath(deathReason || "story");
  }
};

/* ============ Faint interlude ============ */
UI.showFaint = function (ev, done) {
  var self = this;
  var txt = Bridge.L(Bridge.FAINT_TEXT[ev.outcome] || Bridge.FAINT_TEXT.safe);
  if (ev.outcome === "stolen" && ev.item) {
    txt += " (" + Bridge.itemName(ev.item) + ")";
  }
  this.openModal(
    '<div class="faint-inner">' +
      '<div class="modal-kicker">' + esc(t("faint_title")) + '</div>' +
      '<p>' + esc(txt) + '</p>' +
      '<div class="btnrow"><button class="btn-choice big" id="mOk">' + esc(t("understood")) + '</button></div>' +
    '</div>',
    function (root) {
      $("#mOk", root).onclick = function () {
        self.closeModal();
        /* killed-by-faint: the story continues at the faint_killed knot,
           which itself calls ~ DEATH(). */
        if (ev.outcome === "killed") self.gotoKnotOrDeath("faint_killed", "faint");
        done();
      };
    }
  );
};

/* ============ Tutorial popup (single) ============ */
UI.showTutPop = function (id, done) {
  var self = this;
  var d = Bridge.TUT_POP_DEX[id];
  var title = d ? Bridge.L(d.title) : id;
  var body = d ? Bridge.L(d.body) : "";
  this.openModal(
    '<div class="tutpop-inner">' +
      '<div class="modal-kicker">' + esc(title) + '</div>' +
      '<p>' + body + '</p>' +
      '<div class="btnrow"><button class="btn-choice big" id="mOk">' + esc(t("understood")) + '</button></div>' +
    '</div>',
    function (root) {
      $("#mOk", root).onclick = function () { self.closeModal(); done(); };
    }
  );
};

/* ============ Full tutorial ============ */
UI.openTutorial = function (done) {
  var self = this, idx = 0;
  var render = function () {
    var st = TUT_STEPS[idx], last = idx === TUT_STEPS.length - 1;
    var dots = TUT_STEPS.map(function (_, k) {
      return '<span class="' + (k === idx ? "on" : k < idx ? "done" : "") + '"></span>';
    }).join("");
    self.openModal(
      '<div class="tut-inner">' +
        '<div class="tut-progress">' + esc(tf("tut_progress", idx + 1, TUT_STEPS.length)) + '</div>' +
        '<div class="tut-dots">' + dots + '</div>' +
        '<h2>' + esc(Bridge.L(st.t)) + '</h2>' +
        '<div class="tut-body">' + Bridge.L(st.h) + '</div>' +
        '<div class="btnrow">' +
          (idx > 0 ? '<button class="btn-choice ghost" id="mBack">' + esc(t("back")) + '</button>' : "") +
          (!last ? '<button class="btn-choice big" id="mNext">' + esc(t("next")) + '</button>'
                 : '<button class="btn-choice big primary" id="mNext">' + esc(t("tut_start")) + '</button>') +
        '</div>' +
        '<div class="center"><button class="mini-btn" id="mSkip">' + esc(t("skip")) + '</button></div>' +
      '</div>',
      function (root) {
        var nx = $("#mNext", root), bk = $("#mBack", root), sk = $("#mSkip", root);
        if (nx) nx.onclick = function () {
          if (last) { Bridge.S.tutDone = true; self.closeModal(); done(); }
          else { idx++; render(); }
        };
        if (bk) bk.onclick = function () { idx--; render(); };
        if (sk) sk.onclick = function () { Bridge.S.tutDone = true; self.closeModal(); done(); };
      }
    );
  };
  render();
};

/* ============ Modal plumbing ============ */
UI.openModal = function (html, wire) {
  var root = $("#modal-root");
  root.innerHTML = "";
  var m = el("div", "modal-open modal-veil");
  m.innerHTML = '<div class="modal-card">' + html + "</div>";
  root.appendChild(m);
  this._modalOpen = true;
  var self = this;
  m.addEventListener("pointerdown", function (e) {
    if (e.target === m) { self.closeModal(); self.pumpQueues(); }
  });
  if (wire) wire(m);
};

UI.closeModal = function () {
  $("#modal-root").innerHTML = "";
  this._modalOpen = false;
};

/* ============ Inventory ============ */
UI.openInventory = function () {
  var self = this;
  var S = Bridge.S;
  var rows = (S.items || []).map(function (it) {
    var dex = Bridge.itemDex(it.id);
    var name = dex ? Bridge.L(dex.name) : it.id;
    var note = dex ? Bridge.L(dex.note || dex.desc) : "";
    var icon = dex ? dex.icon : "❔";
    var btns = "";
    if (dex && dex.use) btns += '<button class="mini-btn" data-use="' + esc(it.id) + '">' + esc(t("inv_use")) + '</button>';
    if (dex && dex.slot && dex.kind !== "story") btns += '<button class="mini-btn" data-equip="' + esc(it.id) + '">' + esc(t("inv_equip")) + '</button>';
    return '<div class="inv-row">' +
      '<span class="inv-icon">' + icon + '</span>' +
      '<span class="inv-meta"><b>' + esc(name) + '</b> <i>×' + (it.qty || 1) + '</i><br><small>' + esc(note) + '</small></span>' +
      '<span class="inv-btns">' + btns + '</span></div>';
  }).join("");

  var eqRows = Bridge.EQ_SLOTS.map(function (slot) {
    var cur = (S.equipment || {})[slot.key];
    var right;
    if (cur) {
      var dex = Bridge.itemDex(cur.id);
      right = '<span class="eq-item">' + (dex ? dex.icon : "❔") + " " + esc(Bridge.itemName(cur.id)) + '</span>' +
        '<button class="mini-btn danger" data-unequip="' + esc(slot.key) + '">' + esc(t("inv_unequip")) + '</button>';
    } else {
      right = '<span class="eq-empty">' + esc(t("eq_empty")) + '</span>';
    }
    return '<div class="eq-row"><span>' + slot.icon + " " + esc(Bridge.L(slot.name)) + '</span><span class="eq-right">' + right + '</span></div>';
  }).join("");

  this.openModal(
    '<div class="modal-kicker">' + esc(t("inv_title")) + '</div>' +
    '<div class="eq-block"><div class="eq-title">' + esc(t("eq_title")) + '</div>' + eqRows + '</div>' +
    '<div class="inv-list">' + (rows || '<p class="dim">' + esc(t("inv_empty")) + '</p>') + '</div>' +
    '<div class="btnrow"><button class="btn-choice ghost" id="mClose">' + esc(t("close")) + '</button></div>',
    function (root) {
      $("#mClose", root).onclick = function () { self.closeModal(); self.pumpQueues(); };
      root.querySelectorAll("[data-use]").forEach(function (b) {
        b.onclick = function () {
          Bridge.useItem(b.getAttribute("data-use"));
          self.renderHUD(); self.openInventory();
        };
      });
      root.querySelectorAll("[data-equip]").forEach(function (b) {
        b.onclick = function () {
          Bridge.equipItem(b.getAttribute("data-equip"));
          self.renderHUD(); self.openInventory();
        };
      });
      root.querySelectorAll("[data-unequip]").forEach(function (b) {
        b.onclick = function () {
          Bridge.unequipItem(b.getAttribute("data-unequip"));
          self.renderHUD(); self.openInventory();
        };
      });
    }
  );
};

/* ============ Achievements ============ */
UI.openAchievements = function () {
  var self = this;
  var S = Bridge.S;
  var cards = Bridge.ACHV.map(function (a) {
    var un = !!(S.achv && S.achv[a.id]);
    return '<div class="achv-card' + (un ? " un" : "") + '">' +
      '<div class="achv-icon">' + (un ? a.icon : "🔒") + '</div>' +
      '<div class="achv-name">' + esc(un ? Bridge.L(a.name) : t("achv_locked")) + '</div>' +
      (un ? '<div class="achv-desc">' + esc(Bridge.L(a.desc)) + '</div>' : "") +
      '</div>';
  }).join("");
  this.openModal(
    '<div class="modal-kicker">' + esc(t("achv_title")) + ' · ' +
      Object.keys(S.achv || {}).length + "/" + Bridge.ACHV.length + '</div>' +
    '<div class="achv-grid">' + cards + '</div>' +
    '<div class="btnrow"><button class="btn-choice ghost" id="mClose">' + esc(t("close")) + '</button></div>',
    function (root) {
      $("#mClose", root).onclick = function () { self.closeModal(); self.pumpQueues(); };
    }
  );
};

UI.showAchvToast = function (id, done) {
  var a = Bridge.achvDex(id);
  if (!a) { done(); return; }
  this.achvToastShowing = true;
  var box = $("#toasts");
  var d = el("div", "toast achv-toast");
  d.innerHTML = '<span class="ai">' + a.icon + '</span>' +
    '<span><b>' + esc(t("achv_unlocked_title")) + '</b><br>' + esc(Bridge.L(a.name)) + '</span>';
  box.appendChild(d);
  var self = this;
  setTimeout(function () {
    d.classList.add("out");
    setTimeout(function () { if (d.remove) d.remove(); }, 500);
    self.achvToastShowing = false;
    done();
  }, 2600);
};

/* ============ Save / Load ============ */
UI.slotKey = function (n) { return "asylum_v2_slot_" + n; };

UI.openSave = function () {
  var self = this;
  var rows = [1, 2, 3].map(function (n) {
    return '<div class="save-row" data-slot="' + n + '">' +
      '<span class="save-meta"><i>' + esc(t("slot_empty")) + '</i></span>' +
      '<span class="save-btns">' +
        '<button class="mini-btn" data-act="save">' + esc(t("slot_save")) + '</button>' +
        '<button class="mini-btn" data-act="load" disabled>' + esc(t("slot_load")) + '</button>' +
        '<button class="mini-btn danger" data-act="del" disabled>✕</button>' +
      '</span></div>';
  }).join("");
  this.openModal(
    '<div class="modal-kicker">' + esc(t("save_title")) + '</div>' +
    '<p class="dim small">' + esc(t("autosave_note")) + '</p>' +
    '<div class="save-list">' + rows + '</div>' +
    '<div class="btnrow"><button class="btn-choice ghost" id="mClose">' + esc(t("close")) + '</button></div>',
    function (root) {
      $("#mClose", root).onclick = function () { self.closeModal(); self.pumpQueues(); };
      [1, 2, 3].forEach(function (n) { self.refreshSlotRow(root, n); });
      root.querySelectorAll(".save-row").forEach(function (row) {
        var n = parseInt(row.getAttribute("data-slot"), 10);
        row.querySelector('[data-act="save"]').onclick = function () { self.saveToSlot(n); };
        row.querySelector('[data-act="load"]').onclick = function () { self.loadFromSlot(n); };
        row.querySelector('[data-act="del"]').onclick = function () {
          if (!window.confirm(t("delete_confirm"))) return;
          try {
            localforage.removeItem(self.slotKey(n)).then(function () { self.refreshSlotRow(root, n); });
          } catch (e) {}
        };
      });
    }
  );
};

UI.refreshSlotRow = function (root, n) {
  var row = root.querySelector('.save-row[data-slot="' + n + '"]');
  if (!row) return;
  var meta = row.querySelector(".save-meta");
  var btnLoad = row.querySelector('[data-act="load"]');
  var btnDel = row.querySelector('[data-act="del"]');
  try {
    localforage.getItem(this.slotKey(n)).then(function (raw) {
      if (!raw) {
        meta.innerHTML = "<i>" + esc(t("slot_empty")) + "</i>";
        btnLoad.disabled = true; btnDel.disabled = true;
        return;
      }
      var label = "", d = null;
      try {
        var parsed = JSON.parse(raw);
        d = parsed.state || {};
        label = (parsed.lang === "en" ? "EN · " : "ID · ") +
          (d.deaths || 0) + "☠ · " + (d.knotsVisited || 0) + " " + t("knots");
        if (parsed.at) label += " · " + new Date(parsed.at).toLocaleDateString();
      } catch (e) { label = t("slot_saved"); }
      meta.textContent = label;
      btnLoad.disabled = false; btnDel.disabled = false;
    }).catch(function () {});
  } catch (e) {}
};

UI.saveToSlot = function (n) {
  var self = this;
  var doSave = function () {
    try {
      var raw = Bridge.serialize();
      /* stamp save time */
      var stamped;
      try {
        var p = JSON.parse(raw); p.at = Date.now(); stamped = JSON.stringify(p);
      } catch (e) { stamped = raw; }
      localforage.setItem(self.slotKey(n), stamped).then(function () {
        self.toast(t("slot_saved"), "good");
        var root = $("#modal-root");
        if (root) self.refreshSlotRow(root, n);
      }).catch(function () {});
    } catch (e) {}
  };
  try {
    localforage.getItem(this.slotKey(n)).then(function (raw) {
      if (raw && !window.confirm(t("save_confirm_overwrite"))) return;
      doSave();
    }).catch(doSave);
  } catch (e) { doSave(); }
};

UI.loadFromSlot = function (n) {
  var self = this;
  try {
    localforage.getItem(this.slotKey(n)).then(function (raw) {
      if (!raw) return;
      self.closeModal();
      self.loadFromSerialized(raw);
    }).catch(function () {});
  } catch (e) {}
};

/* ============ Ending ============ */
UI.showEnding = function () {
  var self = this;
  var area = $("#story");
  var d = el("div", "ending");
  d.innerHTML =
    '<div class="end-title">' + esc(t("end_title")) + '</div>' +
    '<p class="dim">' + esc(t("end_sub")) + '</p>' +
    '<div class="end-stats">' + esc(t("end_stats")) + ': ' +
      esc(t("death_count")) + ' <b>' + Bridge.S.deaths + '</b> · ' +
      esc(t("knots")) + ' <b>' + Bridge.S.knotsVisited + '</b></div>' +
    '<div class="btnrow">' +
      '<button class="btn-choice big" id="btnAgain">' + esc(t("play_again")) + '</button>' +
      '<button class="btn-choice big ghost" id="btnMenu2">' + esc(t("menu")) + '</button>' +
    '</div>';
  area.appendChild(d);
  $("#btnAgain").onclick = function () { self.startNew(); };
  $("#btnMenu2").onclick = function () {
    $("#hud").classList.remove("visible");
    $("#dock").classList.remove("visible");
    self.showTitle();
  };
  try { AudioSys.setAmbient("title"); } catch (e) {}
};

/* ============ Toasts & floats ============ */
UI.toast = function (msg, kind) {
  var box = $("#toasts");
  var d = el("div", "toast" + (kind ? " " + kind : ""));
  d.textContent = msg;
  box.appendChild(d);
  setTimeout(function () {
    d.classList.add("out");
    setTimeout(function () { if (d.remove) d.remove(); }, 500);
  }, 3000);
  while (box.children.length > 4) box.removeChild(box.firstChild);
};

UI.floatText = function (text, kind) {
  if (reducedMotion()) return;
  var s = el("span", "efloat " + (kind || ""), esc(text) + " ⚡");
  s.style.left = (window.innerWidth - 90) + "px";
  s.style.top = "86px";
  document.body.appendChild(s);
  setTimeout(function () { if (s.remove) s.remove(); }, 1000);
};

/* ============ HUD ============ */
UI.updateLocation = function () {
  var loc = $("#hud-loc");
  if (loc) loc.textContent = this.tag || "";
  /* cinematic title card when entering a new location */
  if (this.tag && this.tag !== this._lastTag) {
    var first = !this._lastTag;
    this._lastTag = this.tag;
    if (!first && this._gameStarted) {
      try { this.showLocCard(this.tag); } catch (e) {}
    }
  }
};

UI.renderHUD = function () {
  var S = Bridge.S;
  if (!S) return;
  /* mental */
  var mWrap = $("#hud-mental");
  if (mWrap) {
    var segs = "";
    for (var i = 0; i < 5; i++) segs += '<span class="mseg' + (i <= S.mental ? " on m" + S.mental : "") + '"></span>';
    mWrap.innerHTML = '<label>' + esc(t("hud_mental")) + '</label>' +
      '<div class="mbar">' + segs + '</div>' +
      '<span class="mname">' + esc(Bridge.mentalName()) + '</span>';
  }
  /* status pill */
  var pill = $("#hud-status");
  if (pill) {
    var st = S.status || "safe";
    pill.className = "status-pill st-" + st;
    pill.textContent = Bridge.statusName();
    /* atmosphere follows the body: danger flickers the light, wounds bleed the edges */
    document.body.classList.toggle("st-danger", st === "danger");
    document.body.classList.toggle("st-wounded", st === "wounded");
  }
  /* energy */
  var bar = $("#hud-energy-fill");
  if (bar) {
    var e = S.energy == null ? 100 : S.energy;
    bar.style.width = e + "%";
    bar.className = "fill et-" + Bridge.energyTier();
  }
  var eNum = $("#hud-energy-num");
  if (eNum) eNum.textContent = Math.round(S.energy == null ? 100 : S.energy);
  /* body tiers */
  var tiers = $("#hud-tiers");
  if (tiers) {
    var html = "";
    Bridge.TIER_STATS.forEach(function (s) {
      var tv = Bridge.tierGet(s);
      if (tv >= 0) {
        html += '<span class="tier-chip tl' + tv + '">' + esc(Bridge.tierStatName(s)) +
          ' · ' + esc(Bridge.tierName(tv)) + '</span>';
      }
    });
    tiers.innerHTML = html;
    tiers.style.display = html ? "" : "none";
  }
  /* emotions + temp */
  var fx = $("#hud-fx");
  if (fx) {
    var fh = "";
    for (var k in (S.emotions || {})) {
      fh += '<span class="fx-chip emo">' + esc(Bridge.emotionName(k)) + " " + "●".repeat(S.emotions[k]) + "</span>";
    }
    (S.temp || []).forEach(function (tmp) {
      fh += '<span class="fx-chip tmp">' + esc(tmp.n) + " (" + tmp.left + ")</span>";
    });
    fx.innerHTML = fh;
    fx.style.display = fh ? "" : "none";
  }
  /* death count */
  var dc = $("#hud-deaths");
  if (dc) dc.textContent = "☠ " + S.deaths;
  this.updateLocation();
};

/* ============ Game menu (F1: navigasi persisten) ============ */
UI.openGameMenu = function () {
  var self = this;
  var rows =
    '<button class="menu-row" id="mResume"><span class="mr-ic">▶</span><span>' + esc(t("continue")) + '</span></button>' +
    '<button class="menu-row" id="mSettings"><span class="mr-ic">⚙</span><span>' + esc(t("settings")) + '</span></button>' +
    '<button class="menu-row" id="mSave"><span class="mr-ic">💾</span><span>' + esc(t("save_title")) + '</span></button>' +
    '<button class="menu-row" id="mTitle"><span class="mr-ic">⌂</span><span>' + esc(t("back_to_title")) + '</span></button>' +
    '<button class="menu-row hub" id="mHub"><span class="mr-ic">⛩</span><span>' + esc(t("back_to_hub")) + '</span></button>';
  this.openModal(
    '<div class="modal-kicker">' + esc(t("game_menu")) + '</div>' +
    '<div class="menu-list">' + rows + '</div>',
    function (root) {
      $("#mResume", root).onclick = function () { self.closeModal(); self.pumpQueues(); };
      $("#mSettings", root).onclick = function () { self.openSettings(); };
      $("#mSave", root).onclick = function () { self.openSave(); };
      $("#mTitle", root).onclick = function () {
        if (Bridge.S && (Bridge.S.knotsVisited > 1 || (Bridge.S.items || []).length > 0)) {
          if (!window.confirm(t("quit_to_title_confirm"))) return;
        }
        self.closeModal();
        self.stopTypewriter();
        $("#hud").classList.remove("visible");
        $("#dock").classList.remove("visible");
        self.showTitle();
      };
      $("#mHub", root).onclick = function () { window.location.href = "../"; };
    }
  );
};

UI.openSettings = function () {
  var self = this;
  var muted = false;
  try { muted = AudioSys.isMuted(); } catch (e) {}
  var spd = (Bridge.settings && Bridge.settings.textSpeed) || DEFAULT_TEXT_SPEED;
  var seg = function (name, opts, cur) {
    return '<div class="seg" data-seg="' + name + '">' + opts.map(function (o) {
      return '<button type="button" class="' + (o.v === cur ? "on" : "") + '" data-val="' + o.v + '">' + esc(o.l) + '</button>';
    }).join("") + '</div>';
  };
  this.openModal(
    '<div class="modal-kicker">' + esc(t("settings")) + '</div>' +
    '<div class="set-row"><span>' + esc(t("language")) + '</span>' +
      seg("lang", [{ v: "id", l: "ID" }, { v: "en", l: "EN" }], self.lang) + '</div>' +
    '<div class="set-row"><span>' + esc(t("sound")) + '</span>' +
      seg("mute", [{ v: "on", l: t("sound_on") }, { v: "off", l: t("sound_off") }], muted ? "off" : "on") + '</div>' +
    '<div class="set-row"><span>' + esc(t("text_speed")) + '</span>' +
      seg("speed", [
        { v: "lambat", l: t("speed_lambat") },
        { v: "normal", l: t("speed_normal") },
        { v: "cepat", l: t("speed_cepat") }
      ], spd) + '</div>' +
    '<div class="btnrow"><button class="btn-choice ghost" id="mBack">' + esc(t("back")) + '</button></div>',
    function (root) {
      $("#mBack", root).onclick = function () { self.openGameMenu(); };
      root.querySelectorAll(".seg").forEach(function (s) {
        var name = s.getAttribute("data-seg");
        s.querySelectorAll("button").forEach(function (b) {
          b.onclick = function () {
            var v = b.getAttribute("data-val");
            s.querySelectorAll("button").forEach(function (x) { x.classList.remove("on"); });
            b.classList.add("on");
            if (name === "lang") {
              if (v !== self.lang) {
                self.toggleLang();
                try { $("#dock-lang").textContent = self.lang === "id" ? "EN" : "ID"; } catch (e) {}
                self.renderHUD();
              }
            } else if (name === "mute") {
              var wantMute = (v === "off");
              try { if (AudioSys.isMuted() !== wantMute) AudioSys.toggleMute(); } catch (e) {}
              try { $("#dock-mute").textContent = wantMute ? "🔇" : "🔊"; } catch (e) {}
            } else if (name === "speed") {
              try { Bridge.setTextSpeed(v); } catch (e) {}
            }
          };
        });
      });
    }
  );
};

/* ============ Dock (bottom bar) ============ */
UI.wireDock = function () {
  var self = this;
  $("#dock-menu").onclick = function () { self.openGameMenu(); };
  $("#dock-inv").onclick = function () { self.openInventory(); };
  $("#dock-achv").onclick = function () { self.openAchievements(); };
  $("#dock-save").onclick = function () { self.openSave(); };
  $("#dock-mute").onclick = function () {
    var m = AudioSys.toggleMute();
    $("#dock-mute").textContent = m ? "🔇" : "🔊";
  };
  $("#dock-lang").onclick = function () {
    self.toggleLang();
    $("#dock-lang").textContent = self.lang === "id" ? "EN" : "ID";
    /* rebuild current screen texts where cheap */
    self.renderHUD();
  };
};

/* ---------------- Boot ---------------- */
document.addEventListener("DOMContentLoaded", function () {
  UI.wireDock();
  UI.init();
});

if (typeof window !== "undefined") window.UI = UI;
if (typeof module !== "undefined" && module.exports) module.exports = UI;

})();
