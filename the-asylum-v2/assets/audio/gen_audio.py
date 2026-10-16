#!/usr/bin/env python3
"""Procedural audio synthesis for The Asylum v2.
All sounds generated from scratch with numpy -> 100% CC0, no third-party assets.
Ambients: 22050 Hz mono, 40 s, seamless loop via end/start crossfade.
SFX: 44100 Hz mono, short, with fades to avoid clicks.
"""
import numpy as np, wave, os, json, subprocess
from numpy.fft import rfft, irfft, rfftfreq

OUT = os.path.expanduser("~/workspace/web-dev/migration/the-asylum-v2/assets/audio")
os.makedirs(OUT, exist_ok=True)
rng = np.random.default_rng(20261016)

SR_A = 22050  # ambient sample rate
SR_S = 44100  # sfx sample rate
MANIFEST = {}

# ---------------- utils ----------------
def write_wav(path, x, sr):
    x = np.clip(np.asarray(x, dtype=np.float64), -1.0, 1.0)
    pcm = (x * 32767.0).astype(np.int16)
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(sr)
        w.writeframes(pcm.tobytes())
    return len(pcm) / sr

def peak_norm(x, target=0.6):
    p = np.max(np.abs(x)) + 1e-12
    return x * (target / p)

def filt(x, kind, sr, fc, order=2, fc2=None):
    """Zero-phase FFT filter. kind: low | high | band(fc..fc2)."""
    n = len(x)
    X = rfft(x)
    f = rfftfreq(n, 1.0 / sr)
    if kind == "low":
        H = 1.0 / np.sqrt(1.0 + (f / fc) ** (2 * order))
    elif kind == "high":
        H = 1.0 / np.sqrt(1.0 + (fc / np.maximum(f, 1e-6)) ** (2 * order))
    elif kind == "band":
        H = (1.0 / np.sqrt(1.0 + (fc / np.maximum(f, 1e-6)) ** (2 * order))) * \
            (1.0 / np.sqrt(1.0 + (f / fc2) ** (2 * order)))
    else:
        raise ValueError(kind)
    return irfft(X * H, n)

def brown(n):
    w = rng.standard_normal(n)
    b = np.cumsum(w)
    b = b - np.linspace(b[0], b[-1], n)  # remove drift -> loop friendlier
    b = b - np.mean(b)
    return b / (np.max(np.abs(b)) + 1e-12)

def white(n):
    return rng.standard_normal(n)

def sine(f, n, sr, phase=0.0):
    return np.sin(2 * np.pi * f * np.arange(n) / sr + phase)

def expdec(n, sr, tau):
    return np.exp(-np.arange(n) / (sr * tau))

def bump(n):
    return np.sin(np.pi * np.linspace(0, 1, n)) ** 2  # smooth 0..1..0

def sweep_tone(f0, f1, n, sr, curve="exp"):
    t = np.arange(n) / sr
    if curve == "exp":
        f = f0 * (f1 / f0) ** (t / (n / sr))
    else:
        f = f0 + (f1 - f0) * t / (n / sr)
    return np.sin(2 * np.pi * np.cumsum(f) / sr)

def fade_edges(x, sr, a=0.005, b=None):
    x = np.asarray(x, dtype=float).copy()
    n = len(x)
    b = a if b is None else b
    na, nb = int(sr * a), int(sr * b)
    if na > 1:
        x[:na] *= np.sin(0.5 * np.pi * np.linspace(0, 1, na)) ** 2
    if nb > 1:
        x[-nb:] *= np.sin(0.5 * np.pi * np.linspace(1, 0, nb)) ** 2
    return x

