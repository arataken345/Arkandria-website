// The Asylum v2 — Part 1 (Bahasa Indonesia)
// Dibangkitkan dari source/nodes.json oleh story/gen_ink.py — jangan edit manual,
// regenerasi via: python3 story/gen_ink.py
//
// Konvensi: knot per node lama; tag #KICKER/#TAG dibaca bridge.js dari currentTags;
// #AUDIO = ambient, #IMAGE = background, #SFX = one-shot SFX (lihat NODE_SFX).
// #MAJOR = scene utama/besar → drop cap di UI (hanya knot di MAJOR_KNOTS).
// Sticky choice: pilihan hilang setelah dipakai (perbaikan dari doneFlag lama).
// Bentuk: * {not f_x} [teks]  ~ f_x = true  -> target  (flag di-prefix f_)
// Cold open: prolog1 -> END (layar judul = UI shell); new game mulai di prolog2
// via story.ChoosePathString("prolog2").

// ---------- flags ----------
VAR f_d1 = false
VAR f_d2 = false
VAR f_d2c1 = false
VAR f_d2c2 = false
VAR f_d2c3 = false
VAR f_d3 = false
VAR f_d4 = false
VAR f_rec_coin = false
VAR f_rec_desk = false
VAR f_rec_left = false
VAR f_rec_photos = false
VAR f_rec_read = false

// ---------- external API (di-bind bridge.js) ----------
EXTERNAL MENTAL_UP(n)
EXTERNAL MENTAL_DOWN(n)
EXTERNAL TIER_UP(stat)
EXTERNAL TIER_DOWN(stat)
EXTERNAL ENERGY_DOWN(n)
EXTERNAL ENERGY_UP(n)
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

-> prolog1

=== prolog1 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
#MAJOR
Kamu terbangun di ujung lorong gelap yang bau dan lembap. Segalanya terasa kotor, penuh puing-puing dan pecahan kaca. Beberapa pintu rusak dan tergantung miring, membuat bayangan-bayangan aneh di bawah cahaya redup.
Di dinding ada coretan-coretan — seperti pesan atau peringatan, tetapi hampir semuanya susah untuk dibaca.
Lalu, kamu melihat tanganmu. Keduanya dibalut perban kotor. Tapi kamu nggak merasakan ada rasa sakit sama sekali.
Disaat kamu mencoba mengingat apa yang terjadi, kepalamu terasa kosong. Kamu nggak ingat apa-apa. Nggak tahu ini di mana, kenapa kamu di sini, atau harus ngapain.
// next="title" di game lama = layar judul (UI shell)
-> END

=== prolog2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:doorhub
#IMAGE:bg_doorhub
#MAJOR
Setelah berjalan ke depan dengan kebingungan sesaat, kini di depanmu terlihat empat pintu — masing-masing menampilkan kesannya tersendiri.
Pintu paling kiri tertutup rapat. Engselnya berkarat, tapi gagangnya terlihat agak bersih dari debu, seperti baru saja dipakai. Pintu kedua di kiri tampak terbuka lebar dan setengah rusak.
Kemudian, pintu pertama di sisi kanan berayun pelan, berderit kecil meski tak ada angin sedikit pun — seperti ada yang meniupnya. Pintu kedua lebih tenang dan normal, tapi dari celahnya kamu bisa lihat bayangan samar terletak di atas meja.
Lorong terus berlanjut, tapi suasananya makin tidak nyaman. Lampu-lampu berkedip tak menentu, dan entah dari mana, kamu sempat dengar suara gemerisik... lalu hening total.
-> opening

=== opening ===
#KICKER:Part 1 : Awal Mula
#AUDIO:doorhub
#IMAGE:bg_doorhub
#MAJOR
Kau berdiri di tengah lorong. Empat pintu mengapitmu — dua di kiri, dua di kanan — dan di depan, lorong terus berlanjut ke dalam kegelapan yang semakin pekat.
Apa yang akan kau lakukan?
* {not f_d1} [Mengecek pintu pertama di kiri]
    ~ f_d1 = true
    -> d1_hub
* {not f_d2} [Mengecek pintu kedua di kiri]
    ~ f_d2 = true
    -> d2_hub
* {not f_d3} [Mengecek pintu pertama di kanan]
    ~ f_d3 = true
    -> d3_hub
* {not f_d4} [Mengecek pintu kedua di kanan]
    ~ f_d4 = true
    -> d4_hub
* [Terus maju meski ragu.] -> d5_1

=== d1_hub ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
#MAJOR
Kau mendekati pintu paling kiri. Tertutup rapat. Engselnya berkarat — tapi gagang pintunya bersih. Terlalu bersih untuk tempat sekotor ini.
Seperti baru saja digenggam. Oleh seseorang. Atau sesuatu.
Kayunya dingin saat kau mendekat.
* [Tempelkan telinga ke pintu, dengarkan dulu] -> d1_a
* [Dorong perlahan, intip lewat celah] -> d1_b
* [Buka lebar-lebar sekaligus] -> d1_c

=== d1_a ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
Kau menempelkan telinga ke permukaan kayu yang dingin dan menahan napas.
Hening.
Kau mencoba mendengar sesuatu — apa pun — dari balik pintu. Tidak ada. Hanya dengung darah di telingamu sendiri dan... tunggu. Apakah itu detak?
Detak jantungmu sendiri, tentu saja. Pasti.
Tidak ada suara lain. Ruangan di baliknya sepertinya kosong.
-> d1_a2

=== d1_a2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
Pintu itu diam. Keputusanmu?
* [Buka pintunya, masuk] -> d1_room
* [Urungkan — kembali ke lorong] -> opening

=== d1_b ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
Kau mendorong pintu itu satu sentimeter. Dua sentimeter. Celah tipis menganga, dan kau mengintip dengan satu mata.
Gelap. Bau lembap yang lebih pekat menyeruak keluar. Samar-samar kau bisa melihat bentuk-bentuk: meja terbalik, kaki kursi yang patah. Tidak ada gerakan.
Tapi di ujung penglihatanmu, ada sesuatu yang berkilau redup di lantai — seperti bungkus plastik.
-> d1_b2

=== d1_b2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
Celah itu menunggu. Keputusanmu?
* [Masuk dan periksa] -> d1_room
* [Tutup perlahan, jangan ambil risiko] -> opening

=== d1_c ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
Kau menarik napas, lalu mendorong pintu itu lebar-lebar.
KRIIEEK.
Engsel berkarat itu menjerit — suaranya memantul di sepanjang lorong, terlalu keras, terlalu lama. Jantungmu berhenti sesaat. Kau berdiri mematung, menunggu. Apakah ada yang mendengar?
Satu detik. Dua detik. Tidak ada yang datang. Lorong kembali sunyi, seolah tidak terjadi apa-apa.
Ruangan di baliknya kosong dan gelap. Meja-meja terbalik. Hening.
-> d1_c2

=== d1_c2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
~ ADD_EMOTION("Takut", 1)
Derit itu mungkin terdengar sampai ujung lorong. Keputusanmu?
* [Masuk cepat sebelum ada yang datang] -> d1_room
* [Tutup dan mundur — terlalu berisik] -> opening

=== d1_room ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
Kau melangkah masuk. Udara di sini lebih dingin, dan baunya... tua. Seperti ruangan yang sudah bertahun-tahun tidak disentuh siapa pun.
Meja-meja terbalik berserakan. Di sudut, ada noda gelap di lantai — besar, tidak beraturan, meresap ke dalam beton. Kau tidak mau terlalu memikirkan apa itu.
Di bawah salah satu meja yang masih berdiri, ada sesuatu: sebungkus plastik bening berisi roti kering. Dan di sampingnya, selembar surat terlipat yang sudah menguning.
* [Ambil bungkusan itu] -> d1_loot
* [Periksa noda gelap itu dulu] -> d1_stain

