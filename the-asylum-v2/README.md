# The Asylum v2

Rebuild total dari game horor psikologis choose-your-own-story "The Asylum"
milik Kaze — rumah sakit jiwa terbengkalai, tema gelap + aksen crimson.
Ditenagai **inkjs 2.4.0** (runtime) + **Howler** (audio) + **localforage** (save).

## Cara preview

**Opsi A — langsung via `file://` (disarankan):**
buka `index.html` di browser. Semua story di-wrap jadi `.js` (bukan `fetch`),
manifest audio di-bake ke `js/audio.js`, jadi tidak butuh server.

**Opsi B — server lokal:**
```bash
cd the-asylum-v2
python3 -m http.server 8080
# buka http://localhost:8080
```
Opsi B juga mengaktifkan pemuatan `assets/audio/audio-manifest.json` versi live
(jika manifest berubah tanpa update bake di `audio.js`).

## Arsitektur

```
index.html          shell: #scene, #grain, #vignette, #letterbox, #hud,
                    #app (#story), #dock, #toasts, #title-overlay, #modal-root
css/style.css       "clinical gothic": near-black, bone-white serif, crimson
js/ink.js           inkjs 2.4.0 UMD (copy dari tools/cyoa/inkjs/...)
js/howler.min.js    Howler (copy dari tools/support/howler-js)
js/localforage.min.js  localforage (copy dari tools/support/localforage)
js/bridge.js        state mekanik + 17 EXTERNAL bindings (logic-only, no DOM)
js/audio.js         manager Howler: crossfade ambient, one-shot SFX,
                    drone generatif WebAudio bila file tak ada
js/ui.js           render ink, typewriter, transisi letterbox, HUD, inventory,
                    achievement, save slot, death/respawn, tutorial
story/sample.js     story DEV kecil (ID+EN); hanya dipakai bila
                    window.STORY_ID/EN belum didefinisikan
story/part1_id.js   STORY ASLI (ID) — dimuat koordinator setelah sample.js
story/part1_en.js   STORY ASLI (EN)
story/*.ink         sumber ink (referensi)
assets/audio/       12 ambient + 18 SFX (CC0, prosedural) + ATTRIBUTION.md
```

### Alur entry

1. Halaman dimuat → story jalan dari awal: **cold open** (`prolog1` → `-> END`).
2. Setelah teks cold open selesai → **layar judul** (overlay di atas cold open).
3. "Permainan Baru" → `story.ChoosePathString("prolog2")` → cerita dimulai.
   (Tidak pernah mulai dari knot `opening` — tidak ada di part1.)

### Tag ink → UI (`story.currentTags`)

| Tag | Efek |
|---|---|
| `#KICKER:Teks` | header chapter sinematik |
| `#TAG:Lokasi` | label lokasi di HUD |
| `#AUDIO:doorhub` | crossfade ambient → `amb_doorhub.wav` (prefix `amb_` otomatis) |
| `#IMAGE:bg_doorhub` | backdrop prosedural (`scene-doorhub`, dst.) |
| `#SFX:paper_rustle` | SFX satu-tembakan → `sfx_paper_rustle.wav` (prefix `sfx_` otomatis), sekali saat tag dibaca |
| `#STATUS:danger` | deklaratif; kalah oleh `SET_STATUS()` eksplisit di knot yang sama |

### 17 EXTERNAL (bridge.js `bindAll`)

```
MENTAL_UP(n) / MENTAL_DOWN(n)      mental: Tenang(0)→Tegang→Gelisah→Panik→Hancur(4)
TIER_UP(s) / TIER_DOWN(s)          s ∈ Stress|Keracunan|Pendarahan|Kelelahan;
                                   tier: Ringan(0)→Sedang→Tinggi→Ekstrim(3)
ENERGY_UP(n) / ENERGY_DOWN(n)      0–100; 0 → achievement + Kelelahan↑ + FAINT_CHECK()
ADD_EMOTION(name, amt)             Takut|Sedih|Lega (1–3), meluruh tiap 5–10 knot
ADD_TEMP(name, nodes)              efek sementara, countdown per knot
SET_STATUS(s)                      safe|danger|wounded (+ variablesState["wounded"])
SET_BODY(text)                     deskripsi luka di HUD
GRANT_ITEM(id)                     8 item di ITEM_DEX
ADD_FAVOR(npc, amt)                relasi NPC
UNLOCK_ACHV(id)                    14 achievement
TUT_POP(id)                        popup tutorial kontekstual (sekali per run)
CHECKPOINT(name)                   snapshot (ink ToJson + state JS); autosave
DEATH()                            death count++, layar kematian, tawaran respawn
FAINT_CHECK()                      roll {killed:15, stolen:30, wounded:25, safe:30};
                                   killed → lompat ke knot `faint_killed`
```

