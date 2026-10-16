# ATTRIBUTION — Audio "The Asylum" v2

Seluruh file audio di direktori ini **disintesis prosedural dari nol** oleh tim rebuild
menggunakan script Python + numpy (`gen_audio.py`, seed deterministik `20261016`).
Tidak ada sampel, rekaman, atau aset pihak ketiga yang digunakan.

**Lisensi: CC0 (public domain)** — bebas dipakai, dimodifikasi, dan didistribusikan
untuk keperluan apa pun tanpa atribusi wajib.

## Daftar file

### Ambient loops (WAV mono 22050 Hz, 40 detik, seamless loop)

| File | Sumber | Lisensi |
|---|---|---|
| amb_title.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_corridor.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_reception.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_doorhub.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_saferoom.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_darkstare.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_teddyroom.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_steeldoor.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_leftcorridor.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_hall.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_crates.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| amb_death.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |

### SFX (WAV mono 44100 Hz)

| File | Sumber | Lisensi |
|---|---|---|
| sfx_ui_click.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_ui_hover.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_type_tick.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_choice_appear.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_pickup.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_achievement.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_death_sting.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_heal.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_dice_roll.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_paper_rustle.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_door_creak.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_metal_clang.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_whisper.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_footstep.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_energy_low.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_faint.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_heartbeat.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |
| sfx_jumpscare.wav | Disintesis prosedural oleh tim rebuild — CC0 | CC0 |

Setiap file juga tersedia dalam format `.ogg` (Vorbis, q3) sebagai alternatif —
dikonversi dari WAV di atas dengan ffmpeg, lisensi tetap CC0.

## Catatan reproduksibilitas

Jalankan `python3 gen_audio.py` di direktori ini untuk me-regenerate seluruh
aset secara bit-identik (RNG seed tetap).