=== d1_stain ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
~ ADD_EMOTION("Takut", 1)
Kau berjongkok di dekat noda itu. Warnanya cokelat kehitaman, tepinya tidak rata — merembes, bukan tumpah. Bau besi samar masih tercium jika kau mendekat.
Darah. Sudah sangat lama. Kering sepenuhnya.
Kau tidak tahu apakah itu membuatmu lega atau justru lebih takut.
-> d1_stain2

=== d1_stain2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
Noda itu tidak menjawab apa-apa. Bungkusan di bawah meja masih di sana.
* [Kembali dan ambil bungkusan itu] -> d1_loot
* [Tinggalkan semuanya, keluar dari sini] -> d1_empty

=== d1_loot ===
#TAG:[Aman]
#AUDIO:saferoom
#IMAGE:bg_saferoom
~ GRANT_ITEM("roti_kering")
~ GRANT_ITEM("surat_terlipat")
~ f_d1 = true
Kau meraih bungkusan plastik itu. Roti kering — tiga potong, masih dalam kemasan. Di sampingnya, surat terlipat itu terasa rapuh di jarimu.
Kau membukanya sekilas: tulisan tangan yang gemetar. 'Maafkan aku. Aku tidak bisa pulang. Jangan cari aku.' Tidak ada nama. Tidak ada tanggal.
Kau melipatnya kembali dan menyimpan keduanya. Setidaknya, perutmu tidak akan kosong untuk sementara waktu.
-> opening

=== d1_empty ===
#TAG:[Aman]
#AUDIO:saferoom
#IMAGE:bg_saferoom
~ f_d1 = true
Kau memutuskan bungkusan itu tidak sepadan dengan firasat burukmu. Kau keluar dan menutup pintu perlahan.
Lorong menyambutmu kembali — sama gelapnya, sama sunyinya.
-> opening

=== d2_hub ===
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
#MAJOR
Pintu kedua di kiri terbuka lebar, setengah rusak — kayunya retak, tergantung miring di satu engsel.
Di baliknya: ruang sempit yang dipenuhi lemari-lemari tua berderet, seperti arsip atau gudang penyimpanan. Bau kapur barus dan kayu lapuk menyambutmu.
Semuanya diam. Terlalu diam?
* [Lempar kerikil ke dalam, dengarkan] -> d2_a
* [Masuk dan buka lemari satu per satu] -> d2_room
* [Firasat buruk — mundur] -> d2_c

=== d2_a ===
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
Kau memungut pecahan kaca dari lantai dan melemparkannya ke dalam ruangan. KLONTANG — memantul di lantai beton, menggelinding.
Sunyi. Lalu... dari dalam salah satu lemari, terdengar bunyi pelan: tuk.
Seperti sesuatu yang jatuh. Atau bergeser.
Kau menunggu. Tidak ada lagi.
-> d2_a2

=== d2_a2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ ADD_EMOTION("Takut", 1)
Bunyi itu tidak terulang. Keputusanmu?
* [Masuk dan periksa] -> d2_room
* [Batalkan — kembali ke lorong] -> opening

=== d2_c ===
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
Kau mempercayai firasatmu dan melangkah mundur.
Tidak terjadi apa-apa. Dan justru itu yang mengganggumu — keheningan ruangan itu terasa... memperhatikan.
-> opening

=== d2_room ===
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
Ruangan sempit. Tiga lemari tua berderet di dinding, pintunya kusam. Bau kapur barus menusuk hidung.
Lemari pertama: pintunya sedikit terbuka. Lemari kedua: tertutup rapat. Lemari ketiga: terkunci — dan di permukaannya ada goresan-goresan panjang. Dari dalam.
* {not f_d2c1} [Buka lemari pertama]
    ~ f_d2c1 = true
    -> d2_c1
* {not f_d2c2} [Buka lemari kedua]
    ~ f_d2c2 = true
    -> d2_c2
* {not f_d2c3} [Periksa lemari ketiga yang terkunci]
    ~ f_d2c3 = true
    -> d2_c3
* [Keluar dari ruangan ini] -> d2_done

=== d2_c1 ===
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ GRANT_ITEM("perban_kotor")
~ f_d2c1 = true
Kosong. Hanya debu tebal dan bau apek. Tapi di sudut bawahnya ada sesuatu yang terlipat: sepotong kain putih kusam — perban, masih digulung, meski kotor.
Kau mengambilnya. Lebih baik daripada tidak sama sekali. Mungkin.
-> d2_room

=== d2_c2 ===
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ ADD_EMOTION("Sedih", 1)
~ GRANT_ITEM("cokelat")
~ f_d2c2 = true
Kau membuka lemari kedua — dan sesuatu jatuh dari rak atas: sepatu kecil. Sepatu anak.
Kau menatapnya sesaat, lalu memaksakan diri melihat isi lemari: di rak bawah ada sebatang cokelat yang masih terbungkus rapat. Sedikit meleleh, tapi utuh.
Kau mengambil cokelat itu. Sepatu itu kau biarkan. Kau tidak sanggup menyentuhnya.
-> d2_room

=== d2_c3 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
Kau mendekati lemari ketiga. Terkunci. Goresan-goresan panjang menghiasi pintunya — dalam, berulang, seperti dibuat dengan kuku. Dari dalam.
Kau menempelkan tangan ke kayunya. Dingin.
-> d2_c3x

=== d2_c3x ===
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
Lemari itu diam. Terlalu diam.
* [Tempelkan telinga, dengarkan] -> d2_c3b
* [Jangan sentuh — jauhi] -> d2_c3c

=== d2_c3b ===
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ TIER_UP("Stress")
~ ADD_EMOTION("Takut", 2)
~ f_d2c3 = true
Sunyi... lalu: napas. Pelan, berat, tepat di balik kayu tipis itu.
Kau melompat mundur, jantung menghantam rusuk. Napas itu berhenti. Tidak ada lagi.
Apapun itu — ia masih di sana. Atau baru saja pergi. Kau tidak mau tahu.
-> d2_room

=== d2_c3c ===
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ ADD_EMOTION("Lega", 1)
~ f_d2c3 = true
Kau mundur perlahan, tidak melepaskan pandangan dari lemari itu.
Tidak terjadi apa-apa. Untuk kali ini, kehati-hatianmu terbayar.
-> d2_room

=== d2_done ===
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ f_d2 = true
Kau keluar dari ruang lemari dan kembali ke lorong.
Di belakangmu, ruangan itu kembali sunyi — tapi kau tidak bisa menghilangkan perasaan bahwa keheningan itu menunggu.
-> opening

=== d3_hub ===
#KICKER:Part 1 : Awal Mula
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
#MAJOR
Pintu pertama di kanan berayun pelan. Berderit kecil. Tidak ada angin — tapi ia bergerak, seperti dihembus sesuatu yang tidak terlihat.
Dari celahnya, kau mendengar sesuatu: detak. Pelan, berirama. Seperti... detak jantung? Atau jam?
Udara yang keluar dari celah itu dingin. Tidak wajar dinginnya.
* [Ikuti suara detak itu — masuk] -> d3_a
* [Diam di ambang pintu, amati dulu] -> d3_b
* [Mundur perlahan, tutup pintu] -> d3_c