Semua 17 wajib ter-bind — runtime inkjs melempar `StoryException` bila ada
external yang dipanggil tapi tak ter-bind.

### Penguncian choice (hardcode di bridge.js)

Komentar ink hilang saat compile, jadi peta ini hardcoded:

```js
CHOICE_LOCKS = {
  d5_1c: [
    { index: 0, locked: S => energy < 15 },
    { index: 1, locked: S => mental > 2 /* > Gelisah */ }
  ]
}
```

Nama knot dibaca dari `choice.sourcePath` (`"d5_1c.0.27"` → `"d5_1c"`).
Choice terkunci tampil greyed-out + 🔒, tidak bisa diklik.

### Respawn

- `Bridge.RESPAWN_MAP = { d5_trap: "hub_exit", s12_panic: "s12_hub" }`.
- Knot kematian ditangkap saat `DEATH()` via `story.state.currentPointer`.
- Respawn = restore snapshot CHECKPOINT terakhir (`LoadJson` + state JS,
  death count & achievement dipertahankan) lalu `ChoosePathString(target)`.
- Tanpa target/peta → render ulang view checkpoint; tanpa keduanya → mulai baru.

### Save

- 3 slot manual + 1 autosave (di setiap CHECKPOINT) via localforage:
  `asylum_v2_slot_{1,2,3}`, `asylum_v2_auto`.
- Isi: `story.state.ToJson()` + snapshot state JS + lang + timestamp.

## Keputusan design

- **Bahasa visual "clinical gothic"**: near-black, teks bone-white serif
  (Palatino/Georgia), satu aksen crimson. Tanpa jiplak UI lama.
- **Tipografi**: narasi serif 19px/1.85; label UI sans small-caps letter-spacing.
- **Transisi sinematik**: letterbox bar atas-bawah (0.42s) + fade + film grain
  animasi + vignette. Hormat `prefers-reduced-motion`.
- **Typewriter**: tulisan tangan (±16ms/2 karakter), klik untuk skip,
  tick SFX halus tiap ~18 karakter.
- **Audio**: 12 ambient prosedural (crossfade 2.5s) + drone generatif WebAudio
  sebagai fallback bila file tak termuat; tidak pernah `console.error`.
- **Bilingual penuh**: seluruh string UI ada ID+EN; toggle di judul & dock.
  (Catatan: toggle di tengah permainan mengganti chrome/HUD langsung;
  bahasa narasi mengikuti story yang dimuat.)

## Validasi

```bash
node --check js/bridge.js js/ui.js js/audio.js story/sample.js  # + ink/howler/localforage (copy)
node /tmp/asylum_test.js        # e2e headless: playthrough part1+sample,
                                # death/respawn, faint, item, save roundtrip
node /tmp/asylum_delta_test.js  # 6 delta integrasi
```

Keduanya hijau (2026-10-16). `story.onError` dipasang agar cacat konten story
tidak melempar exception ke UI — story berakhir gracefully ke layar ending.

## Known issues / catatan untuk koordinator

1. **part1 hub `opening`**: bila semua sticky choice habis (4 pintu dikunjungi),
   knot kehabisan konten → "ran out of content". UI menanganinya (ending screen),
   tapi idealnya story diberi fallback choice/divert.
2. **`#TAG:[Aman]`** dipakai sebagai lokasi di beberapa knot (mis. d5_smart) —
   tampil sebagai nama lokasi di HUD; mungkin maksudnya status.
3. **`story/part1_en.js` belum diterjemahkan** (masih teks Indonesia) —
   di luar lingkup UI.
4. **Integrasi `index.html`**: tag `<script>` untuk `part1_id.js`/`part1_en.js`
   masih dikomentari — koordinator mengaktifkan setelah story final
   (muat SETELAH `sample.js`; keduanya menimpa `window.STORY_ID/EN`).
5. Toggle bahasa di tengah permainan: narasi mengikuti story yang sedang
   berjalan; ganti penuh berlaku untuk new game / load save.
