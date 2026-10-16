#!/usr/bin/env python3
"""
Generator .ink bilingual untuk The Asylum v2 (Part 1).

Sumber : ~/workspace/web-dev/migration/source/nodes.json (86 node)
         + pemetaan audio/bg dari the-asylum.html (bgFor, NODE_SFX, BG_FILES)
Kontrak: ~/workspace/web-dev/migration/CONTRACT.md

Keputusan penting (lihat laporan):
- Pola sticky-choice kontrak `{not f} * [t] ~ f = true -> target` TIDAK ter-parse
  sebagai choice oleh compiler inkjs (jadi teks biasa). Dipakai bentuk terverifikasi:
      * {not f} [teks]
          ~ f = true
          -> target
- Header diakhiri `-> prolog1` (node pertama = cold open; kontrak membolehkan
  "knot awal yang sesuai"). prolog1.next="title" adalah layar judul UI shell,
  sehingga knot prolog1 diakhiri `-> END`; new game dimulai dari "prolog2"
  via ChoosePathString (sesuai game lama).
- SFX satu-tembakan (NODE_SFX) -> tag #SFX: (ekstensi tag; #AUDIO khusus ambient).
- requiresEnergy/requiresMentalMax: state milik bridge.js, tak bisa dibaca dari ink
  murni -> ditampilkan sebagai catatan di teks pilihan + komentar // REQ:.
"""

import json, re, sys

SRC = "/home/hatch/workspace/web-dev/migration/source/nodes.json"
OUT_ID = "/home/hatch/workspace/web-dev/migration/the-asylum-v2/story/part1_id.ink"
OUT_EN = "/home/hatch/workspace/web-dev/migration/the-asylum-v2/story/part1_en.ink"

nodes = json.load(open(SRC))

# ---------- flags ----------
FLAGS = sorted({f for v in nodes.values()
                for f in list(v.get("setFlag", {}).keys())} |
               {c.get(k) for v in nodes.values() if v.get("kind") == "choice"
                for c in v["choices"] for k in ("doneFlag", "blockedIfFlag") if c.get(k)})

# Nama VAR flag di-prefix "f_" agar tak pernah tabrakan dengan nama knot
# (game lama memakai "rec_coin" sebagai flag SEKAIGUS id node).
def vname(f):
    return "f_" + f

# ---------- EXTERNAL API (dari CONTRACT.md) ----------
EXTERNALS = [
    ("MENTAL_UP", ["n"]), ("MENTAL_DOWN", ["n"]),
    ("TIER_UP", ["stat"]), ("TIER_DOWN", ["stat"]),
    ("ENERGY_DOWN", ["n"]), ("ENERGY_UP", ["n"]),
    ("ADD_EMOTION", ["name", "amt"]),
    ("ADD_TEMP", ["name", "nodes"]),
    ("SET_STATUS", ["s"]),
    ("SET_BODY", ["text"]),
    ("GRANT_ITEM", ["id"]),
    ("ADD_FAVOR", ["npc", "amt"]),
    ("UNLOCK_ACHV", ["id"]),
    ("TUT_POP", ["id"]),
    ("CHECKPOINT", ["name"]),
    ("DEATH", []),
    ("FAINT_CHECK", []),
]

# ---------- audio/bg: port dari bgFor() + NODE_SFX + BG_FILES di the-asylum.html ----------
def bg_for(nid):
    if re.match(r"^d1_", nid): return "saferoom"
    if re.match(r"^d2_", nid): return "darkstare"
    if re.match(r"^d3_", nid): return "teddyroom"
    if re.match(r"^d4_", nid): return "corridor"
    if re.match(r"^d5_", nid) or nid in ("prolog2", "opening"): return "doorhub"
    if nid == "prolog1": return "corridor"
    if nid in ("hub_exit", "reception_hub", "rec_coin") or \
       re.match(r"^(rec_desk|rec_papers)", nid): return "reception"
    if re.match(r"^rec_left", nid):
        return "steeldoor" if re.search(r"door|push|scratch", nid) else "leftcorridor"
    if re.match(r"^s12_", nid):
        return "crates" if re.search(r"hide|peek|ready", nid) else "hall"
    return "corridor"

NODE_SFX = {
    "rec_papers_1": "paper_rustle", "rec_papers_read": "paper_rustle",
    "rec_papers_photos": "paper_rustle",
    "rec_left_door": "door_creak", "rec_left_door_2": "door_creak",
    "rec_left_push": "metal_clang",
    "s12_c": "whisper", "s12_peek": "whisper",
}

# Terjemahan tag mapan dari difficulty-pack di the-asylum.html (string identik)
TAG_EN_BORROW = {"[Dalam bahaya]": "[In danger]", "[Terluka]": "[Wounded]"}

todo_en = []  # (knot, field) yang fallback ke teks ID

def pick(v, id_key, en_key, lang, knot, field):
    """Ambil teks sesuai bahasa; fallback ke ID + catat TODO-EN."""
    if lang == "id" or not v.get(en_key):
        if lang == "en" and v.get(id_key):
            todo_en.append((knot, field))
        return v.get(id_key)
    return v.get(en_key)

def q(s):
    return '"' + s.replace('"', '\\"') + '"'

def emit_mechanics(v, out):
    if v.get("setStatus"):
        out.append(f"~ SET_STATUS({q(v['setStatus'])})")
    for s in v.get("tierUp", []):
        out.append(f"~ TIER_UP({q(s)})")
    for e in v.get("addEmotion", []):
        out.append(f"~ ADD_EMOTION({q(e['n'])}, {e['amt']})")
    for t in v.get("addTemp", []):
        out.append(f"~ ADD_TEMP({q(t['n'])}, {t['nodes']})")
    for it in v.get("grantItems", []):
        out.append(f"~ GRANT_ITEM({q(it['id'])})")
    if v.get("setBody"):
        out.append(f"~ SET_BODY({q(v['setBody'])})")
    if v.get("tutPop"):
        out.append(f"~ TUT_POP({q(v['tutPop'])})")
    for f in (v.get("setFlag") or {}):
        out.append(f"~ {vname(f)} = true")