=== d3_a ===
#KICKER:Part 1 : Awal Mula
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
Kau melangkah masuk. Dingin langsung merayap naik dari kakimu, seperti air es.
Detak itu semakin jelas — tapi kau sadar, itu bukan jam. Terlalu tidak beraturan. Terlalu... hidup.
Lalu kau melihatnya. Di sudut ruangan, udara beriak seperti air — dan sepasang mata merah menyala membuka di dalam kegelapan yang tak berwujud.
Ia melihatmu.
-> d3_a2

=== d3_a2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ ADD_EMOTION("Takut", 2)
Mata merah itu menyipit. Ia mulai bergerak ke arahmu.
* [Beku — jangan bergerak sama sekali] -> d3_a2a
* [Putar balik dan LARI] -> d3_a2b

=== d3_a2a ===
#TAG:[Dalam bahaya]
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ SET_STATUS("danger")
~ TIER_UP("Stress")
~ f_d3 = true
Kau memaksa tubuhmu diam. Jangan bernapas. Jangan berkedip.
Sosok transparan itu melayang mendekat. Dingin menusuk tulangmu saat ia mengitarimu — kau bisa merasakan kebencian memancar darinya, seperti radiasi.
Lalu... ia berhenti. Mata merah itu menyipit. Perlahan, ia mundur, melebur kembali ke dalam kegelapan ruangan.
Kau tidak tahu kenapa ia melepaskanmu. Kau tidak mau tahu. Kakimu gemetar saat kau melangkah mundur keluar.
-> opening

=== d3_a2b ===
#TAG:[Terluka]
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ SET_STATUS("wounded")
~ TIER_UP("Stress")
~ SET_BODY("Lengan Kiri Tergores")
~ f_d3 = true
Kau berbalik dan lari — tapi ia lebih cepat.
Dingin membakar lengan kirimu saat sesuatu yang tak terlihat mencakar lewat. Kau terhuyung, tapi terus berlari, menerobos pintu dan membantingnya di belakangmu.
Napasmu memburu. Lengan kirimu perih — tiga garis merah menganga di kulitmu, dan dinginnya masih terasa menusuk sampai ke tulang.
Kau terluka. Dan kau sadar satu hal: ia tidak mengejarmu keluar. Ia hanya... menjaga ruangan itu.
-> opening

=== d3_b ===
#TAG:[Dalam bahaya]
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ SET_STATUS("danger")
~ ADD_EMOTION("Takut", 1)
~ f_d3 = true
Kau tetap di ambang pintu, tidak masuk. Hanya mengamati.
Detak itu berlanjut. Lalu, perlahan, sepasang mata merah menyala muncul dari kegelapan — dan menatap lurus ke arahmu.
Kau tidak bergerak. Ia tidak bergerak. Waktu berhenti.
Kemudian mata itu berkedip — sekali — dan menghilang. Detak itu pun berhenti.
Pesannya jelas: ia tahu kau di sini. Dan ia membiarkanmu pergi. Untuk sekarang.
-> opening

=== d3_c ===
#TAG:[Aman]
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ TIER_UP("Stress")
~ ADD_EMOTION("Takut", 1)
~ f_d3 = true
Kau mundur selangkah. Dua langkah. Tanganmu meraih gagang pintu.
Tepat saat pintu hampir tertutup, detak itu... berhenti.
Hening total. Lalu, dari balik pintu yang nyaris rapat, terdengar bunyi gesekan pelan — seperti kuku di kayu. Sekali. Dua kali.
Kau menutup pintu sepenuhnya dan mundur. Jantungmu masih berdebar lama setelahnya.
-> opening

=== d4_hub ===
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
#MAJOR
Pintu kedua di kanan lebih tenang. Dari celahnya, kau bisa melihat sebuah meja — dan di atasnya, bayangan samar.
Kau mendorong pintu itu. Ruangan kecil. Meja kayu di tengah. Dan di atasnya...
Sebuah boneka beruang. Usang, satu matanya lepas, tapi bersih — terlalu bersih untuk tempat ini. Seolah seseorang merawatnya.
* [Ambil bonekanya langsung] -> d4_a
* [Periksa meja dan sekitarnya dulu] -> d4_b
* [Jangan sentuh apa pun — pergi] -> d4_c

=== d4_a ===
#TAG:[Aman]
#AUDIO:corridor
#IMAGE:bg_corridor
~ ADD_EMOTION("Lega", 1)
~ ADD_EMOTION("Takut", 1)
~ GRANT_ITEM("boneka")
~ f_d4 = true
Kau mengangkat boneka itu. Ringan. Dan... hangat.
Kehangatan yang aneh menjalar ke tanganmu — seperti baru saja dipeluk seseorang. Kau merinding.
Lalu kau menyadarinya: mata boneka yang masih ada itu... menatapmu. Tadi, saat di atas meja, ia menghadap ke arah lain. Bukankah begitu?
Kau memeluknya erat-erat. Entah kenapa, benda ini terasa penting.
-> opening

=== d4_b ===
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
Kau menahan diri dan memeriksa ruangan dulu. Meja itu kosong selain boneka. Tapi di bawah meja, terselip sesuatu: selembar kertas gambar anak-anak, digambar dengan crayon.
Gambarnya: sebuah keluarga — ayah, ibu, anak — bergandengan tangan. Dan di belakang mereka, sosok tinggi hitam dengan mata merah.
Crayon merahnya ditekan begitu keras sampai kertasnya sobek tepat di bagian mata itu.
-> d4_b2

=== d4_b2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
Gambar itu terasa dingin di jarimu. Boneka itu masih di atas meja.
* [Ambil bonekanya juga] -> d4_a
* [Ambil gambarnya saja, tinggalkan boneka] -> d4_draw
* [Tinggalkan semuanya] -> d4_c

=== d4_draw ===
#TAG:[Aman]
#AUDIO:corridor
#IMAGE:bg_corridor
~ ADD_EMOTION("Takut", 1)
~ GRANT_ITEM("gambar_crayon")
~ f_d4 = true
Kau mengambil gambar itu dan melipatnya hati-hati. Bonekanya kau biarkan di atas meja.
Saat kau berbalik, dari sudut matamu — kau bersumpah kepala boneka itu sedikit miring. Mengikutimu.
Kau tidak menoleh lagi.
-> opening

=== d4_c ===
#TAG:[Aman]
#AUDIO:corridor
#IMAGE:bg_corridor
~ TIER_UP("Stress")
~ ADD_EMOTION("Takut", 2)
~ f_d4 = true
Kau memutuskan untuk tidak menyentuh apa pun. Nalurimu berteriak.
Kau melangkah mundur menuju pintu. Dan saat itulah kau mendengarnya — pelan, hampir tidak ada:
'...jangan pergi.'
Suaranya seperti anak kecil. Berasal dari... boneka itu? Atau dari kepalamu sendiri?
Kau keluar dan menutup pintu. Tanganmu gemetar.
-> opening

=== d5_1 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:doorhub
#IMAGE:bg_doorhub
Kau mengabaikan pintu-pintu itu dan terus melangkah ke ujung lorong.
Lampu-lampu di sini berkedip makin cepat. Langkah kakimu bergema... dan kau menyadarinya: gemanya salah. Ada setengah ketukan tambahan di antara langkahmu — seperti ada yang berjalan bersamamu, sedikit tidak selaras.
Kau berhenti. Gema itu berhenti... setengah detik lebih lambat.
Di depan, deretan lampu di langit-langit berkedip liar — kecuali satu. Satu lampu menyala stabil, terang, mengundang.
Di bawah lampu yang stabil itu, kau melihat sesuatu yang janggal: lantainya bersih. Tidak ada debu, tidak ada puing — padahal seluruh lorong ini kotor. Seperti tempat itu... dirawat. Atau sering ditunggu.
Dan kau teringat: tadi, saat bayangan besar melintas di kejauhan, setiap lampu yang dilewatinya berkedip liar.
-> d5_1c

