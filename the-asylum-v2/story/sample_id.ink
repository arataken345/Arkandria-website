EXTERNAL MENTAL_UP(n)
EXTERNAL MENTAL_DOWN(n)
EXTERNAL TIER_UP(stat)
EXTERNAL TIER_DOWN(stat)
EXTERNAL ENERGY_UP(n)
EXTERNAL ENERGY_DOWN(n)
EXTERNAL ADD_EMOTION(name, amt)
EXTERNAL ADD_TEMP(name, nodes)
EXTERNAL SET_STATUS(s)
EXTERNAL SET_BODY(text)
EXTERNAL GRANT_ITEM(id)
EXTERNAL ADD_FAVOR(npc, amt)
EXTERNAL UNLOCK_ACHV(id)
EXTERNAL TUT_POP(id)
EXTERNAL CHECKPOINT(name)
EXTERNAL DEATH()
EXTERNAL FAINT_CHECK()

VAR wounded = false
VAR pintu_dibuka = false

-> prolog

=== prolog ===
#KICKER:Prolog — Kebangkitan
#TAG:Ruang Observasi 3
#AUDIO:reception
~ TUT_POP("awal")
~ CHECKPOINT("awal")
~ ADD_EMOTION("Takut", 1)
~ MENTAL_UP(1)
~ GRANT_ITEM("cokelat")
~ ADD_TEMP("Ketakutan", 3)
~ SET_STATUS("danger")
~ ADD_FAVOR("Dokter Hantu", 1)
Kau terbangun di lantai yang dingin. Bau karbol dan besi memenuhi hidungmu.
Lampu lorong berkedip — mati, hidup, mati — seperti sesuatu yang bernapas.
Di sakumu ada sebatang cokelat. Kecil. Tapi nyata.
* [Berdiri dan periksa lorong]
    ~ MENTAL_DOWN(1)
    -> lorong
* [Duduk dulu. Tenangkan napas.]
    ~ ADD_EMOTION("Lega", 1)
    -> lorong

=== lorong ===
#KICKER:Bagian Satu — Lorong
#TAG:Lorong Barat
#AUDIO:corridor
#IMAGE:bg_corridor
~ TIER_UP("Stress")
~ ENERGY_DOWN(10)
Bayangan memanjang di dinding yang mengelupas. Sesuatu menetes di kejauhan — pelan, berirama.
Kau merasa diperhatikan.
* [Ikuti suara tetesan] -> tetesan
* [Bersembunyi di balik pintu terdekat]
    ~ UNLOCK_ACHV("smart_cross")
    -> ruang_aman

=== ruang_aman ===
#TAG:Ruang Arsip
#STATUS:safe
~ SET_STATUS("safe")
~ TIER_DOWN("Stress")
~ ADD_EMOTION("Lega", 1)
Kau menyelinap ke ruang arsip dan menahan napas. Langkah kaki lewat di depan pintu — lalu menjauh.
Untuk pertama kalinya malam ini, sunyi terasa aman.
* [Lanjutkan menyusuri lorong] -> tetesan

=== tetesan ===
#TAG:Ujung Lorong
#AUDIO:darkstare
~ SET_STATUS("wounded")
~ SET_BODY("Pergelangan kaki terkilir")
~ GRANT_ITEM("perban_kotor")
~ MENTAL_UP(1)
Pipa berkarat pecah tepat saat kau lewat. Pecahannya menghantam pergelangan kakimu.
Darah merembes. Setiap langkah kini terasa salah.
* {not wounded} [Berlari sekencang mungkin] -> lolos
* [Tertatih menuju cahaya di ujung]
    ~ ENERGY_DOWN(25)
    -> pintu_baja
* [Sentuh noda hitam di dinding] -> kematian

=== lolos ===
#TAG:Luar Bangunan?
Jalan ini seharusnya tidak ada — tapi kakimu ringan, dan udara di sini tidak berbau karbol.
Mungkin kau sudah keluar. Mungkin juga tidak.
-> END

=== pintu_baja ===
#KICKER:Bagian Dua — Pintu Baja
#TAG:Pintu Baja
#AUDIO:corridor
~ CHECKPOINT("pintu_baja")
~ TUT_POP("energi")
Pintu baja itu berkarat di engselnya. Di baliknya terdengar dengung mesin tua.
Tubuhmu terasa berat. Kau harus memilih dengan hemat.
* [Dorong pintunya]
    ~ ENERGY_DOWN(30)
    -> akhir
* [Istirahat sebentar dulu]
    ~ ENERGY_UP(25)
    ~ TIER_DOWN("Kelelahan")
    -> akhir
* {not pintu_dibuka} [Congkel kunci dengan koin]
    ~ pintu_dibuka = true
    ~ GRANT_ITEM("koin_logam")
    -> akhir

=== kematian ===
#TAG:Kegelapan
#AUDIO:death
Noda hitam itu hangat. Lalu dingin. Lalu — bukan apa-apa.
Kegelapan tidak bertanya. Ia hanya mengambil.
~ UNLOCK_ACHV("trap_victim")
~ DEATH()
-> END

=== akhir ===
#KICKER:Epilog Sampel
#TAG:Ambang
#AUDIO:reception
~ SET_STATUS("safe")
~ UNLOCK_ACHV("explorer")
~ ADD_EMOTION("Lega", 2)
~ MENTAL_DOWN(2)
Pintu terbuka dengan erangan panjang. Cahaya — cahaya yang sesungguhnya — menyambutmu.
Kau selamat. Untuk sampel ini, itu sudah cukup.
-> END