def knot_name(nid):
    assert re.fullmatch(r"[A-Za-z0-9_]+", nid), nid
    return nid

def gen(lang):
    out = []
    A = out.append
    A("// The Asylum v2 — Part 1 (%s)" % ("Bahasa Indonesia" if lang == "id" else "English"))
    A("// Dibangkitkan dari source/nodes.json oleh story/gen_ink.py — jangan edit manual,")
    A("// regenerasi via: python3 story/gen_ink.py")
    A("//")
    A("// Konvensi: knot per node lama; tag #KICKER/#TAG dibaca bridge.js dari currentTags;")
    A("// #AUDIO = ambient, #IMAGE = background, #SFX = one-shot SFX (lihat NODE_SFX).")
    A("// Sticky choice: pilihan hilang setelah dipakai (perbaikan dari doneFlag lama).")
    A("// Bentuk: * {not f_x} [teks]  ~ f_x = true  -> target  (flag di-prefix f_)")
    A("// Cold open: prolog1 -> END (layar judul = UI shell); new game mulai di prolog2")
    A("// via story.ChoosePathString(\"prolog2\").")
    A("")
    A("// ---------- flags ----------")
    for f in FLAGS:
        A(f"VAR {vname(f)} = false")
    A("")
    A("// ---------- external API (di-bind bridge.js) ----------")
    for name, args in EXTERNALS:
        A(f"EXTERNAL {name}({', '.join(args)})")
    A("")
    A("-> prolog1")

    for nid, v in nodes.items():
        kind = v["kind"]
        kn = knot_name(nid)
        A("")
        A(f"=== {kn} ===")
        amb = bg_for(nid)

        # tags
        kicker = pick(v, "kicker", "kickerEn", lang, kn, "kicker")
        if kicker:
            if lang == "en" and not v.get("kickerEn"):
                A("// TODO-EN: kicker")
            A(f"#KICKER:{kicker}")
        if lang == "en" and v.get("tag") and not v.get("tagEn") \
                and v["tag"] in TAG_EN_BORROW:
            tag = TAG_EN_BORROW[v["tag"]]  # terjemahan mapan dari game lama
        else:
            tag = pick(v, "tag", "tagEn", lang, kn, "tag")
            if tag and lang == "en" and not v.get("tagEn"):
                A("// TODO-EN: tag")
        if tag:
            A(f"#TAG:{tag}")
        A(f"#AUDIO:{amb}")
        A(f"#IMAGE:bg_{amb}")
        if nid in NODE_SFX:
            A(f"#SFX:{NODE_SFX[nid]}")

        emit_mechanics(v, out)

        # story text
        if kind != "tbc":
            paras = pick(v, "story", "storyEn", lang, kn, "story") or []
            if lang == "en" and not v.get("storyEn"):
                A("// TODO-EN: story")
            for p in paras:
                A(p)

        # endings / choices
        if kind in ("story", "result"):
            nxt = v.get("next")
            if nid == "prolog1":
                A("// next=\"title\" di game lama = layar judul (UI shell)")
                A("-> END")
            elif nxt:
                A(f"-> {knot_name(nxt)}")
            else:
                A("// WARNING: node tanpa next di sumber")
                A("-> END")
        elif kind == "choice":
            for c in v["choices"]:
                label = pick(c, "text", "textEn", lang, kn, "choice")
                note = ""
                if c.get("requiresEnergy"):
                    req = c["requiresEnergy"]
                    A(f"// REQ: energy>={req} (bridge.js mengunci bila tak terpenuhi)")
                    note += " (butuh %d energi)" % req if lang == "id" else " (needs %d energy)" % req
                if c.get("condNote"):
                    cn = c["condNote"] if lang == "id" else "Requires focus (mental \u2264 Uneasy)"
                    if lang == "en":
                        todo_en.append((kn, "condNote"))
                    note += f" \u2014 {cn}"
                if lang == "en" and not c.get("textEn"):
                    A("// TODO-EN: choice")
                f = c.get("doneFlag") or c.get("blockedIfFlag")
                tgt = knot_name(c["target"])
                if f:
                    A(f"* {{not {vname(f)}}} [{label}{note}]")
                    A(f"    ~ {vname(f)} = true")
                    A(f"    -> {tgt}")
                else:
                    A(f"* [{label}{note}] -> {tgt}")
        elif kind == "death":
            if v.get("next"):
                A(f"// respawn lama: {v['next']} (bridge: pasang CHECKPOINT di hub terkait)")
            else:
                A("// dipicu dinamis oleh FAINT_CHECK()/mekanik istirahat via")
                A("// story.ChoosePathString (bukan lewat divert graf)")
            A("~ DEATH()")
            A("-> END")
        elif kind == "tbc":
            A("Bersambung\u2026" if lang == "id" else "To be continued\u2026")
            A("-> END")

    A("")
    return "\n".join(out) + "\n"

if __name__ == "__main__":
    todo_en.clear()
    id_src = gen("id")
    assert len(todo_en) == 0, todo_en  # gen ID tak boleh menambah TODO-EN
    todo_en.clear()
    en_src = gen("en")
    open(OUT_ID, "w").write(id_src)
    open(OUT_EN, "w").write(en_src)
    print("knots:", len(nodes))
    print("flags:", len(FLAGS), FLAGS)
    print("TODO-EN (file EN):", len(todo_en))
    from collections import Counter
    print(Counter(f for _, f in todo_en))