=== d5_1c ===
#KICKER:Part 1 : Awal Mula
#AUDIO:doorhub
#IMAGE:bg_doorhub
~ ADD_EMOTION("Takut", 1)
Gema langkah itu masih ada — setengah ketukan di belakangmu. Lampu yang stabil itu menunggu.
Apa yang akan kau lakukan?
// REQ: energy>=15 (bridge.js mengunci bila tak terpenuhi)
* [Berlari ke lampu yang stabil — terang berarti aman (butuh 15 energi)] -> d5_trap
* [Bergerak di antara kedipan, tetap dalam bayangan — Butuh fokus (mental ≤ Gelisah)] -> d5_smart
* [Berbalik kembali ke persimpangan pintu] -> d5_back

=== d5_trap ===
#AUDIO:doorhub
#IMAGE:bg_doorhub
Kau berlari menuju cahaya. Terang berarti aman — itu naluri, itu logika.
Cahaya itu menyilaukan. Kau tidak melihat kegelapan di sekitarnya — dan di situlah ia berdiri.
Sosok besar tanpa kepala. Bertangan banyak. Kapak besar terangkat.
Lampu yang stabil itu bukan tempat aman. Itu tempatnya menunggu. Lampu-lampu lain berkedip karena ia lewat — yang satu ini stabil karena ia tidak pernah pergi.
Kau tak sempat menyesal.
// respawn lama: hub_exit (bridge: pasang CHECKPOINT di hub terkait)
~ DEATH()
-> END

=== d5_smart ===
#TAG:[Aman]
#AUDIO:doorhub
#IMAGE:bg_doorhub
~ TIER_UP("Kelelahan")
~ ADD_EMOTION("Takut", 1)
Kau memaksa kakimu diam. Bernapas pelan. Mengamati.
Pola kedip lampu-lampu itu... tidak acak. Setiap beberapa detik, satu lampu berkedip liar — berpindah, mendekat. Sesuatu bergerak di lorong itu, dari lampu ke lampu.
Kau bergerak hanya saat lampu di depanmu padam dalam kedipnya — berlari pendek dalam gelap, berhenti dalam bayangan. Jantungmu menghantam rusuk, tapi kau tidak berhenti.
Saat kau melewati lampu yang stabil itu, kau tidak menoleh. Kau sudah tahu apa yang menunggu di sana.
Lorong terbuka ke sebuah pertigaan. Kau berhasil.
-> hub_exit

=== d5_back ===
#TAG:[Aman]
#AUDIO:doorhub
#IMAGE:bg_doorhub
~ ADD_EMOTION("Takut", 1)
Kau berbalik — perlahan, tanpa membelakangi kegelapan terlalu lama.
Gema setengah ketukan itu mengikutimu beberapa langkah, lalu... hilang. Seperti tidak pernah ada.
Kau kembali ke persimpangan pintu dengan napas memburu. Setidaknya kau masih hidup.
-> opening

=== hub_exit ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
#MAJOR
Langkah-langkahmu melambat, nyaris tanpa suara di atas lantai yang dingin, hingga kau tiba di sebuah pertigaan lorong. Di tengahnya, seperti bangkai hewan purba, berdiri meja resepsionis tua yang nyaris hancur — permukaannya retak, tepinya mengelupas, dan di atasnya berserakan tumpukan kertas yang telah menjadi sarang debu. Dari balik meja itu, dua lorong lain membentang: yang kiri tenggelam dalam kegelapan pekat, sunyi hingga kau bisa mendengar darahmu sendiri berdenyut di telinga; yang kanan, di ujungnya, memancarkan secercah cahaya redup yang bergoyang pelan, seolah mengundangmu mendekat — atau memancingmu.
Kau menarik napas, dan udara di sini terasa salah — berat, pengap, seakan tempat ini menyimpan terlalu banyak hal yang tak seharusnya diingat. Dan suara-suara itu… bisikan-bisikan samar yang sejak tadi mengikutimu, kini terdengar lebih dekat, merayap di sepanjang dinding seperti sesuatu yang hidup, menolak pergi, menolak membiarkanmu sendirian dengan pikiranmu sendiri.
-> reception_hub

=== reception_hub ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
#MAJOR
Kau berdiri di jantung pertigaan itu, dikelilingi kebisuan yang terasa berat menekan kulitmu. Meja resepsionis yang hancur itu membusuk dalam diam di tengah ruangan, tumpukan kertas berdebu di atasnya seolah menyimpan rahasia yang tak berani dibuka. Lorong kiri menganga gelap dan sunyi, menelan setiap suara; lorong kanan menjanjikan cahaya redup yang tak bisa sepenuhnya kau percaya. Dan di antara semuanya, suara-suara aneh itu masih berkeliaran — samar, sabar, menghantuimu.
* {not f_rec_desk} [Periksa area sekitar meja resepsionis]
    ~ f_rec_desk = true
    -> rec_desk_1
* {not f_rec_left} [Masuki lorong kiri yang gelap dan sunyi]
    ~ f_rec_left = true
    -> rec_left_1
* [Periksa tumpukan kertas di atas meja] -> rec_papers_1

=== rec_desk_1 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
Kau berjongkok di sisi meja, dan lututmu langsung tenggelam dalam lapisan debu yang tebalnya hampir seperti kain. Bau apek menyengat naik ke hidungmu — bau kertas busuk, kayu lapuk, dan sesuatu yang lebih tua, lebih manis, yang tak ingin kau kenali. Kolong meja di hadapanmu gelap seperti mulut yang menganga, menolak memantulkan cahaya apa pun.
Jari-jarimu meraba di antara serpihan-serpihan tak dikenal — pecahan yang tajam di satu sisi, lunak dan berlendir di sisi lain — hingga ujung jarimu menyentuh sesuatu yang berbeda: kecil, bulat, dan dingin seperti es, tergeletak diam di lantai yang berdebu.
-> rec_desk_2

=== rec_desk_2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
Kau masih berjongkok, napasmu tertahan, dan dalam gelap kolong meja itu dua hal menarik perhatianmu: lantai berdebu yang dingin di bawah telapak tanganmu, dan gundukan puing di sekitar kaki meja — keduanya seolah menyimpan sesuatu yang menunggu ditemukan.
* [Raba lantai berdebu di kolong meja] -> rec_desk_floor
* [Periksa puing di sekitar kaki meja] -> rec_desk_rubble

=== rec_desk_floor ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
Kau meraba dalam kegelapan kolong meja, jari-jarimu menyapu lantai yang dingin dan berpasir. Lalu — sentuhan logam. Kecil, bulat, dingin menusuk, dengan permukaan kasar yang menggores kulitmu. Jantungmu berdebar sedikit lebih kencang, tanpa alasan yang jelas.
Kau menariknya keluar ke cahaya: sebuah koin logam tua, permukaannya begitu kusam hingga nyaris hitam, tepiannya terkikis waktu. Tidak ada ukiran yang bisa dikenali, tidak ada kilau, tidak ada makna. Tidak istimewa — tapi nyata, berat di telapak tanganmu, sebuah benda yang pernah disentuh tangan orang lain di tempat yang sudah lama mati ini.
-> rec_desk_floor_2