def seamless(x, sr, fade=5.0):
    """Render len(x) with extra `fade` seconds, return loop of len(x)-fade."""
    n0 = len(x)
    m = min(int(sr * fade), n0 // 4)
    w = np.linspace(0, 1, m)
    y = x[:n0 - m].copy()
    y[:m] = x[:m] * w + x[n0 - m:n0] * (1 - w)
    return y

def place_event(base, ev, at_sec, sr, gain=1.0):
    i = int(at_sec * sr)
    n = len(ev)
    if i < 0:
        ev = ev[-i:]; i = 0; n = len(ev)
    if i + n <= len(base):
        base[i:i + n] += gain * ev
    elif i < len(base):
        base[i:] += gain * ev[:len(base) - i]
    return base

def render_ambient(name, dur, build, fade=5.0, target=0.55, desc=""):
    n = int((dur + fade) * SR_A)
    x = build(n, SR_A)
    x = seamless(x, SR_A, fade)
    x = peak_norm(x, target)
    d = write_wav(os.path.join(OUT, name + ".wav"), x, SR_A)
    MANIFEST[name] = {"file": name + ".wav", "duration_sec": round(d, 2),
                      "description": desc}
    print(f"{name}: {d:.1f}s")

def render_sfx(name, x, target=0.7, fa=0.005, fb=0.012, desc=""):
    x = fade_edges(x, SR_S, fa, fb)
    x = peak_norm(x, target)
    d = write_wav(os.path.join(OUT, name + ".wav"), x, SR_S)
    MANIFEST[name] = {"file": name + ".wav", "duration_sec": round(d, 2),
                      "description": desc}
    print(f"{name}: {d:.2f}s")

# ================= AMBIENTS (40 s, seamless) =================
def b_title(n, sr):
    t = np.arange(n) / sr
    sub = 0.55 * sine(36.0, n, sr)
    d1 = 2 * ((55.0 * t) % 1.0) - 1.0
    d2 = 2 * ((55.6 * t) % 1.0) - 1.0
    drone = filt(0.5 * (d1 + d2), "low", sr, 200, order=3)
    lfo = 0.65 + 0.35 * np.sin(2 * np.pi * 0.05 * t)
    air = filt(white(n), "band", sr, 500, order=2, fc2=1600)
    swell = 0.5 + 0.5 * np.sin(2 * np.pi * 0.07 * t + 1.3)
    x = 0.8 * sub * lfo + 0.5 * drone * lfo + 0.25 * air * swell
    for at in (11.0, 27.3):
        m = int(2.5 * sr); tt = np.arange(m) / sr
        ping = sum(sine(f, m, sr) * np.exp(-tt / 0.7) for f in (612.0, 1487.0, 2311.0))
        place_event(x, 0.10 * ping, at, sr)
    return x

def b_corridor(n, sr):
    t = np.arange(n) / sr
    wnd = filt(brown(n), "low", sr, 420, order=2)
    gust = 0.55 + 0.30 * np.sin(2 * np.pi * 0.06 * t) + 0.15 * np.sin(2 * np.pi * 0.17 * t + 2.0)
    hum = 0.05 * sine(50, n, sr) + 0.03 * sine(100, n, sr) + 0.015 * sine(150, n, sr)
    x = 0.7 * wnd * np.clip(gust, 0.15, 1.0) + hum
    for at in (6.5, 17.2, 29.8):
        m = int(0.6 * sr); tt = np.arange(m) / sr
        drip = sine(1750, m, sr) * np.exp(-tt / 0.09)
        echo = (tt > 0.28)
        drip = drip + 0.4 * np.sin(2 * np.pi * 1750 * (tt - 0.28)) * np.exp(-(tt - 0.28) / 0.09) * echo
        place_event(x, 0.10 * drip, at, sr)
    return x

def b_reception(n, sr):
    t = np.arange(n) / sr
    hum = 0.06 * sine(100, n, sr) + 0.04 * sine(200, n, sr) + 0.02 * sine(300, n, sr)
    wob = 0.8 + 0.2 * np.sin(2 * np.pi * 0.4 * t)
    hiss = 0.05 * filt(white(n), "high", sr, 5000, order=2)
    room = 0.10 * filt(brown(n), "low", sr, 240, order=2)
    return hum * wob + hiss + room

def b_doorhub(n, sr):
    t = np.arange(n) / sr
    rum = filt(brown(n), "low", sr, 110, order=3)
    pulse = 0.6 + 0.4 * np.sin(2 * np.pi * 0.10 * t) ** 2
    sub = 0.5 * sine(44.0, n, sr)
    met = filt(white(n), "band", sr, 300, order=3, fc2=420)
    sweep = 0.5 + 0.5 * np.sin(2 * np.pi * 0.045 * t + 0.7)
    return 0.8 * rum * pulse + 0.4 * sub + 0.22 * met * sweep

def b_saferoom(n, sr):
    t = np.arange(n) / sr
    warm = 0.35 * sine(108, n, sr) + 0.25 * sine(137.0, n, sr) + 0.15 * sine(54.0, n, sr)
    breath = 0.75 + 0.25 * np.sin(2 * np.pi * 0.08 * t)
    air = 0.06 * filt(white(n), "high", sr, 3000, order=1)
    return warm * breath + air * breath

def b_darkstare(n, sr):
    x = 0.05 * filt(brown(n), "low", sr, 180, order=2)
    for at in (3.0, 10.2, 17.5, 24.8, 32.0):
        m = int(1.2 * sr); tt = np.arange(m) / sr
        pulse = sine(48, m, sr) * np.exp(-tt / 0.35) * bump(m)
        place_event(x, 0.5 * pulse, at, sr)
    for at in (7.7, 21.4, 35.6):
        m = int(1.5 * sr); tt = np.arange(m) / sr
        ping = sine(3150, m, sr) * np.exp(-tt / 0.5)
        place_event(x, 0.06 * ping, at, sr)
    return x

def b_teddyroom(n, sr):
    t = np.arange(n) / sr
    drone = 0.4 * sine(64.0, n, sr) * (0.7 + 0.3 * np.sin(2 * np.pi * 0.11 * t))
    whistle = filt(white(n), "band", sr, 900, order=3, fc2=1500)
    wob = 0.4 + 0.6 * (0.5 + 0.5 * np.sin(2 * np.pi * 0.09 * t + 2.2))
    x = drone + 0.20 * whistle * wob
    for at in (8.4, 22.9, 33.1):
        m = int(0.5 * sr); tt = np.arange(m) / sr
        th = filt(white(m), "low", sr, 160, order=3) * np.exp(-tt / 0.12)
        place_event(x, 0.5 * th, at, sr)
    x = x + 0.03 * sine(2350, n, sr) * (0.5 + 0.5 * np.sin(2 * np.pi * 0.23 * t))
    return x

def b_steeldoor(n, sr):
    t = np.arange(n) / sr
    x = np.zeros(n)
    for i, f in enumerate((82.0, 164.8, 207.3, 345.0, 518.0)):
        x = x + (0.30 / (i + 1)) * sine(f, n, sr) * (0.7 + 0.3 * np.sin(2 * np.pi * 0.05 * t + i))
        x = x + (0.18 / (i + 1)) * sine(f * 1.007, n, sr)
    x = filt(x, "low", sr, 900, order=2)
    x = x + 0.35 * filt(brown(n), "low", sr, 90, order=3)
    return x

def b_leftcorridor(n, sr):
    t = np.arange(n) / sr
    wnd = filt(brown(n), "low", sr, 700, order=2) + \
        0.3 * filt(white(n), "band", sr, 1200, order=2, fc2=3000)
    gust = 0.5 + 0.35 * np.sin(2 * np.pi * 0.08 * t + 1.0) + 0.15 * np.sin(2 * np.pi * 0.21 * t)
    x = 0.75 * wnd * np.clip(gust, 0.1, 1.0) + 0.04 * sine(50, n, sr)
    for at in (4.2, 12.8, 19.6, 28.3, 35.9):
        m = int(0.7 * sr); tt = np.arange(m) / sr
        f0 = 1500 + rng.uniform(-300, 300)
        drip = np.sin(2 * np.pi * f0 * tt) * np.exp(-tt / 0.08)
        echo = (tt > 0.31)
        drip = drip + 0.35 * np.sin(2 * np.pi * f0 * (tt - 0.31)) * np.exp(-(tt - 0.31) / 0.08) * echo
        place_event(x, 0.09 * drip, at, sr)
    m = int(4.0 * sr); tt = np.arange(m) / sr
    fsw = 72 - 18 * tt / 4.0
    groan = filt(np.sin(2 * np.pi * np.cumsum(fsw) / sr), "low", sr, 240, order=2) * bump(m)
    place_event(x, 0.25 * groan, 24.0, sr)
    return x

def b_hall(n, sr):
    t = np.arange(n) / sr
    deep = 0.5 * sine(40.0, n, sr) + 0.4 * sine(40.5, n, sr)
    wash = filt(brown(n), "low", sr, 220, order=2) * (0.6 + 0.4 * np.sin(2 * np.pi * 0.05 * t + 0.5))
    shim = 0.02 * filt(white(n), "band", sr, 4500, order=2, fc2=7000)
    x = 0.8 * deep + 0.7 * wash + shim
    for at in (9.0, 26.5):
        m = int(7.0 * sr); tt = np.arange(m) / sr
        sw = filt(white(m), "low", sr, 120, order=3) * bump(m)
        place_event(x, 0.6 * sw, at, sr)
    return x

def b_crates(n, sr):
    x = 0.12 * filt(brown(n), "low", sr, 300, order=2) + \
        0.03 * filt(white(n), "high", sr, 6000, order=1)
    for at, f0 in ((7.5, 180.0), (20.3, 140.0), (31.7, 205.0)):
        m = int(0.9 * sr); tt = np.arange(m) / sr
        fsw = f0 - 60 * tt / 0.9
        stick = 0.6 + 0.4 * np.sign(np.sin(2 * np.pi * 7 * tt))
        creak = np.sin(2 * np.pi * np.cumsum(fsw) / sr) * stick
        creak = filt(creak, "band", sr, 300, order=2, fc2=900) * bump(m)
        place_event(x, 0.35 * creak, at, sr)
    m = int(0.3 * sr); tt = np.arange(m) / sr
    knock = sine(95, m, sr) * np.exp(-tt / 0.06) + \
        0.5 * filt(white(m), "low", sr, 400, order=2) * np.exp(-tt / 0.05)
    place_event(x, 0.4 * knock, 15.0, sr)
    return x

def b_death(n, sr):
    t = np.arange(n) / sr
    sub = 0.6 * sine(38.0, n, sr) + 0.5 * sine(41.3, n, sr)
    wash = filt(brown(n), "low", sr, 150, order=3) * (0.6 + 0.4 * np.sin(2 * np.pi * 0.06 * t + 2.0))
    x = sub + 0.7 * wash
    for at in (2.0, 9.5, 17.0, 24.5, 32.0):
        m = int(0.8 * sr); tt = np.arange(m) / sr
        p = sine(55, m, sr) * np.exp(-tt / 0.25) * bump(m)
        place_event(x, 0.45 * p, at, sr)
    x = x + 0.025 * sine(2800, n, sr) + 0.020 * sine(2897.0, n, sr)
    return x

# ================= SFX =================
def sfx_ui_click():
    n = int(0.09 * SR_S); t = np.arange(n) / SR_S
    x = sine(1250, n, SR_S) * np.exp(-t / 0.008) + 0.4 * white(n) * np.exp(-t / 0.002)
    render_sfx("sfx_ui_click", x, 0.55, desc="Klik UI pendek dan kering untuk tombol/menu.")

def sfx_ui_hover():
    n = int(0.07 * SR_S); t = np.arange(n) / SR_S
    x = 0.5 * sine(1900, n, SR_S) * np.exp(-t / 0.020)
    render_sfx("sfx_ui_hover", x, 0.30, desc="Blip hover sangat pelan saat kursor menyentuh pilihan.")

def sfx_type_tick():
    n = int(0.05 * SR_S); t = np.arange(n) / SR_S
    x = filt(white(n), "high", SR_S, 2800, order=2) * np.exp(-t / 0.006)
    render_sfx("sfx_type_tick", x, 0.35, desc="Detak mesin tik per huruf untuk efek teks berjalan.")

def sfx_choice_appear():
    n = int(0.45 * SR_S); t = np.arange(n) / SR_S
    a = int(0.25 * SR_S)
    env = np.ones(n); env[:a] = np.sin(0.5 * np.pi * np.linspace(0, 1, a)) ** 2
    env = env * np.exp(-t / 0.20)
    x = 0.6 * filt(white(n), "band", SR_S, 600, order=2, fc2=2800) * env + \
        0.25 * sine(220, n, SR_S) * env
    render_sfx("sfx_choice_appear", x, 0.5, fa=0.01, fb=0.05,
               desc="Desis lembut munculnya pilihan dialog.")

def sfx_pickup():
    n = int(0.35 * SR_S); t = np.arange(n) / SR_S
    x = sine(660, n, SR_S) * np.exp(-t / 0.12) * (t < 0.14) + \
        sine(880, n, SR_S) * np.exp(-np.clip(t - 0.14, 0, None) / 0.15) * (t >= 0.14)
    render_sfx("sfx_pickup", x, 0.55, desc="Nada ganda lembut saat mengambil item.")

def sfx_achievement():
    n = int(0.9 * SR_S); t = np.arange(n) / SR_S
    x = np.zeros(n)
    for i, (at, f) in enumerate(((0.0, 523.25), (0.18, 659.25), (0.36, 783.99))):
        m = int(0.5 * SR_S); tt = np.arange(m) / SR_S
        note = sine(f, m, SR_S) * np.exp(-tt / 0.30)
        place_event(x, 0.5 * note, at, SR_S)
    x = x + 0.08 * filt(white(n), "high", SR_S, 6000, order=2) * bump(n)
    render_sfx("sfx_achievement", x, 0.55, fa=0.01, fb=0.15,
               desc="Kilau tiga nada hangat untuk achievement terbuka.")

def sfx_death_sting():
    n = int(1.6 * SR_S); t = np.arange(n) / SR_S
    cl = np.zeros(n)
    for f in (110.0, 116.54, 123.47):
        ph = 2 * np.pi * f * t
        cl = cl + (2 * ((ph / (2 * np.pi)) % 1.0) - 1.0)
    cl = cl / 3.0 * np.exp(-t / 0.8)
    crash = filt(white(n), "low", SR_S, 4000, order=2) * np.exp(-t / 0.5) + \
        0.8 * filt(white(n), "low", SR_S, 500, order=2) * np.exp(-t / 0.9)
    x = 0.5 * cl + 0.7 * crash + 0.4 * sine(55, n, SR_S) * np.exp(-t / 0.9)
    render_sfx("sfx_death_sting", x, 0.85, fa=0.003, fb=0.3,
               desc="Sengatan kematian: klaster disonan + hantaman noise.")

def sfx_heal():
    n = int(1.3 * SR_S); t = np.arange(n) / SR_S
    env = bump(n)
    tone = sweep_tone(200, 340, n, SR_S)
    air = filt(white(n), "band", SR_S, 800, order=2, fc2=2400)
    x = (0.5 * tone + 0.3 * air) * env
    render_sfx("sfx_heal", x, 0.55, fa=0.05, fb=0.2,
               desc="Hembusan hangat menenangkan saat HP pulih.")

def sfx_dice_roll():
    n = int(0.8 * SR_S)
    x = np.zeros(n)
    for i, at in enumerate((0.0, 0.07, 0.15, 0.24, 0.34, 0.45, 0.57, 0.68)):
        m = int(0.03 * SR_S); tt = np.arange(m) / SR_S
        click = filt(white(m), "high", SR_S, 1800, order=2) * np.exp(-tt / 0.008)
        click = click + 0.4 * sine(2500, m, SR_S) * np.exp(-tt / 0.006)
        place_event(x, (0.9 - 0.06 * i) * click, at, SR_S)
    render_sfx("sfx_dice_roll", x, 0.6, desc="Derik dadu: rangkaian klik berderak.")

def sfx_paper_rustle():
    n = int(0.6 * SR_S)
    hp = filt(white(n), "high", SR_S, 1200, order=2)
    e = np.abs(filt(rng.standard_normal(n), "low", SR_S, 30, order=1))
    e = e / (np.max(e) + 1e-12)
    x = hp * (0.3 + 0.7 * e)
    render_sfx("sfx_paper_rustle", x, 0.5, fa=0.02, fb=0.08,
               desc="Gemeresik kertas saat membuka dokumen/catatan.")

def sfx_door_creak():
    n = int(1.4 * SR_S); t = np.arange(n) / SR_S
    fsw = 250 - 120 * t / 1.4 + 15 * np.sin(2 * np.pi * 3 * t)
    am = 0.55 + 0.45 * np.sign(np.sin(2 * np.pi * 6.5 * t))
    src = np.sin(2 * np.pi * np.cumsum(fsw) / SR_S) * am
    # saw-ish edge: add harmonic
    src = src + 0.3 * np.sin(4 * np.pi * np.cumsum(fsw) / SR_S) * am
    x = filt(src, "band", SR_S, 350, order=2, fc2=1100) + \
        0.15 * filt(white(n), "band", SR_S, 800, order=2, fc2=2000) * am
    x = x * bump(n) ** 0.7
    render_sfx("sfx_door_creak", x, 0.65, fa=0.05, fb=0.15,
               desc="Derit pintu kayu: gesekan stick-slip bernada turun.")

def sfx_metal_clang():
    n = int(1.6 * SR_S); t = np.arange(n) / SR_S
    x = np.zeros(n)
    for f, tau, g in ((211.0, 1.1, 0.5), (347.0, 0.8, 0.4), (522.0, 0.6, 0.32),
                      (891.0, 0.4, 0.22), (1320.0, 0.28, 0.15)):
        x = x + g * sine(f, n, SR_S) * np.exp(-t / tau) + \
            0.6 * g * sine(f * 1.003, n, SR_S) * np.exp(-t / tau)
    x = x + 0.6 * filt(white(n), "high", SR_S, 3000, order=2) * np.exp(-t / 0.01)
    render_sfx("sfx_metal_clang", x, 0.7, fa=0.002, fb=0.3,
               desc="Dentang logam: partial inharmonik berdecay panjang.")

def sfx_whisper():
    n = int(1.4 * SR_S)
    x = 0.15 * filt(white(n), "low", SR_S, 500, order=2)
    for at, fc in ((0.05, 1400.0), (0.50, 2100.0), (0.95, 1700.0)):
        m = int(0.34 * SR_S)
        syl = filt(white(m), "band", SR_S, fc, order=3, fc2=fc * 2.2) * bump(m)
        place_event(x, 0.8 * syl, at, SR_S)
    render_sfx("sfx_whisper", x, 0.5, fa=0.03, fb=0.15,
               desc="Bisikan tiga suku kata dari noise berfilter.")

def sfx_footstep():
    n = int(0.3 * SR_S); t = np.arange(n) / SR_S
    x = sine(62, n, SR_S) * np.exp(-t / 0.09) + \
        0.5 * filt(white(n), "low", SR_S, 350, order=2) * np.exp(-t / 0.05)
    render_sfx("sfx_footstep", x, 0.7, desc="Langkah kaki: debuk rendah + gesekan.")

def sfx_energy_low():
    n = int(0.9 * SR_S); t = np.arange(n) / SR_S
    x = np.zeros(n)
    for at in (0.0, 0.35):
        m = int(0.16 * SR_S); tt = np.arange(m) / SR_S
        env = np.sin(np.pi * np.linspace(0, 1, m)) ** 2
        beep = (sine(96, m, SR_S) + 0.3 * sine(288, m, SR_S)) * env
        place_event(x, 0.6 * beep, at, SR_S)
    render_sfx("sfx_energy_low", x, 0.6, desc="Peringatan energi rendah: dua denyut grave.")

def sfx_faint():
    n = int(1.1 * SR_S); t = np.arange(n) / SR_S
    tone = sweep_tone(420, 70, n, SR_S)
    wob = 0.8 + 0.2 * np.sin(2 * np.pi * 5 * t)
    env = np.ones(n)
    a = int(0.05 * SR_S)
    env[:a] = np.sin(0.5 * np.pi * np.linspace(0, 1, a)) ** 2
    env = env * np.exp(-t / 0.9)
    x = tone * wob * env + 0.15 * filt(white(n), "low", SR_S, 800, order=2) * env
    render_sfx("sfx_faint", x, 0.6, fa=0.02, fb=0.25,
               desc="Pingsan: nada turun melayang seperti kesadaran memudar.")

def sfx_heartbeat():
    n = int(1.1 * SR_S); t = np.arange(n) / SR_S
    x = sine(55, n, SR_S) * np.exp(-t / 0.16) * (t < 0.3) + \
        sine(50, n, SR_S) * np.exp(-np.clip(t - 0.34, 0, None) / 0.12) * (t >= 0.34)
    x = x + 0.3 * filt(white(n), "low", SR_S, 200, order=2) * np.exp(-t / 0.05)
    render_sfx("sfx_heartbeat", x, 0.8, fa=0.004, fb=0.2,
               desc="Detak jantung lub-dub untuk momen tegang.")

def sfx_jumpscare():
    n = int(1.4 * SR_S); t = np.arange(n) / SR_S
    boom = filt(white(n), "low", SR_S, 6000, order=2) * np.exp(-t / 0.35) + \
        0.9 * filt(white(n), "low", SR_S, 300, order=3) * np.exp(-t / 0.8)
    scr = np.zeros(n)
    for f in (690.0, 733.0, 1175.0, 1550.0):
        ph = 2 * np.pi * (f * t + 5.0 * np.sin(2 * np.pi * 6 * t))
        scr = scr + (2 * ((ph / (2 * np.pi)) % 1.0) - 1.0)
    scr = scr / 4.0 * np.exp(-t / 0.7)
    sub = sine(46, n, SR_S) * np.exp(-t / 0.5)
    x = 1.0 * white(n) * np.exp(-t / 0.004) + 0.9 * boom + 0.9 * scr + 0.9 * sub
    x = np.tanh(1.6 * x)
    render_sfx("sfx_jumpscare", x, 0.95, fa=0.001, fb=0.25,
               desc="Jumpscare: ledakan noise + jeritan disonan + hantaman sub.")

# ================= MAIN =================
if __name__ == "__main__":
    ambients = [
        ("amb_title", 40, b_title, 0.55,
         "Drone gelap sinematik untuk layar judul: sub bass dalam, dengung detuned, sapuan udara, ping metalik jauh."),
        ("amb_corridor", 40, b_corridor, 0.55,
         "Koridor: angin lorong (brown noise), dengung listrik 50Hz, tetesan air jauh menggema."),
        ("amb_reception", 40, b_reception, 0.50,
         "Resepsionis: dengung lampu neon 100Hz, desis halus, room tone steril."),
        ("amb_doorhub", 40, b_doorhub, 0.55,
         "Pusat pintu: gemuruh rendah berdenyut, resonansi metalik menyapu pelan."),
        ("amb_saferoom", 40, b_saferoom, 0.45,
         "Ruang aman: drone hangat paling tenang, 'napas' lambat, desis udara lembut."),
        ("amb_darkstare", 40, b_darkstare, 0.50,
         "Kehampaan tegang: nyaris hening, denyut sub sporadis, ping tinggi seperti tinnitus."),
        ("amb_teddyroom", 40, b_teddyroom, 0.55,
         "Ruang boneka: drone teredam, siulan angin, debuk pelan tak beraturan, nada tinggi bergoyang."),
        ("amb_steeldoor", 40, b_steeldoor, 0.55,
         "Pintu baja: drone metalik inharmonik berdenyut + gemuruh bawah."),
        ("amb_leftcorridor", 40, b_leftcorridor, 0.55,
         "Koridor kiri: angin kencang, tetesan bergema, erangan jauh teredam."),
        ("amb_hall", 40, b_hall, 0.55,
         "Aula luas: drone dalam berdenyut, sapuan udara lambat, gemuruh jauh membengkak."),
        ("amb_crates", 40, b_crates, 0.55,
         "Gudang peti: udara berdebu, derit kayu stick-slip, satu ketukan pelan."),
        ("amb_death", 40, b_death, 0.55,
         "Layar kematian: sub disonan, denyut jantung sekarat, gemerincing tegang."),
    ]
    for name, dur, build, target, desc in ambients:
        render_ambient(name, dur, build, target=target, desc=desc)

    for fn in (sfx_ui_click, sfx_ui_hover, sfx_type_tick, sfx_choice_appear,
               sfx_pickup, sfx_achievement, sfx_death_sting, sfx_heal,
               sfx_dice_roll, sfx_paper_rustle, sfx_door_creak, sfx_metal_clang,
               sfx_whisper, sfx_footstep, sfx_energy_low, sfx_faint,
               sfx_heartbeat, sfx_jumpscare):
        fn()

    # OGG alternatif via ffmpeg (libvorbis), WAV tetap wajib & utama
    for name, meta in MANIFEST.items():
        wav = os.path.join(OUT, meta["file"])
        ogg = os.path.join(OUT, name + ".ogg")
        r = subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", wav,
                            "-c:a", "libvorbis", "-q:a", "3", ogg])
        if r.returncode == 0:
            meta["ogg"] = name + ".ogg"

    with open(os.path.join(OUT, "audio-manifest.json"), "w") as f:
        json.dump(MANIFEST, f, indent=2, ensure_ascii=False)

    total = 0
    for dp, _, fns in os.walk(OUT):
        for fn in fns:
            total += os.path.getsize(os.path.join(dp, fn))
    print(f"TOTAL: {len(MANIFEST)} file WAV (+OGG), {total/1048576:.2f} MB")
