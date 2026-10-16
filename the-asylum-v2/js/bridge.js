/* =========================================================================
 * The Asylum v2 — bridge.js
 * Mechanical state + ink EXTERNAL bindings.
 *
 * Owns: mental (5 levels), body tiers (4 stats x 4 tiers), energy (0-100),
 * emotions, temporary effects, status/body, inventory + equipment slot,
 * NPC favor, achievements (14), death count + checkpoints, tutorial popups.
 *
 * UI communication is one-way via Bridge.events (queued, drained by ui.js).
 * No DOM access here — this file is logic-only and testable in node.
 * ========================================================================= */
(function () {
"use strict";

/* ---------------- Static data ---------------- */

var MENTAL_L = {
  id: ["Tenang", "Tegang", "Gelisah", "Panik", "Hancur"],
  en: ["Calm", "Tense", "Uneasy", "Panicked", "Shattered"]
};
var TIER_L = {
  id: ["Ringan", "Sedang", "Tinggi", "Ekstrim"],
  en: ["Mild", "Moderate", "Severe", "Extreme"]
};
var TIER_STATS = ["Stress", "Keracunan", "Pendarahan", "Kelelahan"];
var TIER_STAT_L = {
  id: { Stress: "Stress", Keracunan: "Keracunan", Pendarahan: "Pendarahan", Kelelahan: "Kelelahan" },
  en: { Stress: "Stress", Keracunan: "Poisoning", Pendarahan: "Bleeding", Kelelahan: "Exhaustion" }
};
var EMOTION_L = {
  id: { Takut: "Takut", Sedih: "Sedih", Lega: "Lega" },
  en: { Takut: "Fear", Sedih: "Grief", Lega: "Relief" }
};
var STATUS_L = {
  id: { safe: "Aman", danger: "Bahaya", wounded: "Terluka" },
  en: { safe: "Safe", danger: "Danger", wounded: "Wounded" }
};
var FAINT_W = { killed: 15, stolen: 30, wounded: 25, safe: 30 };
var ENERGY_PER_KNOT = 3;   /* energy cost per story knot visited */
var MAX_ITEMS_STACK = 99;

var ITEM_DEX = [
  { id: "roti_kering", icon: "🍞",
    name: { id: "Roti Kering", en: "Hardtack" },
    desc: { id: "Tiga potong roti kering dalam kemasan plastik.", en: "Three pieces of hardtack in a plastic wrapper." },
    note: { id: "PAKAI: +15 Energi", en: "USE: +15 Energy" },
    use: { energy: 15 } },
  { id: "surat_terlipat", icon: "💌",
    name: { id: "Surat Terlipat", en: "Folded Letter" },
    desc: { id: "Surat yang tak pernah terkirim. \u2018Maafkan aku...\u2019", en: "A letter never sent. \u2018Forgive me...\u2019" },
    note: { id: "Surat yang tak terkirim — PAKAI: baca", en: "An unsent letter — USE: read" },
    use: { mentalBetter: 1, addEmotion: [{ n: "Sedih", amt: 1 }] }, onUseAchv: "reader" },
  { id: "perban_kotor", icon: "🩹",
    name: { id: "Perban Kotor", en: "Dirty Bandage" },
    desc: { id: "Kain pembalut bernoda — lebih baik daripada tidak sama sekali.", en: "A stained bandage — better than nothing." },
    note: { id: "PAKAI: sembuhkan luka, tapi kotor", en: "USE: heal wounds, but filthy" },
    use: { heal: true, tierUp: ["Keracunan"] }, onUseAchv: "wounded_heal" },
  { id: "cokelat", icon: "🍫",
    name: { id: "Cokelat Batangan", en: "Chocolate Bar" },
    desc: { id: "Manis. Penenang yang langka di tempat seperti ini.", en: "Sweet. A rare comfort in a place like this." },
    note: { id: "PAKAI: +20 Energi, -1 Stress", en: "USE: +20 Energy, -1 Stress" },
    use: { energy: 20, tierDown: ["Stress"] } },
  { id: "boneka", icon: "🧸", story: true,
    name: { id: "Boneka Beruang", en: "Teddy Bear" },
    desc: { id: "Boneka lusuh bermata kancing. Kenapa kau membawanya?", en: "A shabby button-eyed bear. Why did you bring it?" },
    note: { id: "Boneka lusuh — entah kenapa kau membawanya", en: "A shabby bear — you don't know why you carry it" } },
  { id: "gambar_crayon", icon: "🖍️",
    name: { id: "Gambar Crayon", en: "Crayon Drawing" },
    desc: { id: "Gambar keluarga dengan crayon — ayah, ibu, dan anak.", en: "A crayon family drawing — father, mother, and child." },
    note: { id: "Gambar keluarga — PAKAI: renungkan", en: "A family drawing — USE: reflect" },
    use: { mentalBetter: 1, addEmotion: [{ n: "Sedih", amt: 1 }] } },
  { id: "koin_logam", icon: "🪙", story: true,
    name: { id: "Koin Logam Kusam", en: "Tarnished Metal Coin" },
    desc: { id: "Koin tua yang sangat kusam. Tidak istimewa — tapi nyata.", en: "A very tarnished old coin. Nothing special — but real." },
    note: { id: "Barang tak berguna", en: "A useless trinket" } },
  { id: "catatan_eksperimen", icon: "📜", story: true,
    name: { id: "Catatan Eksperimen", en: "Experiment Notes" },
    desc: { id: "Catatan mengerikan tentang \u2018Eksperimen Subjek ke-X\u2019. Mungkin ada kelemahan di dalamnya.", en: "Gruesome notes on the \u2018Subject X Experiments\u2019. There might be a weakness hidden in them." },
    note: { id: "Catatan mengerikan — mungkin ada gunanya", en: "Gruesome notes — they might be useful" } }
];

var ACHV = [
  { id: "wake_up",      icon: "🌅",
    name: { id: "Terbangun", en: "The Awakening" },
    desc: { id: "Matamu terbuka — dan dunia ini tidak lagi sama.", en: "Your eyes opened — and this world was never the same." } },
  { id: "first_death",  icon: "🩸",
    name: { id: "Darah Pertama", en: "First Blood" },
    desc: { id: "Kegelapan mencicipimu untuk pertama kali.", en: "The Darkness tasted you for the first time." } },
  { id: "five_deaths",  icon: "💀",
    name: { id: "Lima Kematian", en: "Five Deaths" },
    desc: { id: "Kegelapan mulai menghafal namamu.", en: "The Darkness is beginning to memorize your name." } },
  { id: "trap_victim",  icon: "💡",
    name: { id: "Terang yang Menipu", en: "The Deceiving Light" },
    desc: { id: "Kau berlari menuju cahaya. Cahaya itu berlari ke arahmu.", en: "You ran toward the light. The light ran toward you." } },
  { id: "smart_cross",  icon: "🌑",
    name: { id: "Bayangan yang Cerdik", en: "The Cunning Shadow" },
    desc: { id: "Kau menjadi satu dengan gelap — dan gelap membiarkanmu lewat.", en: "You became one with the dark — and the dark let you pass." } },
  { id: "frozen",       icon: "🧊",
    name: { id: "Diam Adalah Hidup", en: "Stillness Is Life" },
    desc: { id: "Ia lewat. Kau tidak bernapas. Kau masih di sini.", en: "It passed by. You did not breathe. You are still here." } },
  { id: "teddy_friend", icon: "🧸",
    name: { id: "Teman di Kegelapan", en: "A Friend in the Darkness" },
    desc: { id: "Di tempat tanpa siapa pun, kau memilih untuk tidak sendirian.", en: "In a place with no one, you chose not to be alone." } },
  { id: "teddy_dropped",icon: "🗑️",
    name: { id: "Tak Butuh Kenangan", en: "No Need for Memories" },
    desc: { id: "Beberapa hal lebih baik ditinggalkan.", en: "Some things are better left behind." } },
  { id: "explorer",     icon: "🗺️",
    name: { id: "Semua Pintu Terbuka", en: "All Doors Open" },
    desc: { id: "Rasa ingin tahumu lebih besar dari rasa takutmu. Untuk saat ini.", en: "Your curiosity outweighed your fear. For now." } },
  { id: "wounded_heal", icon: "🩹",
    name: { id: "Obat Kotor", en: "Filthy Remedy" },
    desc: { id: "Kau membalut lukamu dengan apa yang ada. Itu berhasil. Entah bagaimana.", en: "You dressed your wound with whatever was at hand. It worked. Somehow." } },
  { id: "reader",       icon: "💌",
    name: { id: "Surat yang Tak Terkirim", en: "The Unsent Letter" },
    desc: { id: "Kata-kata terakhir seseorang, akhirnya dibaca.", en: "Someone's last words, finally read." } },
  { id: "empty_tank",   icon: "🪫",
    name: { id: "Kelelahan Total", en: "Total Exhaustion" },
    desc: { id: "Energimu mencapai 0 untuk pertama kalinya.", en: "Your energy reached 0 for the first time." } },
  { id: "dice_fate",    icon: "🎲",
    name: { id: "Dadu Takdir", en: "Dice of Fate" },
    desc: { id: "Stress mencapai Ekstrim — pilihanmu diacak dadu.", en: "Stress reached Extreme — your choices are diced." } },
  { id: "lemas_body",   icon: "🥀",
    name: { id: "Tubuh Menyerah", en: "The Body Surrenders" },
    desc: { id: "Kelelahan mencapai Ekstrim — tubuhmu lemas.", en: "Exhaustion reached Extreme — your body gives out." } }
];

var EQ_SLOTS = [{ key: "senjata", name: { id: "Senjata", en: "Weapon" }, icon: "🗡" }];

/* Contextual tutorial popups (TUT_POP ids). Shown once each per run. */
var TUT_POP_DEX = {
  awal: {
    title: { id: "Kau terbangun di sini", en: "You wake up here" },
    body: {
      id: "Baca setiap adegan dengan teliti — petunjuk sering tersembunyi di detail kecil. Setiap pilihan menguras <b>Energi</b>; perhatikan kondisimu di bilah atas. Tidak ada tombol kembali.",
      en: "Read every scene carefully — clues often hide in small details. Every choice drains <b>Energy</b>; watch your condition in the top bar. There is no back button." } },
  tier_tutorial: {
    title: { id: "Kondisi Tubuh", en: "Body Condition" },
    body: {
      id: "Tubuhmu mencatat luka dalam empat jalur — <b>Stress, Keracunan, Pendarahan, Kelelahan</b> — masing-masing dari <b>Ringan</b> hingga <b>Ekstrim</b>. Di tingkat Ekstrim, tubuhmu mulai mengambil alih pilihanmu.",
      en: "Your body tracks harm across four tracks — <b>Stress, Poisoning, Bleeding, Exhaustion</b> — each from <b>Mild</b> to <b>Extreme</b>. At Extreme, your body starts making choices for you." } },
  energi: {
    title: { id: "Energi", en: "Energy" },
    body: {
      id: "Setiap langkah menguras energi. Saat mencapai <b>0</b>, tubuhmu tumbang — dan nasib yang menentukan apa yang terjadi selanjutnya. Makanlah selagi bisa.",
      en: "Every step drains energy. At <b>0</b>, your body collapses — and fate decides what happens next. Eat while you can." } },
  mental: {
    title: { id: "Kondisi Mental", en: "Mental State" },
    body: {
      id: "Pikiranmu bergerak dari <b>Tenang</b> hingga <b>Hancur</b>. Ia bisa memburuk <i>dan</i> membaik. Saat panik, pilihan yang membutuhkan ketenangan akan terkunci.",
      en: "Your mind moves from <b>Calm</b> to <b>Shattered</b>. It can worsen <i>and</i> recover. While panicking, choices that need composure stay locked." } },
  item: {
    title: { id: "Tas & Item", en: "Bag & Items" },
    body: {
      id: "Buka tas dengan tombol <b>🎒</b> di bawah. Makanan dan perban bisa <b>dipakai</b> langsung dari sana. Senjata harus dipasang di slot <b>perlengkapan</b> agar berguna.",
      en: "Open your bag with the <b>🎒</b> button below. Food and bandages can be <b>used</b> right from there. Weapons must be equipped in the <b>gear</b> slot to matter." } },
  wounded: {
    title: { id: "Terluka", en: "Wounded" },
    body: {
      id: "Kau <b>terluka</b>. Beberapa pilihan kini terkunci — tubuhmu tidak sanggup. Sembuhkan lukamu dengan perban atau beristirahatlah.",
      en: "You are <b>wounded</b>. Some choices are now locked — your body can't manage them. Heal with a bandage or rest." } }
};

var FAINT_TEXT = {
  killed: {
    id: "Kegelapan menelanku bulat-bulat. Aku pingsan... dan tidak pernah bangun.",
    en: "The darkness swallowed me whole. I fainted... and never woke up." },
  stolen: {
    id: "Aku pingsan. Saat sadar, tas terasa lebih ringan — sesuatu telah diambil.",
    en: "I fainted. When I woke, my bag felt lighter — something had been taken." },
  wounded: {
    id: "Aku pingsan dan terbanting keras. Ada yang tidak beres dengan tubuhku.",
    en: "I fainted and hit the ground hard. Something is wrong with my body." },
  safe: {
    id: "Aku pingsan. Entah berapa lama — tapi aku masih bernapas saat terbangun.",
    en: "I fainted. For how long, I don't know — but I was still breathing when I woke." }
};

var ENERGY_TIER_TEXT = {
  tired: {
    down: { id: "Tubuhmu mulai terasa berat. Napasmu memendek.", en: "Your body starts to feel heavy. Your breath shortens." },
    up:   { id: "Sedikit tenaga kembali ke tubuhmu.", en: "A little strength returns to your body." } },
  weary: {
    down: { id: "Kakimu gemetar. Kau butuh makan — segera.", en: "Your legs tremble. You need to eat — soon." },
    up:   { id: "Kakimu kembali mantap.", en: "Your legs steady again." } },
  critical: {
    down: { id: "Penglihatanmu berkunang. Sedikit lagi kau tumbang.", en: "Your vision swims. A little more and you'll collapse." },
    up:   { id: "Kunang-kunang di matamu mereda.", en: "The spots in your vision fade." } },
  empty: {
    down: { id: "Energimu habis. Tubuhmu bergerak atas kemauannya sendiri.", en: "Your energy is gone. Your body moves on its own now." },
    up:   { id: "Tenaga kembali mengalir. Kau bisa berpikir lagi.", en: "Strength flows back. You can think again." } },
  fit: {
    down: { id: "", en: "" },
    up:   { id: "Tubuhmu kembali bugar.", en: "Your body feels fit again." } }
};

/* ---------------- State ---------------- */

function defaultState() {
  var tiers = {};
  for (var i = 0; i < TIER_STATS.length; i++) tiers[TIER_STATS[i]] = -1;
  return {
    v: 2,
    mental: 0,
    tiers: tiers,
    energy: 100,
    emotions: {},
    temp: [],
    status: null,
    body: null,
    items: [],
    equipment: { senjata: null },
    favor: {},
    achv: {},
    deaths: 0,
    decayCount: 0,
    decayAt: 5 + Math.floor(Math.random() * 6),
    tutSeen: {},
    tutDone: false,
    lastFaint: null,
    knotsVisited: 0
  };
}

function clone(o) { return JSON.parse(JSON.stringify(o)); }

var Bridge = {
  S: null,
  story: null,
  events: [],
  checkpoints: {},      /* name -> { ink, state } */
  lastCheckpoint: null,
  deathKnot: null,      /* knot name captured when DEATH() fired */
  lang: "id",
  _statusSetThisKnot: false,
  _inFaint: false,

  /* ----- player settings (persisted separately from saves) ----- */
  settings: { textSpeed: "lambat" },
  loadSettings: function () {
    var self = this;
    try {
      return localforage.getItem("asylum_v2_settings").then(function (s) {
        var v = s && s.textSpeed;
        if (v === "lambat" || v === "normal" || v === "cepat") {
          self.settings.textSpeed = v;
        }
      }).catch(function () {});
    } catch (e) { return null; }
  },
  saveSettings: function () {
    try { localforage.setItem("asylum_v2_settings", this.settings).catch(function () {}); } catch (e) {}
  },
  setTextSpeed: function (v) {
    if (v === "lambat" || v === "normal" || v === "cepat") {
      this.settings.textSpeed = v;
      this.saveSettings();
    }
  },

  /* ----- lifecycle ----- */
  reset: function (lang) {
    this.S = defaultState();
    this.events = [];
    this.checkpoints = {};
    this.lastCheckpoint = null;
    this.deathKnot = null;
    this._inFaint = false;
    if (lang) this.lang = lang;
    return this.S;
  },
  attach: function (story) { this.story = story; },
  emit: function (ev) { this.events.push(ev); },
  drainEvents: function () { var e = this.events; this.events = []; return e; },

  L: function (obj) {
    if (obj == null) return "";
    if (typeof obj === "string") return obj;
    return obj[this.lang] || obj.id || obj.en || "";
  },

  /* ----- snapshots (CHECKPOINT / save slots) ----- */
  snapshotState: function () { return clone(this.S); },
  /* Restoring a checkpoint rewinds story state but NEVER rewinds
     meta-progress: death count and unlocked achievements persist. */
  restoreState: function (snap) {
    var keepDeaths = this.S ? (this.S.deaths || 0) : 0;
    var keepAchv = this.S ? clone(this.S.achv || {}) : {};
    this.S = clone(snap);
    this.S.deaths = Math.max(keepDeaths, this.S.deaths || 0);
    if (!this.S.achv) this.S.achv = {};
    for (var k in keepAchv) if (!this.S.achv[k]) this.S.achv[k] = keepAchv[k];
  },

  takeCheckpoint: function (name) {
    if (!this.story) return false;
    try {
      this.checkpoints[name] = {
        ink: this.story.state.ToJson(),
        state: this.snapshotState(),
        at: Date.now()
      };
      this.lastCheckpoint = name;
      return true;
    } catch (e) { return false; }
  },
  hasCheckpoint: function () { return !!this.lastCheckpoint && !!this.checkpoints[this.lastCheckpoint]; },

  serialize: function () {
    var inkJson = null;
    try { inkJson = this.story ? this.story.state.ToJson() : null; } catch (e) { inkJson = null; }
    return JSON.stringify({
      v: 2, lang: this.lang, state: this.S,
      ink: inkJson, checkpoints: this.checkpoints, lastCheckpoint: this.lastCheckpoint
    });
  },
  deserialize: function (json) {
    var d = JSON.parse(json);
    this.S = d.state;
    this.checkpoints = d.checkpoints || {};
    this.lastCheckpoint = d.lastCheckpoint || null;
    this.lang = d.lang || "id";
    this.events = [];
    return d.ink; /* caller loads it into the story */
  },

  /* ----- derived helpers ----- */
  mentalName: function () { return MENTAL_L[this.lang][Math.max(0, Math.min(4, this.S.mental))]; },

  /* Knot-name utilities. ink's compiled JSON drops ink comments, so
     knot-addressed data (choice locks, respawn targets) is hardcoded here.
     Paths look like "d5_1c.0.27" — the knot is the first component. */
  knotNameOf: function (pathStr) {
    var s = String(pathStr || "");
    var dot = s.indexOf(".");
    return dot < 0 ? s : s.slice(0, dot);
  },

  /* Hardcoded choice locks: knot -> [{index, locked(S)->bool}].
     d5_1c: [0] needs energy>=15, [1] needs mental<=Gelisah(2).
     Locked choices render greyed-out and unclickable (text states the req). */
  CHOICE_LOCKS: {
    d5_1c: [
      { index: 0, locked: function (S) { return (S.energy == null ? 100 : S.energy) < 15; } },
      { index: 1, locked: function (S) { return S.mental > 2; } }
    ]
  },
  lockedChoiceIndices: function (knot) {
    var rules = this.CHOICE_LOCKS[knot];
    if (!rules) return [];
    var S = this.S, out = [];
    for (var i = 0; i < rules.length; i++) {
      try { if (rules[i].locked(S)) out.push(rules[i].index); }
      catch (e) {}
    }
    return out;
  },

  /* Death-knot -> respawn-knot map (from the old game's respawn notes). */
  RESPAWN_MAP: { d5_trap: "hub_exit", s12_panic: "s12_hub" },
  respawnTargetFor: function (deathKnot) {
    return this.RESPAWN_MAP[deathKnot] || null;
  },
  tierName: function (t) { return t < 0 ? "—" : TIER_L[this.lang][Math.min(3, t)]; },
  tierStatName: function (s) { return (TIER_STAT_L[this.lang] || {})[s] || s; },
  emotionName: function (n) { return ((EMOTION_L[this.lang] || {})[n]) || n; },
  statusName: function () {
    var s = this.S.status;
    if (!s || s === "safe") return STATUS_L[this.lang].safe;
    return STATUS_L[this.lang][s] || s;
  },
  tierGet: function (name) {
    return (this.S.tiers && this.S.tiers[name] != null) ? this.S.tiers[name] : -1;
  },
  energyTier: function () {
    var e = this.S.energy == null ? 100 : this.S.energy;
    if (e <= 0) return "empty";
    if (e < 20) return "critical";
    if (e < 40) return "weary";
    if (e < 60) return "tired";
    return "fit";
  },
  isLemas: function () { return this.tierGet("Kelelahan") === 3; },
  isShaken: function () {
    return this.S.mental >= 3 || (this.S.emotions["Takut"] || 0) >= 2;
  },
  itemDex: function (id) {
    for (var i = 0; i < ITEM_DEX.length; i++) if (ITEM_DEX[i].id === id) return ITEM_DEX[i];
    return null;
  },
  itemName: function (id) {
    var d = this.itemDex(id);
    return d ? this.L(d.name) : id;
  },
  achvDex: function (id) {
    for (var i = 0; i < ACHV.length; i++) if (ACHV[i].id === id) return ACHV[i];
    return null;
  },
  faintStealable: function () {
    var eq = [];
    var eqObj = this.S.equipment || {};
    for (var k in eqObj) if (eqObj[k] && eqObj[k].id) eq.push(eqObj[k].id);
    return (this.S.items || []).filter(function (it) {
      if (!it) return false;
      var d = Bridge.itemDex(it.id);
      return !(d && d.story) && eq.indexOf(it.id) < 0;
    });
  },

  /* ================= EXTERNAL implementations ================= */

  mentalUp: function (n) {
    var S = this.S, before = S.mental;
    S.mental = Math.min(4, S.mental + (n == null ? 1 : n));
    if (S.mental !== before) {
      this.emit({ t: "toast", msg: { id: "Mental: " + MENTAL_L.id[S.mental], en: "Mind: " + MENTAL_L.en[S.mental] }, kind: "bad" });
      this.emit({ t: "sfx", id: "mental_down" });
      if (!S.tutSeen.mental) this.tutPop("mental");
    }
    this.emit({ t: "hud" });
  },
  mentalDown: function (n) {
    var S = this.S, before = S.mental;
    S.mental = Math.max(0, S.mental - (n == null ? 1 : n));
    if (S.mental !== before) {
      this.emit({ t: "toast", msg: { id: "Mental: " + MENTAL_L.id[S.mental], en: "Mind: " + MENTAL_L.en[S.mental] }, kind: "good" });
      this.emit({ t: "sfx", id: "mental_up" });
    }
    this.emit({ t: "hud" });
  },

  tierUp: function (stat) {
    if (TIER_STATS.indexOf(stat) < 0) return;
    var S = this.S, before = this.tierGet(stat);
    var nv = before < 0 ? 0 : Math.min(3, before + 1);
    if (!S.tiers) S.tiers = {};
    S.tiers[stat] = nv;
    if (nv !== before) {
      this.emit({ t: "toast", msg: {
        id: this.tierStatName(stat) + " → " + this.tierName(nv),
        en: this.tierStatName(stat) + " → " + this.tierName(nv) }, kind: "bad" });
      this.emit({ t: "sfx", id: "tier_up" });
      if (!S.tutSeen.tier_tutorial) this.tutPop("tier_tutorial");
      if (stat === "Stress" && nv === 3) this.unlockAchv("dice_fate");
      if (stat === "Kelelahan" && nv === 3) this.unlockAchv("lemas_body");
    }
    this.emit({ t: "hud" });
  },
  tierDown: function (stat) {
    if (TIER_STATS.indexOf(stat) < 0) return;
    var S = this.S, before = this.tierGet(stat);
    if (before < 0) return;
    var nv = before - 1;
    if (nv < 0) delete S.tiers[stat]; else S.tiers[stat] = nv;
    this.emit({ t: "toast", msg: {
      id: this.tierStatName(stat) + " → " + this.tierName(nv),
      en: this.tierStatName(stat) + " → " + this.tierName(nv) }, kind: "good" });
    this.emit({ t: "hud" });
  },

  _applyEnergy: function (nv, silent) {
    var S = this.S;
    nv = Math.max(0, Math.min(100, nv));
    var beforeTier = this.energyTier();
    S.energy = nv;
    var afterTier = this.energyTier();
    if (!silent && beforeTier !== afterTier) {
      /* direction along the fit -> empty spectrum */
      var order = ["fit", "tired", "weary", "critical", "empty"];
      var dir = order.indexOf(afterTier) > order.indexOf(beforeTier) ? "down" : "up";
      var msg = ENERGY_TIER_TEXT[afterTier] ? ENERGY_TIER_TEXT[afterTier][dir] : null;
      if (msg && (msg.id || msg.en)) {
        this.emit({ t: "toast", msg: msg, kind: dir === "down" ? "bad" : "good" });
        if (!S.tutSeen.energi && (afterTier === "weary" || afterTier === "critical" || afterTier === "empty"))
          this.tutPop("energi");
      }
    }
    this.emit({ t: "hud" });
  },
  energyUp: function (n) {
    this._applyEnergy((this.S.energy == null ? 100 : this.S.energy) + (n == null ? 10 : n));
    this.emit({ t: "float", text: "+" + (n == null ? 10 : n), kind: "gain" });
    this.emit({ t: "sfx", id: "eat" });
  },
  energyDown: function (n) {
    var S = this.S;
    var nv = (S.energy == null ? 100 : S.energy) - (n == null ? 5 : n);
    this._applyEnergy(nv);
    this.emit({ t: "float", text: "-" + (n == null ? 5 : n), kind: "loss" });
    if (S.energy <= 0 && !this._inFaint) this._onEnergyEmpty();
  },
  _onEnergyEmpty: function () {
    this.unlockAchv("empty_tank");
    this.tierUp("Kelelahan");
    this.faintCheck();
  },

  addEmotion: function (name, amt) {
    var S = this.S;
    if (!name) return;
    if (!S.emotions) S.emotions = {};
    var v = Math.max(0, Math.min(3, (S.emotions[name] || 0) + (amt == null ? 1 : amt)));
    if (v <= 0) delete S.emotions[name]; else S.emotions[name] = v;
    if ((amt == null ? 1 : amt) > 0) {
      this.emit({ t: "toast", msg: { id: this.emotionName(name) + " +" + (amt == null ? 1 : amt), en: this.emotionName(name) + " +" + (amt == null ? 1 : amt) }, kind: "bad" });
    }
    this.emit({ t: "hud" });
  },

  addTemp: function (name, nodes) {
    var S = this.S;
    if (!name) return;
    if (!S.temp) S.temp = [];
    var dur = Math.max(1, nodes == null ? 1 : nodes);
    var ex = null;
    for (var i = 0; i < S.temp.length; i++) if (S.temp[i].n === name) ex = S.temp[i];
    if (ex) ex.left = Math.max(ex.left, dur);
    else S.temp.push({ n: name, left: dur });
    this.emit({ t: "hud" });
  },

  setStatus: function (s) {
    var S = this.S;
    if (s !== "safe" && s !== "danger" && s !== "wounded") return;
    S.status = s;
    this._statusSetThisKnot = true;
    try {
      if (this.story) this.story.variablesState["wounded"] = (s === "wounded");
    } catch (e) { /* story may not declare VAR wounded — story-side conditional then unavailable */ }
    if (s === "wounded") {
      this.emit({ t: "sfx", id: "hurt" });
      if (!S.tutSeen.wounded) this.tutPop("wounded");
    }
    this.emit({ t: "hud" });
  },

  setBody: function (text) {
    this.S.body = text || null;
    this.emit({ t: "hud" });
  },

  grantItem: function (id) {
    var S = this.S;
    if (!id) return;
    var ex = null;
    for (var i = 0; i < S.items.length; i++) if (S.items[i].id === id) ex = S.items[i];
    if (ex) ex.qty = Math.min(MAX_ITEMS_STACK, (ex.qty || 1) + 1);
    else S.items.push({ id: id, qty: 1 });
    var nm = this.itemName(id);
    this.emit({ t: "toast", msg: { id: "Mendapat: " + nm, en: "Obtained: " + nm }, kind: "good" });
    this.emit({ t: "sfx", id: "pickup" });
    if (!S.tutSeen.item) this.tutPop("item");
    this.emit({ t: "hud" });
  },

  addFavor: function (npc, amt) {
    if (!npc) return;
    var S = this.S;
    if (!S.favor) S.favor = {};
    S.favor[npc] = (S.favor[npc] || 0) + (amt == null ? 0 : amt);
    this.emit({ t: "hud" });
  },

  unlockAchv: function (id) {
    var S = this.S;
    var a = this.achvDex(id);
    if (!a || S.achv[id]) return false;
    S.achv[id] = Date.now();
    this.emit({ t: "achv", id: id });
    this.emit({ t: "sfx", id: "achievement" });
    return true;
  },

  tutPop: function (id) {
    var S = this.S;
    if (!id || S.tutSeen[id]) return;
    S.tutSeen[id] = true;
    this.emit({ t: "tutpop", id: id });
  },

  checkpoint: function (name) {
    if (!name) return;
    /* Snapshot is taken by ui.js after the knot settles (story must be idle). */
    this.emit({ t: "checkpoint", name: name });
  },

  death: function (reason) {
    var S = this.S;
    /* Capture the death knot for the respawn-target map. During external
       evaluation currentPointer is live inside the knot (e.g. "d5_trap.17"). */
    this.deathKnot = null;
    try {
      var st = this.story && this.story.state;
      var p = st && st.currentPointer;
      if (p && !p.isNull && p.path) this.deathKnot = Bridge.knotNameOf(p.path.toString());
    } catch (e) {}
    S.deaths++;
    this.unlockAchv("first_death");
    if (S.deaths >= 5) this.unlockAchv("five_deaths");
    this.emit({ t: "sfx", id: "death_sting" });
    this.emit({ t: "death", reason: reason || "story",
                knot: this.deathKnot,
                respawn: Bridge.respawnTargetFor(this.deathKnot) });
  },

  faintCheck: function () {
    if (this._inFaint) return "safe";
    this._inFaint = true;
    try {
      var S = this.S;
      var pool = ["killed", "stolen", "wounded", "safe"].filter(function (id) {
        return id !== "stolen" || Bridge.faintStealable().length > 0;
      });
      var tot = 0, i;
      for (i = 0; i < pool.length; i++) tot += FAINT_W[pool[i]];
      var r = Math.random() * tot, outcome = pool[pool.length - 1];
      for (i = 0; i < pool.length; i++) { r -= FAINT_W[pool[i]]; if (r <= 0) { outcome = pool[i]; break; } }

      S.lastFaint = outcome;
      this.emit({ t: "sfx", id: "faint" });

      if (outcome === "stolen") {
        var stealable = this.faintStealable();
        if (stealable.length) {
          var victim = stealable[Math.floor(Math.random() * stealable.length)];
          this.removeItem(victim.id, 1);
          this.emit({ t: "faint", outcome: outcome, item: victim.id });
        } else {
          this.emit({ t: "faint", outcome: "safe" });
        }
      } else if (outcome === "wounded") {
        this.setBody(this.lang === "en" ? "Bruised from the fall" : "Memar akibat terjatuh");
        this.setStatus("wounded");
        this.emit({ t: "faint", outcome: outcome });
      } else if (outcome === "killed") {
        /* Killed-by-faint does NOT call death() directly: ui.js jumps the
           story to the "faint_killed" knot (which itself calls ~ DEATH()).
           Falls back to the death screen if that knot is missing. */
        this.emit({ t: "faint", outcome: outcome });
      } else {
        this.emit({ t: "faint", outcome: outcome });
      }
      return outcome;
    } finally {
      this._inFaint = false;
    }
  },

  /* ================= Engine ticks (called by ui.js) ================= */

  /* Per choice: energy cost. */
  spendForChoice: function () {
    this.energyDown(ENERGY_PER_KNOT);
  },

  /* Per knot visited: temp countdown + slow emotional/mental decay. */
  onKnotAdvance: function () {
    var S = this.S;
    S.knotsVisited++;
    this._statusSetThisKnot = false;
    /* temp countdown per knot */
    if (S.temp) {
      for (var i = 0; i < S.temp.length; i++) S.temp[i].left--;
      S.temp = S.temp.filter(function (t) { return t.left > 0; });
    }
    /* decay tick: emotions fade & mind recovers slightly, every 5-10 knots */
    S.decayCount++;
    if (S.decayCount >= S.decayAt) {
      S.decayCount = 0;
      S.decayAt = 5 + Math.floor(Math.random() * 6);
      var changed = false;
      if (S.emotions) {
        for (var k in S.emotions) {
          S.emotions[k]--;
          if (S.emotions[k] <= 0) delete S.emotions[k];
          changed = true;
        }
      }
      if (S.mental > 0) { S.mental--; changed = true; }
      if (changed) this.emit({ t: "hud" });
    }
  },

  /* Apply #STATUS: tag (declarative). Explicit SET_STATUS() during the same
     knot wins — checked via _statusSetThisKnot. */
  applyStatusTag: function (s) {
    if (this._statusSetThisKnot) return;
    if (s === "safe" || s === "danger" || s === "wounded") this.setStatus(s);
  },

  /* ================= Inventory / equipment ================= */

  removeItem: function (id, qty) {
    var S = this.S, found = false;
    for (var i = 0; i < S.items.length; i++) {
      if (S.items[i].id === id) {
        S.items[i].qty = (S.items[i].qty || 1) - (qty || 1);
        if (S.items[i].qty <= 0) S.items.splice(i, 1);
        found = true;
        break;
      }
    }
    if (found) this.emit({ t: "hud" });
    return found;
  },

  useItem: function (id) {
    var S = this.S, it = null, i;
    for (i = 0; i < S.items.length; i++) if (S.items[i].id === id) it = S.items[i];
    var dex = this.itemDex(id);
    if (!it || !dex || !dex.use) return false;
    var u = dex.use;
    var wasWounded = (S.status === "wounded");
    if (u.energy) this.energyUp(u.energy);
    if (u.heal && wasWounded) { S.status = null; S.body = null;
      try { if (this.story) this.story.variablesState["wounded"] = false; } catch (e) {}
    }
    if (u.tierUp) for (i = 0; i < u.tierUp.length; i++) this.tierUp(u.tierUp[i]);
    if (u.tierDown) for (i = 0; i < u.tierDown.length; i++) this.tierDown(u.tierDown[i]);
    if (u.mentalBetter) this.mentalDown(u.mentalBetter);
    if (u.mentalWorse) this.mentalUp(u.mentalWorse);
    if (u.addEmotion) for (i = 0; i < u.addEmotion.length; i++) this.addEmotion(u.addEmotion[i].n, u.addEmotion[i].amt);
    if (dex.onUseAchv) this.unlockAchv(dex.onUseAchv);
    it.qty = (it.qty || 1) - 1;
    if (it.qty <= 0) S.items.splice(S.items.indexOf(it), 1);
    this.emit({ t: "toast", msg: { id: "Memakai: " + this.itemName(id), en: "Used: " + this.itemName(id) }, kind: "good" });
    this.emit({ t: "sfx", id: "use_item" });
    this.emit({ t: "hud" });
    return true;
  },

  equipItem: function (id) {
    var S = this.S, it = null, i;
    for (i = 0; i < S.items.length; i++) if (S.items[i].id === id) it = S.items[i];
    var dex = this.itemDex(id);
    if (!it || !dex || dex.kind === "story" || !dex.slot) return false;
    var slot = dex.slot || "senjata";
    var cur = S.equipment[slot];
    if (cur) {
      var ex = null;
      for (i = 0; i < S.items.length; i++) if (S.items[i].id === cur.id) ex = S.items[i];
      if (ex) ex.qty = (ex.qty || 1) + 1; else S.items.push({ id: cur.id, qty: 1 });
    }
    it.qty = (it.qty || 1) - 1;
    if (it.qty <= 0) S.items.splice(S.items.indexOf(it), 1);
    S.equipment[slot] = { id: id };
    this.emit({ t: "hud" });
    return true;
  },

  unequipItem: function (slot) {
    var S = this.S, cur = S.equipment[slot];
    if (!cur) return false;
    var ex = null;
    for (var i = 0; i < S.items.length; i++) if (S.items[i].id === cur.id) ex = S.items[i];
    if (ex) ex.qty = (ex.qty || 1) + 1; else S.items.push({ id: cur.id, qty: 1 });
    S.equipment[slot] = null;
    this.emit({ t: "hud" });
    return true;
  },

  /* ================= ink binding ================= */

  bindAll: function (story) {
    this.attach(story);
    var b = this;
    function num(x) { var n = parseFloat(x); return isNaN(n) ? 0 : n; }
    story.BindExternalFunction("MENTAL_UP", function (n) { b.mentalUp(num(n)); });
    story.BindExternalFunction("MENTAL_DOWN", function (n) { b.mentalDown(num(n)); });
    story.BindExternalFunction("TIER_UP", function (s) { b.tierUp(String(s)); });
    story.BindExternalFunction("TIER_DOWN", function (s) { b.tierDown(String(s)); });
    story.BindExternalFunction("ENERGY_UP", function (n) { b.energyUp(num(n)); });
    story.BindExternalFunction("ENERGY_DOWN", function (n) { b.energyDown(num(n)); });
    story.BindExternalFunction("ADD_EMOTION", function (name, amt) { b.addEmotion(String(name), num(amt)); });
    story.BindExternalFunction("ADD_TEMP", function (name, nodes) { b.addTemp(String(name), num(nodes)); });
    story.BindExternalFunction("SET_STATUS", function (s) { b.setStatus(String(s)); });
    story.BindExternalFunction("SET_BODY", function (t) { b.setBody(String(t)); });
    story.BindExternalFunction("GRANT_ITEM", function (id) { b.grantItem(String(id)); });
    story.BindExternalFunction("ADD_FAVOR", function (npc, amt) { b.addFavor(String(npc), num(amt)); });
    story.BindExternalFunction("UNLOCK_ACHV", function (id) { b.unlockAchv(String(id)); });
    story.BindExternalFunction("TUT_POP", function (id) { b.tutPop(String(id)); });
    story.BindExternalFunction("CHECKPOINT", function (name) { b.checkpoint(String(name)); });
    story.BindExternalFunction("DEATH", function () { b.death("story"); });
    story.BindExternalFunction("FAINT_CHECK", function () { return b.faintCheck(); });
  }
};

/* dex exports for ui.js */
Bridge.ITEM_DEX = ITEM_DEX;
Bridge.ACHV = ACHV;
Bridge.EQ_SLOTS = EQ_SLOTS;
Bridge.TIER_STATS = TIER_STATS;
Bridge.TUT_POP_DEX = TUT_POP_DEX;
Bridge.FAINT_TEXT = FAINT_TEXT;
Bridge.ENERGY_PER_KNOT = ENERGY_PER_KNOT;

if (typeof window !== "undefined") window.Bridge = Bridge;
if (typeof module !== "undefined" && module.exports) module.exports = Bridge;

})();