=== rec_desk_floor_2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
Koin itu tergeletak di telapak tanganmu yang kotor, dinginnya perlahan meresap ke kulitmu, seolah menuntut sebuah keputusan.
* [Ambil koin itu] -> rec_coin
* [Biarkan saja di sana] -> rec_desk_back

=== rec_desk_rubble ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
Kau menggeser puing-puing itu satu per satu: pecahan ubin yang tajam seperti gigi, sebuah cangkir kertas yang penyok dan menguning, pulpen plastik yang tintanya sudah lama kering. Sampah-sampah biasa dari sebuah kehidupan yang sudah berhenti.
Lalu matamu menangkap selembar kertas robek, terjepit di bawah pecahan ubin. Di atasnya, dengan tinta yang memudar, tertulis setengah kalimat: '...jangan percaya...' — dan sisanya hilang, terkoyak bersama separuh kertas yang tak pernah ditemukan. Jari-jarimu gemetar sedikit saat memegangnya.
Kau mengobrak-abrik sisa puing itu, tapi tidak ada lagi. Hanya debu yang beterbangan dan menempel di tenggorokanmu, dan bau apek yang semakin pekat, seolah tempat ini kecewa kau tidak menemukan apa-apa.
-> rec_desk_rubble_2

=== rec_desk_rubble_2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
Puing itu tidak menyimpan apa-apa lagi — hanya bisu, debu, dan bau lapuk yang menempel di pakaianmu.
* [Kembali berdiri] -> rec_desk_back

=== rec_coin ===
#KICKER:Part 1 : Awal Mula
#TAG:[Aman]
#AUDIO:reception
#IMAGE:bg_reception
~ GRANT_ITEM("koin_logam")
~ f_rec_coin = true
~ f_rec_desk = true
Kau memungut koin itu. Kusam, ringan, biasa saja — dinginnya menusuk telapak tanganmu sesaat sebelum perlahan menghangat oleh panas tubuhmu. Tidak ada ukiran rahasia, tidak ada petunjuk tersembunyi, tidak ada bisikan dari masa lalu.
Hanya sebuah koin tua. Benda mati dari tempat yang mati. Kau menyimpannya ke dalam saku — bukan karena berharga, tapi karena di tempat seperti ini, sesuatu yang nyata terasa lebih baik daripada tidak memegang apa-apa.
-> reception_hub

=== rec_desk_back ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
~ f_rec_desk = true
Kau berdiri, menepuk debu dari lututmu hingga awan kelabu kecil beterbangan di udara. Area meja tidak menyimpan apa-apa lagi — hanya bangkai kayu tua dan tumpukan kertas yang akan terus membusuk dalam diam.
Di belakangmu, pertigaan itu menunggumu kembali: lorong kiri yang gelap gulita, lorong kanan dengan cahaya redupnya, dan suara-suara aneh yang tak pernah benar-benar pergi.
-> reception_hub

=== rec_left_1 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:leftcorridor
#IMAGE:bg_leftcorridor
Kau melangkah ke lorong kiri, dan seketika dunia di belakangmu terasa runtuh. Udara di sini berbeda — lebih dingin, lebih lembap, lebih berat, seperti paru-paru tempat ini sendiri sedang membusuk perlahan. Setiap langkahmu bergema pelan di lantai beton, sebuah bunyi yang tidak pantas terdengar sendirian di tempat sepi ini.
Kegelapan di lorong ini lebih tebal, lebih rakus. Ia menelan cahaya dari pertigaan di belakangmu satu langkah demi langkah, sampai yang tersisa hanyalah selaput hitam yang menutup di sekelilingmu. Lorong ini pendek — kau merasakannya dari cara dinding-dindingnya menutup di kejauhan — tetapi setiap meter terasa seperti ditarik mundur ke dalam sebuah rahang yang perlahan menutup.
-> rec_left_2

=== rec_left_2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:leftcorridor
#IMAGE:bg_leftcorridor
Di ujung lorong — tanpa pintu samping, tanpa celah apa pun — berdiri sebuah pintu baja tebal. Logamnya memantulkan sisa cahaya dengan dingin, kusam, dan tak bersahabat. Lorong ini buntu. Kakimu telah membawamu sejauh ia bisa melangkah, dan satu-satunya yang menunggumu di sini hanyalah diamnya baja itu.
* [Melangkah perlahan ke pintu baja] -> rec_left_door
* [Kembali ke pertigaan] -> rec_left_back

=== rec_left_door ===
#KICKER:Part 1 : Awal Mula
#AUDIO:steeldoor
#IMAGE:bg_steeldoor
#SFX:door_creak
Kau menatap pintu baja itu dari dekat, dan napasmu tercekat. Ia terkunci rapat — tidak ada gagang, tidak ada lubang kunci, bahkan tidak ada celah yang cukup lebar untuk menyelipkan ujung jari. Permukaannya dingin dan licin di bawah sentuhanmu, seperti kulit hewan yang sudah lama mati.
Lalu kau melihatnya. Goresan-goresan dalam membelah permukaan baja itu, berulang dan sejajar — bekas cakaran. Kau menelan ludah; tidak ada manusia yang cakarnya sanggup menembus logam setebal ini. Sesuatu yang jauh lebih kuat dari manusia pernah mencoba mendobrak... dari sisi lain.
-> rec_left_door_2

=== rec_left_door_2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:steeldoor
#IMAGE:bg_steeldoor
#SFX:door_creak
Pintu itu diam — diam yang tidak wajar, diam yang seolah sedang menahan napas. Dari celah tipis di bawahnya merembes bau besi berkarat, dan di baliknya... sesuatu yang busuk, samar, seperti daging yang dibiarkan membusuk di ruangan tanpa udara. Bau itu membuat perutmu mual.
* [Dorong pintu baja itu] -> rec_left_push
* [Telusuri goresan di permukaan pintu] -> rec_left_scratch
* [Kembali ke pertigaan] -> rec_left_back

=== rec_left_push ===
#KICKER:Part 1 : Awal Mula
#TAG:[Aman]
#AUDIO:steeldoor
#IMAGE:bg_steeldoor
#SFX:metal_clang
~ ADD_EMOTION("Takut", 1)
~ f_rec_left = true
Kau menahan napas dan mendorong sekuat tenaga — bahumu menabrak logam yang dingin itu, otot-ototmu menegang sampai gemetar. Pintu itu tidak bergeming sedikit pun, seolah telah dilas mati oleh dunia ini sendiri.
Lalu — dentum pelan, dalam, yang menggema di dadamu seperti jantung kedua. Hening. Dan dari sisi lain pintu itu... terdengar sesuatu yang bergeser. Pelan. Berat. Menjauh, atau mendekat — kau tidak bisa tahu. Kakimu memutuskan lebih dulu daripada kepalamu: kau mundur, tangan gemetar, napas tercekat di tenggorokan.
-> reception_hub

=== rec_left_scratch ===
#KICKER:Part 1 : Awal Mula
#AUDIO:steeldoor
#IMAGE:bg_steeldoor
Ujung jarimu menelusuri goresan itu, dan kau merasakan logam yang terkoyak — dalam, kasar, tak kenal ampun. Goresan-goresan itu berulang dalam pola sejajar, ritmis, seperti cakaran yang menyerang lagi dan lagi. Terlalu lebar untuk tangan manusia. Terlalu dalam untuk sesuatu yang bukan binatang... atau sesuatu yang lebih buruk dari binatang.
Dan kemudian darahmu menjadi es. Sudut-sudut sobekannya — kau melihatnya sekarang — menunjuk ke dalam, ke arahmu. Goresan ini tidak dibuat dari sisi luar. Goresan ini berasal dari SISI DALAM pintu. Sesuatu di balik baja itu pernah mencoba... KELUAR.
-> rec_left_door_2

=== rec_left_back ===
#KICKER:Part 1 : Awal Mula
#AUDIO:leftcorridor
#IMAGE:bg_leftcorridor
~ f_rec_left = true
Kau melangkah mundur perlahan, kaki terseret, tidak pernah melepaskan pandangan dari pintu baja itu. Setiap langkah mundur terasa seperti menarik dirimu keluar dari mulut sesuatu yang sedang tidur.
Di pertigaan, cahaya menyambutmu dengan samar — dan baru di sana kau menyadari napasmu memburu, keringat dingin membasahi tengkuk. Kau telah kembali. Tetapi di punggungmu, lorong kiri itu tetap menganga, dan kau tidak berani membelakanginya terlalu lama.
-> reception_hub

=== rec_papers_1 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
#SFX:paper_rustle
Kau mendekati meja resepsionis. Di atasnya: tumpukan kertas berdebu, beberapa terikat tali yang sudah lusuh dan lapuk, tepi-tepinya menguning dimakan waktu. Debu beterbangan di udara saat kau bergerak, menari dalam cahaya samar seperti abu dari sesuatu yang terbakar lama.
Lembar paling atas menyambutmu dengan tulisan tangan yang besar dan tergesa: 'Eksperimen Subjek ke-X'. Huruf-hurufnya miring, ditekan keras sampai menembus kertas. Jantungmu berdebar begitu keras hingga kau yakin lorong-lorong kosong ini bisa mendengarnya.
-> rec_papers_2

=== rec_papers_2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
Kertas-kertas itu menunggu — diam, sabar, seolah mereka sudah menunggu seseorang selama bertahun-tahun. Ujung-ujungnya bergetar diterpa udara dingin... atau itu tanganmu yang gemetar. Kau tidak bisa lagi membedakannya.
* {not f_rec_read} [Baca lembar paling atas]
    ~ f_rec_read = true
    -> rec_papers_read
* {not f_rec_photos} [Lihat foto-foto terlampir]
    ~ f_rec_photos = true
    -> rec_papers_photos
* [Ambil beberapa lembar yang utuh] -> rec_papers_take

=== rec_papers_read ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
#SFX:paper_rustle
~ ADD_EMOTION("Takut", 1)
~ f_rec_read = true
Catatan itu ditulis dengan ketenangan yang menjijikkan. Setiap halaman menjabarkan prosedurnya secara rinci dan dingin — bagaimana seorang manusia dibelah, dipotong-potong, lalu disusun ulang dengan bagian-bagian yang tidak semestinya menempel pada tubuh siapa pun. Langkah demi langkah, tanpa ragu, sampai yang tersisa tidak lagi bisa disebut manusia. Hanya disebut sebagai... subjek.
Lambungmu bergejolak, asam naik sampai ke tenggorokan dan membakar. Tapi jemarimu terus membalik halaman, seolah tanganmu bergerak sendiri. Kau harus tahu. Kau harus tahu apa yang telah mereka lakukan di sini — dan apa yang mungkin sudah menunggumu di luar ruangan ini.
Setiap baris lebih buruk dari baris sebelumnya. Dan di suatu tempat di dalam kepalamu, sebuah suara kecil mulai bertanya dengan nada yang tidak ingin kau dengar: apakah mereka juga melakukan ini pada orang-orang sepertimu? Orang-orang yang terbangun tanpa ingatan apa pun?
-> rec_papers_2

=== rec_papers_photos ===
#KICKER:Part 1 : Awal Mula
#AUDIO:reception
#IMAGE:bg_reception
#SFX:paper_rustle
~ ADD_EMOTION("Takut", 1)
~ f_rec_photos = true
Di antara tumpukan kertas, ada amplop cokelat yang berat berisi foto-foto hitam putih. Yang gagal — dan yang, menurut tulisan tangan di bagian belakangnya, 'berhasil'. Tubuh-tubuh yang pernah menjadi manusia, dipajang seperti barang dagangan di atas baki-baki laboratorium, difoto dengan rapi seolah itu hal biasa.
Wajah-wajah itu masih menyerupai wajah. Itulah yang paling mengerikan. Kau memalingkan muka secepat mungkin, tapi sudah terlambat — gambar-gambar itu terbakar ke dalam kepalamu, tajam dan kejam, menolak pergi setiap kali kau berkedip.
Tanganmu gemetar begitu hebat hingga amplop itu hampir terlepas dari genggamanmu. Kau memaksakan diri menutupnya dan melemparkannya kembali ke tumpukan, tapi bau bahan kimia dari kertas foto itu masih menempel di hidungmu, menempel seperti kenangan.
-> rec_papers_2

=== rec_papers_take ===
#KICKER:Part 1 : Awal Mula
#TAG:[Canon]
#AUDIO:reception
#IMAGE:bg_reception
~ TIER_UP("Stress")
~ GRANT_ITEM("catatan_eksperimen")
~ SET_BODY("Sangat Mual")
~ TUT_POP("tier_tutorial")
Dengan tangan yang masih gemetar, kau menyambar beberapa lembar yang tampak paling utuh — yang tulisannya masih bisa terbaca, yang diagramnya belum robek. Kertasnya dingin dan licin oleh kelembapan di bawah jemarimu, dan kau melipatnya dengan hati-hati sebelum menyelipkannya jauh ke dalam saku.
Sekarang kau mengerti. Potongan-potongan yang kau lihat bergerak dalam gelap tadi, sosok-sosok yang mengintai di sudut ruangan — mereka semua adalah hasil dari eksperimen mengerikan ini. Mereka bukan monster yang lahir dari Kegelapan. Mereka dibuat. Dengan sengaja. Oleh tangan manusia.
Lambungmu bergejolak lagi, asam pahit membakar tenggorokanmu. Pikiranmu kacau, gambar-gambar itu terus bermunculan di balik kelopak matamu — tapi kau menyimpan catatan itu erat-erat. Di suatu tempat di dalam tulisan yang dingin itu mungkin tersembunyi kelemahan mereka. Dan kau tahu kau akan membutuhkannya.
-> s12_a

=== s12_a ===
#KICKER:Part 1 : Awal Mula
#AUDIO:hall
#IMAGE:bg_hall
Kau mengikuti secercah cahaya redup yang merembes dari ujung lorong, berharap itu adalah jalan keluar. Kegelapan di belakangmu terasa menekan punggungmu seperti beban yang hidup, dan gambar-gambar dari catatan itu masih menempel di pelupuk matamu setiap kali kau berkedip — wajah-wajah itu, tubuh-tubuh itu.
Cahaya itu ternyata berasal dari lampu darurat yang tergantung miring di langit-langit aula yang luas — kedipannya tidak beraturan, menyalakan dan memadamkan ruangan dalam denyut merah yang menyakitkan mata. Udara dipenuhi bau debu, karat, dan sesuatu yang jauh lebih busuk, sesuatu yang manis dan membusuk sekaligus.
Kau mengintip dari balik kusen pintu yang retak — dan matamu terbelalak. Aula itu dipenuhi oleh mereka. Makhluk-makhluk hasil eksperimen, bergerak, bernapas, hidup. Puluhan. Mungkin lebih. Dan semuanya berada di antara kau dan sisi lain ruangan.
-> s12_b

=== s12_b ===
#KICKER:Part 1 : Awal Mula
#AUDIO:hall
#IMAGE:bg_hall
Wujud mereka adalah penghinaan terhadap segala sesuatu yang seharusnya hidup. Tungkai-tungkai tambahan tumbuh dari punggung-punggung yang bungkuk, menyeret jejak basah yang mengilap di atas lantai beton. Beberapa tubuh membesar hingga pakaiannya — kalau itu masih bisa disebut pakaian — robek dan menggantung seperti kain kafan. Kulit sebagian di antara mereka begitu tipis hingga organ-organ di bawahnya berdenyut dengan jelas, merah dan basah dan hidup.
Sosok tinggi kurus berdiri di tengah aula, lengannya yang panjang menjuntai hingga ujung jarinya menyentuh lantai, jari-jari runcingnya menggores beton dengan bunyi berderit pelan setiap kali ia bergeser. Tidak jauh darinya, segumpalan daging merayap dengan kaki-kaki kecil yang tak terhitung jumlahnya, meninggalkan lendir asam yang mendesis pelan setiap kali menyentuh lantai.
Dari balik pilar yang runtuh, sesuatu mengawasimu — atau mengawasi ke arahmu. Ia memiliki mata yang terlalu banyak untuk satu kepala, berbaris dan berputar masing-masing dengan caranya sendiri. Satu di antaranya berhenti, tepat mengarah padamu. Jantungmu berhenti berdetak. Lalu mata itu berputar pergi, acuh, seolah kau tidak lebih penting dari debu yang menempel di lantai.
-> s12_c

=== s12_c ===
#KICKER:Part 1 : Awal Mula
#AUDIO:hall
#IMAGE:bg_hall
#SFX:whisper
DENTUMAN keras memecah udara dari sudut jauh aula — sesuatu yang besar jatuh dari langit-langit, menghantam lantai dengan gemerincing logam yang bergema panjang di antara dinding-dinding beton. Semua makhluk itu berhenti serentak, seperti satu tubuh. Puluhan kepala menoleh ke arah suara itu.
Beberapa di antara mereka mulai bergerak ke sana, langkah-langkah berat dan gesekan daging yang diseret memenuhi ruangan. Dan di saat yang bersamaan — dari lorong belakang, dari arah meja resepsionis — terdengar gemerusuk yang keras dan tergesa-gesa, seperti sesuatu yang menyeret tubuhnya sendiri dengan panik.
Lalu ia melesat melewatimu. Makhluk kecil gesit seukuran anjing, dengan kaki-kaki seperti serangga yang bergerak terlalu cepat untuk diikuti mata, melintas begitu dekat hingga hembusan anginnya menyentuh kulitmu. Jantungmu berhenti sesaat. Ia tidak berhenti. Ia tidak menoleh. Ia hanya... lewat, seolah kau bahkan tidak ada di sana.
-> s12_hub

=== s12_hub ===
#KICKER:Part 1 : Awal Mula
#AUDIO:hall
#IMAGE:bg_hall
#MAJOR
Kau berdiri di ambang pintu aula, sebagian tubuhmu masih tersembunyi di balik bayangan kusen yang retak. Di depanmu, kekacauan itu bergolak — makhluk-makhluk teralihkan, perhatian mereka tercerai-berai ke berbagai arah. Ini adalah kesempatan. Atau jebakan. Udara dingin menusuk paru-parumu, dan setiap detik yang kau habiskan untuk berpikir adalah satu detik lagi kau terlihat.
* [Lari panik kembali ke meja resepsionis] -> s12_panic
* [Bersembunyi di balik tumpukan peti tua] -> s12_hide_1
* [Menyelinap melewati aula selagi mereka teralihkan] -> s12_run_1

=== faint_killed ===
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
Dunia berputar. Lututmu lemas — kegelapan menelanmu dari tepi penglihatan.
Kau tidak pernah bangun.
Dalam gelap, sesuatu menemukan tubuhmu yang tak berdaya... dan berpesta.
// dipicu dinamis oleh FAINT_CHECK()/mekanik istirahat via
// story.ChoosePathString (bukan lewat divert graf)
~ DEATH()
-> END

=== rest_killed ===
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
Kau memaksakan tubuhmu beristirahat — untuk keempat kalinya, di tempat yang sama, dengan cara yang sama.
Sesuatu sudah hafal polamu. Ia bahkan tidak perlu mengendap-endap.
Kau tidak pernah bangun.
// dipicu dinamis oleh FAINT_CHECK()/mekanik istirahat via
// story.ChoosePathString (bukan lewat divert graf)
~ DEATH()
-> END

=== s12_panic ===
#KICKER:Part 1 : Awal Mula
#AUDIO:hall
#IMAGE:bg_hall
Rasa takut mengambil alih sepenuhnya. Ia tidak bertanya, tidak menunggu, tidak memberi pilihan — ia hanya menarik kakimu berbalik dan mendorong tubuhmu menjauh dari aula, dari makhluk-makhluk itu, dari segala hal yang tidak bisa kau pahami.
Kau mencoba keluar tanpa suara, langkahmu ditahan, napasmu dicekik di tenggorokan. Tapi lorong itu tidak kosong. Beberapa pasang mata menatapmu dari dalam kegelapan — mata-mata yang sepertinya sudah menunggumu sejak awal. Dan di antara mereka, sosok tinggi kurus itu bergerak. SANGAT cepat. Terlalu cepat untuk sesuatu setinggi itu.
Jari-jarinya yang runcing mencabik tubuhmu sebelum kau sempat berteriak, sebelum kau sempat berbuat apa-apa. Dunia menjadi merah, lalu gelap, lalu tidak ada sama sekali.
// respawn lama: s12_hub (bridge: pasang CHECKPOINT di hub terkait)
~ DEATH()
-> END

=== s12_hide_1 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:crates
#IMAGE:bg_crates
Kau melompat ke balik tumpukan peti kayu di sudut paling gelap ruangan. Kayunya kasar dan lembap di punggungmu saat tubuhmu menekan dinding yang dingin seperti es, meringkuk sekecil mungkin di antara bayangan-bayangan yang menumpuk.
Kau menahan napas. Bau busuk yang manis dan menusuk, bercampur dengan bau tajam bahan kimia, menyapu melewatimu saat salah satu dari mereka melintas — begitu dekat hingga kau bisa mendengar bunyi basah setiap langkahnya dan merasakan getarannya merambat melalui lantai ke tulang-tulangmu.
Waktu berjalan dengan lambat yang menyiksa, setiap detik meregang seperti karet. Lalu sesuatu yang cepat dan BESAR melintas tepat di depanmu — bayangan raksasa yang nyaris tak terlihat — dan menghilang masuk ke dalam lorong. Kau tidak berani bernapas sampai suaranya benar-benar hilang ditelan kegelapan.
-> s12_hide_2

=== s12_hide_2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:crates
#IMAGE:bg_crates
Kau meringkuk di balik peti, lutut ditarik rapat ke dada. Napasmu tertahan di tenggorokan — setiap tarikan terasa seperti pengkhianatan terhadap dirimu sendiri. Di luar sana, aula masih bergolak dengan suara-suara yang tidak ingin kau kenali, dan yang bisa kau lakukan hanyalah menunggu.
* [Tahan napas. Jangan bergerak sama sekali.] -> s12_hide_ok
* [Mengintip lewat celah peti] -> s12_peek
* [Bersiap lari jika ketahuan] -> s12_ready

=== s12_peek ===
#KICKER:Part 1 : Awal Mula
#AUDIO:crates
#IMAGE:bg_crates
#SFX:whisper
~ ADD_EMOTION("Takut", 1)
Dari celah sempit di antara peti-peti itu, dunia terpotong menjadi serpihan gelap — dan kemudian kakinya muncul. Bukan kaki manusia. Sesuatu yang terlalu panjang, dengan terlalu banyak sendi, melintas perlahan dari kiri ke kanan disertai bunyi seret yang membuat bulu kudukmu berdiri. Bersamaan dengan itu, bau busuk menusuk hidungmu — amis, lembap, seperti daging yang sudah lama membusuk di ruangan tanpa udara.
Lalu — satu pasang kaki berhenti. Tepat di depan celahmu. Sekarang kau bisa melihatnya: matanya, kuning redup, menatap lurus ke dalam celah sempit tempat kau meringkuk. Duniamu berhenti. Tidak ada suara. Tidak ada napas. Hanya tatapan itu, menusuk, seolah ia bisa melihat ketakutanmu berdenyut di tenggorokan.
Lalu ia pergi. Begitu saja — berbalik dengan acuh, seolah kau hanyalah bayangan yang tidak layak dikejar. Lututmu hampir lemas, dadamu meledak dengan napas yang baru berani kau ambil. Lega membanjirimu — dan bersamaan dengan itu, rasa takut yang justru lebih tajam. Karena tadi, ia hampir melihatmu.
-> s12_hide_2

=== s12_ready ===
#KICKER:Part 1 : Awal Mula
#AUDIO:crates
#IMAGE:bg_crates
Setiap otot di tubuhmu menegang seperti tali busur yang ditarik sampai batasnya. Matamu memetakan rute dengan cepat: dari peti ini ke pintu seberang, zig-zag di antara pilar-pilar tinggi itu, memanfaatkan setiap bayangan. Tidak ada ruang untuk ragu. Satu langkah salah, dan malam ini berakhir.
Kau mengatur napas — masuk perlahan lewat hidung, keluar lewat mulut yang hampir tak bersuara. Keringat dingin merambat di pelipismu, lengket dan menusuk dingin. Tubuhmu condong ke depan, siap melesat kapan pun. Tinggal menunggu momen yang tepat.
-> s12_ready_2

=== s12_ready_2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:crates
#IMAGE:bg_crates
Mereka masih sibuk sendiri — berpindah-pindah di antara peti, mengendus, tanpa menyadari kehadiranmu. Dan di seberang sana, pintu itu terlihat. Terbuka. Gelap. Menjanjikan sesuatu yang lebih baik daripada tempat ini. Detik ini adalah celahmu.
* [Tetap bersembunyi] -> s12_hide_ok
* [Lari sekarang!] -> s12_run_1

=== s12_hide_ok ===
#KICKER:Part 1 : Awal Mula
#TAG:[Canon]
#AUDIO:crates
#IMAGE:bg_crates
~ ADD_TEMP("Ketakutan", 3)
Kau tidak bergerak. Kau bahkan tidak bernapas. Tubuhmu merapat ke peti, menjadi satu dengan kegelapan — dingin, diam, tak berwujud. Hanya jantungmu yang berdebar, dan kau berdoa suaranya tidak keluar dari dadamu.
Satu per satu, mereka menjauh — terpancing oleh suara yang entah datang dari mana, langkah-langkah aneh itu menyeret pergi ke sudut aula yang lain. Perlahan, aula itu kembali 'tenang'. Tenang yang palsu, tenang yang bisa pecah kapan saja, tapi tenang.
Kau berhasil tak terdeteksi. Tapi ketakutan itu tidak ikut pergi. Ia menempel di kulitmu, di napasmu, di setiap bayangan yang bergerak — setidaknya untuk sementara, kau tidak akan bisa melupakannya.
-> s12_bridge

=== s12_run_1 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:hall
#IMAGE:bg_hall
Kau melesat! Napas dalam membakar paru-parumu, kakimu menghantam lantai dengan bunyi gedebuk yang terdengar terlalu keras di aula yang sunyi. Beberapa pasang mata menoleh ke arahmu — lalu berpaling, acuh. Mereka tidak peduli. Belum.
Setengah jalan. Pintu seberang semakin dekat — kau hampir bisa merasakan udara gelap di baliknya. Lalu, dari sudut matamu: gerakan cepat dari samping! Terlalu cepat untuk sesuatu sebesar itu.
Makhluk kecil gesit itu berbelok tak terduga — bukan menjauh, melainkan ke arahmu! Kaki-kakinya yang ramping melesat di atas lantai, matanya terkunci padamu. Ia datang.
-> s12_run_2

=== s12_run_2 ===
#KICKER:Part 1 : Awal Mula
#AUDIO:hall
#IMAGE:bg_hall
Ia datang cepat — terlalu cepat. Pintu tinggal beberapa langkah lagi, dan kau bisa mendengar cakar-cakar kecil itu mencakar lantai di belakangmu. Pilihanmu sekarang menentukan segalanya.
* [Zig-zag di antara mereka] -> s12_run_ok
* [Lari lurus secepat mungkin] -> s12_run_straight
* [Batalkan — kembali bersembunyi] -> s12_hide_1

=== s12_run_straight ===
#KICKER:Part 1 : Awal Mula
#AUDIO:hall
#IMAGE:bg_hall
~ ADD_EMOTION("Takut", 1)
Kau lari lurus, secepat kaki bisa membawa. Dunia menyempit menjadi satu garis tunggal — pintu, pintu, pintu. Tidak ada lagi pilar, tidak ada lagi bayangan, hanya tujuan dan deru napasmu sendiri.
Cakar menyambar dari samping — kau menghindar tipis, tubuhmu miring dalam sepersekian detik. Udara tersayat di dekat pipimu. Terlalu dekat. Terlalu dekat. Tapi kakimu tidak berhenti.
-> s12_run_ok

=== s12_run_ok ===
#KICKER:Part 1 : Awal Mula
#TAG:[Terluka]
#AUDIO:hall
#IMAGE:bg_hall
~ SET_STATUS("wounded")
~ SET_BODY("Kaki Kiri Terluka")
Kau mencapai pintu — tapi di detik terakhir, cakarnya menyerempet kakimu. Panas menyengat meledak di kaki kirimu. Kau jatuh tersungkur melewati ambang pintu, dan ketika kau menoleh, luka robek menganga di kaki kirimu, darah merembes gelap ke kain celanamu.
Rasa sakit menyelimuti seluruh kakimu, berdenyut mengikuti detak jantungmu. Kau berhasil lewat — tapi dengan harga. Setiap langkah kini mengingatkanmu pada makhluk kecil itu.
Untuk sementara, kau tidak bisa berlari cepat. Kaki kirimu tidak akan mengizinkannya — dan Kegelapan tidak menunggu orang yang pincang.
-> s12_bridge

=== s12_bridge ===
#KICKER:Part 1 : Awal Mula
#AUDIO:hall
#IMAGE:bg_hall
Aula parade mimpi buruk itu tertinggal di belakangmu, suaranya memudar menjadi dengung samar. Lorong di depan sunyi — terlalu sunyi, seolah tempat ini menahan napas bersamamu.
Kakimu melangkah — atau terpincang — maju di atas lantai yang dingin. Di dalam tasmu, catatan eksperimen itu terasa berat, seolah kertas-kertas itu menyimpan sesuatu yang tidak ingin kau ketahui.
Sesuatu menunggumu di depan. Kau bisa merasakannya di udara yang semakin dingin, di kegelapan yang semakin pekat. Cerita ini belum selesai.
-> tbc

=== tbc ===
#AUDIO:corridor
#IMAGE:bg_corridor
#MAJOR
Bersambung…
-> END

