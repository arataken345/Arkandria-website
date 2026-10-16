// The Asylum v2 — Part 1 (English)
// Dibangkitkan dari source/nodes.json oleh story/gen_ink.py — jangan edit manual,
// regenerasi via: python3 story/gen_ink.py
//
// Konvensi: knot per node lama; tag #KICKER/#TAG dibaca bridge.js dari currentTags;
// #AUDIO = ambient, #IMAGE = background, #SFX = one-shot SFX (lihat NODE_SFX).
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
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
// TODO-EN: story
Kamu terbangun di ujung lorong gelap yang bau dan lembap. Segalanya terasa kotor, penuh puing-puing dan pecahan kaca. Beberapa pintu rusak dan tergantung miring, membuat bayangan-bayangan aneh di bawah cahaya redup.
Di dinding ada coretan-coretan — seperti pesan atau peringatan, tetapi hampir semuanya susah untuk dibaca.
Lalu, kamu melihat tanganmu. Keduanya dibalut perban kotor. Tapi kamu nggak merasakan ada rasa sakit sama sekali.
Disaat kamu mencoba mengingat apa yang terjadi, kepalamu terasa kosong. Kamu nggak ingat apa-apa. Nggak tahu ini di mana, kenapa kamu di sini, atau harus ngapain.
// next="title" di game lama = layar judul (UI shell)
-> END

=== prolog2 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:doorhub
#IMAGE:bg_doorhub
// TODO-EN: story
Setelah berjalan ke depan dengan kebingungan sesaat, kini di depanmu terlihat empat pintu — masing-masing menampilkan kesannya tersendiri.
Pintu paling kiri tertutup rapat. Engselnya berkarat, tapi gagangnya terlihat agak bersih dari debu, seperti baru saja dipakai. Pintu kedua di kiri tampak terbuka lebar dan setengah rusak.
Kemudian, pintu pertama di sisi kanan berayun pelan, berderit kecil meski tak ada angin sedikit pun — seperti ada yang meniupnya. Pintu kedua lebih tenang dan normal, tapi dari celahnya kamu bisa lihat bayangan samar terletak di atas meja.
Lorong terus berlanjut, tapi suasananya makin tidak nyaman. Lampu-lampu berkedip tak menentu, dan entah dari mana, kamu sempat dengar suara gemerisik... lalu hening total.
-> opening

=== opening ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:doorhub
#IMAGE:bg_doorhub
// TODO-EN: story
Kau berdiri di tengah lorong. Empat pintu mengapitmu — dua di kiri, dua di kanan — dan di depan, lorong terus berlanjut ke dalam kegelapan yang semakin pekat.
Apa yang akan kau lakukan?
// TODO-EN: choice
* {not f_d1} [Mengecek pintu pertama di kiri]
    ~ f_d1 = true
    -> d1_hub
// TODO-EN: choice
* {not f_d2} [Mengecek pintu kedua di kiri]
    ~ f_d2 = true
    -> d2_hub
// TODO-EN: choice
* {not f_d3} [Mengecek pintu pertama di kanan]
    ~ f_d3 = true
    -> d3_hub
// TODO-EN: choice
* {not f_d4} [Mengecek pintu kedua di kanan]
    ~ f_d4 = true
    -> d4_hub
// TODO-EN: choice
+ [Terus maju meski ragu.] -> d5_1

=== d1_hub ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
// TODO-EN: story
Kau mendekati pintu paling kiri. Tertutup rapat. Engselnya berkarat — tapi gagang pintunya bersih. Terlalu bersih untuk tempat sekotor ini.
Seperti baru saja digenggam. Oleh seseorang. Atau sesuatu.
Kayunya dingin saat kau mendekat.
// TODO-EN: choice
+ [Tempelkan telinga ke pintu, dengarkan dulu] -> d1_a
// TODO-EN: choice
+ [Dorong perlahan, intip lewat celah] -> d1_b
// TODO-EN: choice
+ [Buka lebar-lebar sekaligus] -> d1_c

=== d1_a ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
// TODO-EN: story
Kau menempelkan telinga ke permukaan kayu yang dingin dan menahan napas.
Hening.
Kau mencoba mendengar sesuatu — apa pun — dari balik pintu. Tidak ada. Hanya dengung darah di telingamu sendiri dan... tunggu. Apakah itu detak?
Detak jantungmu sendiri, tentu saja. Pasti.
Tidak ada suara lain. Ruangan di baliknya sepertinya kosong.
-> d1_a2

=== d1_a2 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
// TODO-EN: story
Pintu itu diam. Keputusanmu?
// TODO-EN: choice
+ [Buka pintunya, masuk] -> d1_room
// TODO-EN: choice
+ [Urungkan — kembali ke lorong] -> opening

=== d1_b ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
// TODO-EN: story
Kau mendorong pintu itu satu sentimeter. Dua sentimeter. Celah tipis menganga, dan kau mengintip dengan satu mata.
Gelap. Bau lembap yang lebih pekat menyeruak keluar. Samar-samar kau bisa melihat bentuk-bentuk: meja terbalik, kaki kursi yang patah. Tidak ada gerakan.
Tapi di ujung penglihatanmu, ada sesuatu yang berkilau redup di lantai — seperti bungkus plastik.
-> d1_b2

=== d1_b2 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
// TODO-EN: story
Celah itu menunggu. Keputusanmu?
// TODO-EN: choice
+ [Masuk dan periksa] -> d1_room
// TODO-EN: choice
+ [Tutup perlahan, jangan ambil risiko] -> opening

=== d1_c ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
// TODO-EN: story
Kau menarik napas, lalu mendorong pintu itu lebar-lebar.
KRIIEEK.
Engsel berkarat itu menjerit — suaranya memantul di sepanjang lorong, terlalu keras, terlalu lama. Jantungmu berhenti sesaat. Kau berdiri mematung, menunggu. Apakah ada yang mendengar?
Satu detik. Dua detik. Tidak ada yang datang. Lorong kembali sunyi, seolah tidak terjadi apa-apa.
Ruangan di baliknya kosong dan gelap. Meja-meja terbalik. Hening.
-> d1_c2

=== d1_c2 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
~ ADD_EMOTION("Takut", 1)
// TODO-EN: story
Derit itu mungkin terdengar sampai ujung lorong. Keputusanmu?
// TODO-EN: choice
+ [Masuk cepat sebelum ada yang datang] -> d1_room
// TODO-EN: choice
+ [Tutup dan mundur — terlalu berisik] -> opening

=== d1_room ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
// TODO-EN: story
Kau melangkah masuk. Udara di sini lebih dingin, dan baunya... tua. Seperti ruangan yang sudah bertahun-tahun tidak disentuh siapa pun.
Meja-meja terbalik berserakan. Di sudut, ada noda gelap di lantai — besar, tidak beraturan, meresap ke dalam beton. Kau tidak mau terlalu memikirkan apa itu.
Di bawah salah satu meja yang masih berdiri, ada sesuatu: sebungkus plastik bening berisi roti kering. Dan di sampingnya, selembar surat terlipat yang sudah menguning.
// TODO-EN: choice
+ [Ambil bungkusan itu] -> d1_loot
// TODO-EN: choice
+ [Periksa noda gelap itu dulu] -> d1_stain

=== d1_stain ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
~ ADD_EMOTION("Takut", 1)
// TODO-EN: story
Kau berjongkok di dekat noda itu. Warnanya cokelat kehitaman, tepinya tidak rata — merembes, bukan tumpah. Bau besi samar masih tercium jika kau mendekat.
Darah. Sudah sangat lama. Kering sepenuhnya.
Kau tidak tahu apakah itu membuatmu lega atau justru lebih takut.
-> d1_stain2

=== d1_stain2 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:saferoom
#IMAGE:bg_saferoom
// TODO-EN: story
Noda itu tidak menjawab apa-apa. Bungkusan di bawah meja masih di sana.
// TODO-EN: choice
+ [Kembali dan ambil bungkusan itu] -> d1_loot
// TODO-EN: choice
+ [Tinggalkan semuanya, keluar dari sini] -> d1_empty

=== d1_loot ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:saferoom
#IMAGE:bg_saferoom
~ GRANT_ITEM("roti_kering")
~ GRANT_ITEM("surat_terlipat")
~ f_d1 = true
// TODO-EN: story
Kau meraih bungkusan plastik itu. Roti kering — tiga potong, masih dalam kemasan. Di sampingnya, surat terlipat itu terasa rapuh di jarimu.
Kau membukanya sekilas: tulisan tangan yang gemetar. 'Maafkan aku. Aku tidak bisa pulang. Jangan cari aku.' Tidak ada nama. Tidak ada tanggal.
Kau melipatnya kembali dan menyimpan keduanya. Setidaknya, perutmu tidak akan kosong untuk sementara waktu.
-> opening

=== d1_empty ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:saferoom
#IMAGE:bg_saferoom
~ f_d1 = true
// TODO-EN: story
Kau memutuskan bungkusan itu tidak sepadan dengan firasat burukmu. Kau keluar dan menutup pintu perlahan.
Lorong menyambutmu kembali — sama gelapnya, sama sunyinya.
-> opening

=== d2_hub ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
// TODO-EN: story
Pintu kedua di kiri terbuka lebar, setengah rusak — kayunya retak, tergantung miring di satu engsel.
Di baliknya: ruang sempit yang dipenuhi lemari-lemari tua berderet, seperti arsip atau gudang penyimpanan. Bau kapur barus dan kayu lapuk menyambutmu.
Semuanya diam. Terlalu diam?
// TODO-EN: choice
+ [Lempar kerikil ke dalam, dengarkan] -> d2_a
// TODO-EN: choice
+ [Masuk dan buka lemari satu per satu] -> d2_room
// TODO-EN: choice
+ [Firasat buruk — mundur] -> d2_c

=== d2_a ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
// TODO-EN: story
Kau memungut pecahan kaca dari lantai dan melemparkannya ke dalam ruangan. KLONTANG — memantul di lantai beton, menggelinding.
Sunyi. Lalu... dari dalam salah satu lemari, terdengar bunyi pelan: tuk.
Seperti sesuatu yang jatuh. Atau bergeser.
Kau menunggu. Tidak ada lagi.
-> d2_a2

=== d2_a2 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ ADD_EMOTION("Takut", 1)
// TODO-EN: story
Bunyi itu tidak terulang. Keputusanmu?
// TODO-EN: choice
+ [Masuk dan periksa] -> d2_room
// TODO-EN: choice
+ [Batalkan — kembali ke lorong] -> opening

=== d2_c ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
// TODO-EN: story
Kau mempercayai firasatmu dan melangkah mundur.
Tidak terjadi apa-apa. Dan justru itu yang mengganggumu — keheningan ruangan itu terasa... memperhatikan.
-> opening

=== d2_room ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
// TODO-EN: story
Ruangan sempit. Tiga lemari tua berderet di dinding, pintunya kusam. Bau kapur barus menusuk hidung.
Lemari pertama: pintunya sedikit terbuka. Lemari kedua: tertutup rapat. Lemari ketiga: terkunci — dan di permukaannya ada goresan-goresan panjang. Dari dalam.
// TODO-EN: choice
* {not f_d2c1} [Buka lemari pertama]
    ~ f_d2c1 = true
    -> d2_c1
// TODO-EN: choice
* {not f_d2c2} [Buka lemari kedua]
    ~ f_d2c2 = true
    -> d2_c2
// TODO-EN: choice
* {not f_d2c3} [Periksa lemari ketiga yang terkunci]
    ~ f_d2c3 = true
    -> d2_c3
// TODO-EN: choice
+ [Keluar dari ruangan ini] -> d2_done

=== d2_c1 ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ GRANT_ITEM("perban_kotor")
~ f_d2c1 = true
// TODO-EN: story
Kosong. Hanya debu tebal dan bau apek. Tapi di sudut bawahnya ada sesuatu yang terlipat: sepotong kain putih kusam — perban, masih digulung, meski kotor.
Kau mengambilnya. Lebih baik daripada tidak sama sekali. Mungkin.
-> d2_room

=== d2_c2 ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ ADD_EMOTION("Sedih", 1)
~ GRANT_ITEM("cokelat")
~ f_d2c2 = true
// TODO-EN: story
Kau membuka lemari kedua — dan sesuatu jatuh dari rak atas: sepatu kecil. Sepatu anak.
Kau menatapnya sesaat, lalu memaksakan diri melihat isi lemari: di rak bawah ada sebatang cokelat yang masih terbungkus rapat. Sedikit meleleh, tapi utuh.
Kau mengambil cokelat itu. Sepatu itu kau biarkan. Kau tidak sanggup menyentuhnya.
-> d2_room

=== d2_c3 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
// TODO-EN: story
Kau mendekati lemari ketiga. Terkunci. Goresan-goresan panjang menghiasi pintunya — dalam, berulang, seperti dibuat dengan kuku. Dari dalam.
Kau menempelkan tangan ke kayunya. Dingin.
-> d2_c3x

=== d2_c3x ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:darkstare
#IMAGE:bg_darkstare
// TODO-EN: story
Lemari itu diam. Terlalu diam.
// TODO-EN: choice
+ [Tempelkan telinga, dengarkan] -> d2_c3b
// TODO-EN: choice
+ [Jangan sentuh — jauhi] -> d2_c3c

=== d2_c3b ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ TIER_UP("Stress")
~ ADD_EMOTION("Takut", 2)
~ f_d2c3 = true
// TODO-EN: story
Sunyi... lalu: napas. Pelan, berat, tepat di balik kayu tipis itu.
Kau melompat mundur, jantung menghantam rusuk. Napas itu berhenti. Tidak ada lagi.
Apapun itu — ia masih di sana. Atau baru saja pergi. Kau tidak mau tahu.
-> d2_room

=== d2_c3c ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ ADD_EMOTION("Lega", 1)
~ f_d2c3 = true
// TODO-EN: story
Kau mundur perlahan, tidak melepaskan pandangan dari lemari itu.
Tidak terjadi apa-apa. Untuk kali ini, kehati-hatianmu terbayar.
-> d2_room

=== d2_done ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:darkstare
#IMAGE:bg_darkstare
~ f_d2 = true
// TODO-EN: story
Kau keluar dari ruang lemari dan kembali ke lorong.
Di belakangmu, ruangan itu kembali sunyi — tapi kau tidak bisa menghilangkan perasaan bahwa keheningan itu menunggu.
-> opening

=== d3_hub ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
// TODO-EN: story
Pintu pertama di kanan berayun pelan. Berderit kecil. Tidak ada angin — tapi ia bergerak, seperti dihembus sesuatu yang tidak terlihat.
Dari celahnya, kau mendengar sesuatu: detak. Pelan, berirama. Seperti... detak jantung? Atau jam?
Udara yang keluar dari celah itu dingin. Tidak wajar dinginnya.
// TODO-EN: choice
+ [Ikuti suara detak itu — masuk] -> d3_a
// TODO-EN: choice
+ [Diam di ambang pintu, amati dulu] -> d3_b
// TODO-EN: choice
+ [Mundur perlahan, tutup pintu] -> d3_c

=== d3_a ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
// TODO-EN: story
Kau melangkah masuk. Dingin langsung merayap naik dari kakimu, seperti air es.
Detak itu semakin jelas — tapi kau sadar, itu bukan jam. Terlalu tidak beraturan. Terlalu... hidup.
Lalu kau melihatnya. Di sudut ruangan, udara beriak seperti air — dan sepasang mata merah menyala membuka di dalam kegelapan yang tak berwujud.
Ia melihatmu.
-> d3_a2

=== d3_a2 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ ADD_EMOTION("Takut", 2)
// TODO-EN: story
Mata merah itu menyipit. Ia mulai bergerak ke arahmu.
// TODO-EN: choice
+ [Beku — jangan bergerak sama sekali] -> d3_a2a
// TODO-EN: choice
+ [Putar balik dan LARI] -> d3_a2b

=== d3_a2a ===
#TAG:[In danger]
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ SET_STATUS("danger")
~ TIER_UP("Stress")
~ f_d3 = true
// TODO-EN: story
Kau memaksa tubuhmu diam. Jangan bernapas. Jangan berkedip.
Sosok transparan itu melayang mendekat. Dingin menusuk tulangmu saat ia mengitarimu — kau bisa merasakan kebencian memancar darinya, seperti radiasi.
Lalu... ia berhenti. Mata merah itu menyipit. Perlahan, ia mundur, melebur kembali ke dalam kegelapan ruangan.
Kau tidak tahu kenapa ia melepaskanmu. Kau tidak mau tahu. Kakimu gemetar saat kau melangkah mundur keluar.
-> opening

=== d3_a2b ===
#TAG:[Wounded]
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ SET_STATUS("wounded")
~ TIER_UP("Stress")
~ SET_BODY("Lengan Kiri Tergores")
~ f_d3 = true
// TODO-EN: story
Kau berbalik dan lari — tapi ia lebih cepat.
Dingin membakar lengan kirimu saat sesuatu yang tak terlihat mencakar lewat. Kau terhuyung, tapi terus berlari, menerobos pintu dan membantingnya di belakangmu.
Napasmu memburu. Lengan kirimu perih — tiga garis merah menganga di kulitmu, dan dinginnya masih terasa menusuk sampai ke tulang.
Kau terluka. Dan kau sadar satu hal: ia tidak mengejarmu keluar. Ia hanya... menjaga ruangan itu.
-> opening

=== d3_b ===
#TAG:[In danger]
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ SET_STATUS("danger")
~ ADD_EMOTION("Takut", 1)
~ f_d3 = true
// TODO-EN: story
Kau tetap di ambang pintu, tidak masuk. Hanya mengamati.
Detak itu berlanjut. Lalu, perlahan, sepasang mata merah menyala muncul dari kegelapan — dan menatap lurus ke arahmu.
Kau tidak bergerak. Ia tidak bergerak. Waktu berhenti.
Kemudian mata itu berkedip — sekali — dan menghilang. Detak itu pun berhenti.
Pesannya jelas: ia tahu kau di sini. Dan ia membiarkanmu pergi. Untuk sekarang.
-> opening

=== d3_c ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:teddyroom
#IMAGE:bg_teddyroom
~ TIER_UP("Stress")
~ ADD_EMOTION("Takut", 1)
~ f_d3 = true
// TODO-EN: story
Kau mundur selangkah. Dua langkah. Tanganmu meraih gagang pintu.
Tepat saat pintu hampir tertutup, detak itu... berhenti.
Hening total. Lalu, dari balik pintu yang nyaris rapat, terdengar bunyi gesekan pelan — seperti kuku di kayu. Sekali. Dua kali.
Kau menutup pintu sepenuhnya dan mundur. Jantungmu masih berdebar lama setelahnya.
-> opening

=== d4_hub ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
// TODO-EN: story
Pintu kedua di kanan lebih tenang. Dari celahnya, kau bisa melihat sebuah meja — dan di atasnya, bayangan samar.
Kau mendorong pintu itu. Ruangan kecil. Meja kayu di tengah. Dan di atasnya...
Sebuah boneka beruang. Usang, satu matanya lepas, tapi bersih — terlalu bersih untuk tempat ini. Seolah seseorang merawatnya.
// TODO-EN: choice
+ [Ambil bonekanya langsung] -> d4_a
// TODO-EN: choice
+ [Periksa meja dan sekitarnya dulu] -> d4_b
// TODO-EN: choice
+ [Jangan sentuh apa pun — pergi] -> d4_c

=== d4_a ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:corridor
#IMAGE:bg_corridor
~ ADD_EMOTION("Lega", 1)
~ ADD_EMOTION("Takut", 1)
~ GRANT_ITEM("boneka")
~ f_d4 = true
// TODO-EN: story
Kau mengangkat boneka itu. Ringan. Dan... hangat.
Kehangatan yang aneh menjalar ke tanganmu — seperti baru saja dipeluk seseorang. Kau merinding.
Lalu kau menyadarinya: mata boneka yang masih ada itu... menatapmu. Tadi, saat di atas meja, ia menghadap ke arah lain. Bukankah begitu?
Kau memeluknya erat-erat. Entah kenapa, benda ini terasa penting.
-> opening

=== d4_b ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
// TODO-EN: story
Kau menahan diri dan memeriksa ruangan dulu. Meja itu kosong selain boneka. Tapi di bawah meja, terselip sesuatu: selembar kertas gambar anak-anak, digambar dengan crayon.
Gambarnya: sebuah keluarga — ayah, ibu, anak — bergandengan tangan. Dan di belakang mereka, sosok tinggi hitam dengan mata merah.
Crayon merahnya ditekan begitu keras sampai kertasnya sobek tepat di bagian mata itu.
-> d4_b2

=== d4_b2 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:corridor
#IMAGE:bg_corridor
// TODO-EN: story
Gambar itu terasa dingin di jarimu. Boneka itu masih di atas meja.
// TODO-EN: choice
+ [Ambil bonekanya juga] -> d4_a
// TODO-EN: choice
+ [Ambil gambarnya saja, tinggalkan boneka] -> d4_draw
// TODO-EN: choice
+ [Tinggalkan semuanya] -> d4_c

=== d4_draw ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:corridor
#IMAGE:bg_corridor
~ ADD_EMOTION("Takut", 1)
~ GRANT_ITEM("gambar_crayon")
~ f_d4 = true
// TODO-EN: story
Kau mengambil gambar itu dan melipatnya hati-hati. Bonekanya kau biarkan di atas meja.
Saat kau berbalik, dari sudut matamu — kau bersumpah kepala boneka itu sedikit miring. Mengikutimu.
Kau tidak menoleh lagi.
-> opening

=== d4_c ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:corridor
#IMAGE:bg_corridor
~ TIER_UP("Stress")
~ ADD_EMOTION("Takut", 2)
~ f_d4 = true
// TODO-EN: story
Kau memutuskan untuk tidak menyentuh apa pun. Nalurimu berteriak.
Kau melangkah mundur menuju pintu. Dan saat itulah kau mendengarnya — pelan, hampir tidak ada:
'...jangan pergi.'
Suaranya seperti anak kecil. Berasal dari... boneka itu? Atau dari kepalamu sendiri?
Kau keluar dan menutup pintu. Tanganmu gemetar.
-> opening

=== d5_1 ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:doorhub
#IMAGE:bg_doorhub
// TODO-EN: story
Kau mengabaikan pintu-pintu itu dan terus melangkah ke ujung lorong.
Lampu-lampu di sini berkedip makin cepat. Langkah kakimu bergema... dan kau menyadarinya: gemanya salah. Ada setengah ketukan tambahan di antara langkahmu — seperti ada yang berjalan bersamamu, sedikit tidak selaras.
Kau berhenti. Gema itu berhenti... setengah detik lebih lambat.
Di depan, deretan lampu di langit-langit berkedip liar — kecuali satu. Satu lampu menyala stabil, terang, mengundang.
Di bawah lampu yang stabil itu, kau melihat sesuatu yang janggal: lantainya bersih. Tidak ada debu, tidak ada puing — padahal seluruh lorong ini kotor. Seperti tempat itu... dirawat. Atau sering ditunggu.
Dan kau teringat: tadi, saat bayangan besar melintas di kejauhan, setiap lampu yang dilewatinya berkedip liar.
-> d5_1c

=== d5_1c ===
// TODO-EN: kicker
#KICKER:Part 1 : Awal Mula
#AUDIO:doorhub
#IMAGE:bg_doorhub
~ ADD_EMOTION("Takut", 1)
// TODO-EN: story
Gema langkah itu masih ada — setengah ketukan di belakangmu. Lampu yang stabil itu menunggu.
Apa yang akan kau lakukan?
// REQ: energy>=15 (bridge.js mengunci bila tak terpenuhi)
// TODO-EN: choice
+ [Berlari ke lampu yang stabil — terang berarti aman (needs 15 energy)] -> d5_trap
// TODO-EN: choice
+ [Bergerak di antara kedipan, tetap dalam bayangan — Requires focus (mental ≤ Uneasy)] -> d5_smart
// TODO-EN: choice
+ [Berbalik kembali ke persimpangan pintu] -> d5_back

=== d5_trap ===
#AUDIO:doorhub
#IMAGE:bg_doorhub
// TODO-EN: story
Kau berlari menuju cahaya. Terang berarti aman — itu naluri, itu logika.
Cahaya itu menyilaukan. Kau tidak melihat kegelapan di sekitarnya — dan di situlah ia berdiri.
Sosok besar tanpa kepala. Bertangan banyak. Kapak besar terangkat.
Lampu yang stabil itu bukan tempat aman. Itu tempatnya menunggu. Lampu-lampu lain berkedip karena ia lewat — yang satu ini stabil karena ia tidak pernah pergi.
Kau tak sempat menyesal.
// respawn lama: hub_exit (bridge: pasang CHECKPOINT di hub terkait)
~ DEATH()
-> END

=== d5_smart ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:doorhub
#IMAGE:bg_doorhub
~ TIER_UP("Kelelahan")
~ ADD_EMOTION("Takut", 1)
// TODO-EN: story
Kau memaksa kakimu diam. Bernapas pelan. Mengamati.
Pola kedip lampu-lampu itu... tidak acak. Setiap beberapa detik, satu lampu berkedip liar — berpindah, mendekat. Sesuatu bergerak di lorong itu, dari lampu ke lampu.
Kau bergerak hanya saat lampu di depanmu padam dalam kedipnya — berlari pendek dalam gelap, berhenti dalam bayangan. Jantungmu menghantam rusuk, tapi kau tidak berhenti.
Saat kau melewati lampu yang stabil itu, kau tidak menoleh. Kau sudah tahu apa yang menunggu di sana.
Lorong terbuka ke sebuah pertigaan. Kau berhasil.
-> hub_exit

=== d5_back ===
// TODO-EN: tag
#TAG:[Aman]
#AUDIO:doorhub
#IMAGE:bg_doorhub
~ ADD_EMOTION("Takut", 1)
// TODO-EN: story
Kau berbalik — perlahan, tanpa membelakangi kegelapan terlalu lama.
Gema setengah ketukan itu mengikutimu beberapa langkah, lalu... hilang. Seperti tidak pernah ada.
Kau kembali ke persimpangan pintu dengan napas memburu. Setidaknya kau masih hidup.
-> opening

=== hub_exit ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
Your steps slow, near-silent on the cold floor, until you reach a three-way junction of corridors. At its center, like the carcass of some ancient beast, stands an old reception desk on the verge of collapse — its surface cracked, its edges flaking, and across it lie stacks of paper long since claimed by dust. Behind the desk, two more corridors stretch out: the left one drowned in total darkness, so silent you can hear your own blood pulsing in your ears; the right one, at its far end, giving off a trembling sliver of dim light, as if inviting you closer — or luring you in.
You draw a breath, and the air here feels wrong — heavy, stale, as though this place holds too many things that were never meant to be remembered. And those voices… the faint whispers that have been following you all this while now sound closer, crawling along the walls like something alive, refusing to leave, refusing to let you be alone with your own thoughts.
-> reception_hub

=== reception_hub ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
You stand at the heart of the junction, wrapped in a silence that presses heavily against your skin. The ruined reception desk rots quietly at the room's center, its stacks of dusty papers seeming to guard secrets that dare not be opened. The left corridor gapes dark and soundless, swallowing every noise; the right one promises a dim light you cannot fully trust. And between it all, those strange voices still drift — faint, patient, haunting you.
* {not f_rec_desk} [Search around the reception desk]
    ~ f_rec_desk = true
    -> rec_desk_1
* {not f_rec_left} [Enter the dark, silent left corridor]
    ~ f_rec_left = true
    -> rec_left_1
+ [Examine the stack of papers on the desk] -> rec_papers_1

=== rec_desk_1 ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
You crouch beside the desk, and your knees sink at once into a layer of dust nearly thick as cloth. A pungent musty smell rises into your nose — the stink of rotting paper, decaying wood, and something older, sweeter, that you would rather not name. The space beneath the desk before you is dark as a gaping mouth, refusing to throw back any light at all.
Your fingers grope among unidentifiable fragments — sharp on one side, soft and slimy on the other — until your fingertips find something different: small, round, and cold as ice, lying still on the dusty floor.
-> rec_desk_2

=== rec_desk_2 ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
You stay crouched, breath held, and in the darkness beneath the desk two things draw your attention: the cold dusty floor beneath your palm, and the mound of rubble around the desk's legs — each seeming to hold something waiting to be found.
+ [Feel along the dusty floor beneath the desk] -> rec_desk_floor
+ [Sift through the rubble around the desk legs] -> rec_desk_rubble

=== rec_desk_floor ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
You grope through the darkness beneath the desk, your fingers sweeping the cold, gritty floor. Then — the touch of metal. Small, round, piercingly cold, with a rough surface that scrapes your skin. Your heart beats a little faster, for no clear reason.
You draw it out into the light: an old metal coin, its surface so tarnished it is nearly black, its edges worn away by time. No recognizable engraving, no shine, no meaning. Nothing special — but real, heavy in your palm, an object once touched by other hands in this long-dead place.
-> rec_desk_floor_2

=== rec_desk_floor_2 ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
The coin lies in your grimy palm, its cold slowly seeping into your skin, as if demanding a decision.
+ [Take the coin] -> rec_coin
+ [Leave it where it is] -> rec_desk_back

=== rec_desk_rubble ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
You shift the rubble piece by piece: tile shards sharp as teeth, a dented yellowing paper cup, a plastic pen long dry of ink. Ordinary trash from a life that has already stopped.
Then your eyes catch a torn scrap of paper, trapped beneath a tile shard. On it, in fading ink, half a sentence is written: '...don't trust...' — and the rest is gone, torn away with the missing half of the page. Your fingers tremble slightly as you hold it.
You rummage through the remaining rubble, but there is nothing more. Only dust that swirls and clings to your throat, and the musty smell growing thicker, as though this place is disappointed you found nothing.
-> rec_desk_rubble_2

=== rec_desk_rubble_2 ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
The rubble holds nothing more — only silence, dust, and the smell of decay clinging to your clothes.
+ [Stand back up] -> rec_desk_back

=== rec_coin ===
#KICKER:Part 1: The Beginning
#TAG:[Safe]
#AUDIO:reception
#IMAGE:bg_reception
~ GRANT_ITEM("koin_logam")
~ f_rec_coin = true
~ f_rec_desk = true
You pick up the coin. Tarnished, light, utterly ordinary — its cold stings your palm for a moment before slowly warming against your body heat. No secret engraving, no hidden clue, no whisper from the past.
Just an old coin. A dead thing from a dead place. You slip it into your pocket — not because it is valuable, but because in a place like this, holding something real feels better than holding nothing.
-> reception_hub

=== rec_desk_back ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
~ f_rec_desk = true
You stand, brushing the dust from your knees until a small gray cloud drifts into the air. The desk area holds nothing more — only the carcass of old wood and stacks of paper that will keep rotting in silence.
Behind you, the junction waits for your return: the pitch-dark left corridor, the right corridor with its dim light, and the strange voices that never truly go away.
-> reception_hub

=== rec_left_1 ===
#KICKER:Part 1: The Beginning
#AUDIO:leftcorridor
#IMAGE:bg_leftcorridor
You step into the left corridor, and at once the world behind you seems to collapse. The air here is different — colder, damper, heavier, as if the very lungs of this place were slowly rotting. Every footstep of yours echoes softly across the concrete floor, a sound that has no business being heard alone in a place this abandoned.
The Darkness in this corridor is thicker, hungrier. It swallows the light from the junction behind you step by step, until all that remains is a veil of black closing in around you. This corridor is short — you can feel it in the way the walls close in far ahead — but every meter feels like being dragged backward into a jaw that is slowly shutting.
-> rec_left_2

=== rec_left_2 ===
#KICKER:Part 1: The Beginning
#AUDIO:leftcorridor
#IMAGE:bg_leftcorridor
At the end of the corridor — no side doors, no gaps anywhere — stands a thick steel door. Its metal reflects the dying light coldly, dully, without welcome. This corridor is a dead end. Your feet have carried you as far as they can go, and the only thing waiting for you here is the silence of that steel.
+ [Step slowly toward the steel door] -> rec_left_door
+ [Return to the junction] -> rec_left_back

=== rec_left_door ===
#KICKER:Part 1: The Beginning
#AUDIO:steeldoor
#IMAGE:bg_steeldoor
#SFX:door_creak
You stare at the steel door up close, and your breath catches. It is locked tight — no handle, no keyhole, not even a gap wide enough to slip a fingertip through. Its surface feels cold and slick beneath your touch, like the skin of an animal long dead.
Then you see them. Deep scratches carve across the steel, repeated and parallel — claw marks. You swallow hard; no human's claws could cut through metal this thick. Something far stronger than any human once tried to break through... from the other side.
-> rec_left_door_2

=== rec_left_door_2 ===
#KICKER:Part 1: The Beginning
#AUDIO:steeldoor
#IMAGE:bg_steeldoor
#SFX:door_creak
The door is silent — a silence that feels wrong, a silence that feels like it is holding its breath. From the thin gap beneath it seeps the smell of rusted iron, and beneath that... something rotten, faint, like meat left to rot in an airless room. The smell turns your stomach.
+ [Shove the steel door] -> rec_left_push
+ [Examine the scratches on the surface] -> rec_left_scratch
+ [Return to the junction] -> rec_left_back

=== rec_left_push ===
#KICKER:Part 1: The Beginning
#TAG:[Safe]
#AUDIO:steeldoor
#IMAGE:bg_steeldoor
#SFX:metal_clang
~ ADD_EMOTION("Takut", 1)
~ f_rec_left = true
You hold your breath and push with all your strength — your shoulder slams into the cold metal, your muscles straining until they shake. The door does not move a single inch, as if it has been welded shut by this world itself.
Then — a low, deep thud that echoes in your chest like a second heartbeat. Silence. And from the other side of that door... something shifts. Slowly. Heavily. Away, or closer — you cannot tell. Your legs decide before your head does: you back away, hands trembling, breath caught in your throat.
-> reception_hub

=== rec_left_scratch ===
#KICKER:Part 1: The Beginning
#AUDIO:steeldoor
#IMAGE:bg_steeldoor
Your fingertips trace the scratches, and you feel the torn metal — deep, jagged, merciless. The marks repeat in parallel patterns, rhythmic, like claws striking again and again. Too wide for a human hand. Too deep for anything that isn't an animal... or something worse than an animal.
And then your blood turns to ice. The angles of the tears — you see them now — point inward, toward you. These scratches were not made from the outside. These scratches came from the INSIDE of the door. Something behind that steel once tried to get... OUT.
-> rec_left_door_2

=== rec_left_back ===
#KICKER:Part 1: The Beginning
#AUDIO:leftcorridor
#IMAGE:bg_leftcorridor
~ f_rec_left = true
You step backward slowly, feet dragging, never letting the steel door out of your sight. Every step back feels like pulling yourself out of the mouth of something asleep.
At the junction, the light greets you faintly — and only there do you realize your breath is coming fast, cold sweat beading on your neck. You have returned. But behind you, the left corridor still gapes open, and you do not dare turn your back on it for long.
-> reception_hub

=== rec_papers_1 ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
#SFX:paper_rustle
You approach the reception desk. On top of it: a stack of dusty papers, some bound with string gone frayed and brittle, their edges yellowed by time. Dust rises into the air as you move, dancing in the faint light like ash from something burned long ago.
The topmost sheet greets you with large, hurried handwriting: 'Experiment: Subject X'. The letters slant, pressed hard enough to tear the paper. Your heart pounds so loudly you are certain these empty corridors can hear it.
-> rec_papers_2

=== rec_papers_2 ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
The papers wait — silent, patient, as if they have been waiting for someone for years. Their edges tremble in the cold air... or is that your hand shaking. You can no longer tell the difference.
* {not f_rec_read} [Read the topmost sheet]
    ~ f_rec_read = true
    -> rec_papers_read
* {not f_rec_photos} [Look at the attached photos]
    ~ f_rec_photos = true
    -> rec_papers_photos
+ [Take a few intact sheets] -> rec_papers_take

=== rec_papers_read ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
#SFX:paper_rustle
~ ADD_EMOTION("Takut", 1)
~ f_rec_read = true
The notes are written with a sickening calm. Each page lays out the procedure in cold, painstaking detail — how a human being is cut open, taken apart, and reassembled with parts that should never belong to any living body. Step by step, without hesitation, until what remains can no longer be called human. Only a 'subject.'
Your stomach churns, acid rising to your throat and burning. But your fingers keep turning the pages, as if your hands are moving on their own. You have to know. You have to know what they did here — and what might already be waiting for you beyond this room.
Every line is worse than the one before. And somewhere inside your head, a small voice begins to ask in a tone you do not want to hear: did they do this to people like you? People who wake up remembering nothing?
-> rec_papers_2

=== rec_papers_photos ===
#KICKER:Part 1: The Beginning
#AUDIO:reception
#IMAGE:bg_reception
#SFX:paper_rustle
~ ADD_EMOTION("Takut", 1)
~ f_rec_photos = true
Among the stack of papers lies a heavy brown envelope of black-and-white photographs. The failures — and, according to the handwriting on the back, the 'successes.' Bodies that were once human, displayed like merchandise on laboratory trays, photographed neatly as if it were ordinary.
The faces still resemble faces. That is the most horrifying part. You look away as fast as you can, but it is already too late — the images are burned into your head, sharp and merciless, refusing to leave every time you blink.
Your hands shake so violently the envelope nearly slips from your grasp. You force yourself to close it and toss it back onto the pile, but the chemical smell of the photo paper still clings to your nose, clinging like a memory.
-> rec_papers_2

=== rec_papers_take ===
#KICKER:Part 1: The Beginning
#TAG:[Canon]
#AUDIO:reception
#IMAGE:bg_reception
~ TIER_UP("Stress")
~ GRANT_ITEM("catatan_eksperimen")
~ SET_BODY("Sangat Mual")
~ TUT_POP("tier_tutorial")
With hands that still will not stop shaking, you snatch up the most intact pages — the ones whose writing is still legible, whose diagrams are not yet torn. The paper is cold and damp under your fingers, and you fold it carefully before tucking it deep into your pocket.
Now you understand. The shapes you saw moving in the dark earlier, the figures lurking in the corners of the room — they are all products of this horrible experiment. They were not born of the Darkness. They were made. Deliberately. By human hands.
Your stomach churns again, bitter acid burning your throat. Your mind is a mess, the images surfacing again and again behind your eyelids — but you clutch the notes tightly. Somewhere inside that cold writing may hide their weakness. And you know you will need it.
-> s12_a

=== s12_a ===
#KICKER:Part 1: The Beginning
#AUDIO:hall
#IMAGE:bg_hall
You follow the faint sliver of light seeping from the far end of the corridor, hoping it leads out. The Darkness behind you presses against your back like a living weight, and the images from the notes still cling to your eyelids every time you blink — those faces, those bodies.
The light comes from an emergency lamp hanging crooked from the ceiling of a vast hall — flickering erratically, switching the room on and off in a sick red pulse that hurts the eyes. The air reeks of dust, rust, and something far more rotten, something sweet and decaying at once.
You peer through the cracked doorframe — and your eyes widen. The hall is filled with them. The experiment creatures, moving, breathing, alive. Dozens. Perhaps more. And all of them stand between you and the far side of the room.
-> s12_b

=== s12_b ===
#KICKER:Part 1: The Beginning
#AUDIO:hall
#IMAGE:bg_hall
Their forms are an insult to everything that should live. Extra limbs sprout from hunched backs, dragging wet, glistening trails across the concrete floor. Some bodies have swollen until their clothes — if they can still be called clothes — hang torn like burial shrouds. Some skins are so thin that the organs beneath pulse visibly, red and wet and alive.
The tall gaunt one stands at the center of the hall, its long arms dangling until its fingertips touch the floor, its pointed fingers scraping the concrete with a soft screech whenever it shifts. Not far from it, a mound of flesh crawls on countless tiny legs, leaving a trail of acidic slime that hisses faintly each time it touches the floor.
From behind a collapsed pillar, something watches you — or watches in your direction. It has too many eyes for one head, arranged in rows, each rolling in its own way. One of them stops, pointed straight at you. Your heart stops beating. Then the eye rolls away, indifferent, as if you were no more important than the dust clinging to the floor.
-> s12_c

=== s12_c ===
#KICKER:Part 1: The Beginning
#AUDIO:hall
#IMAGE:bg_hall
#SFX:whisper
A heavy CRASH splits the air from the far corner of the hall — something large has fallen from the ceiling, striking the floor with a long clatter of metal echoing between the concrete walls. Every creature stops at once, like a single body. Dozens of heads turn toward the sound.
Several of them begin moving toward it, heavy footsteps and the scrape of dragged flesh filling the room. And at the same moment — from the corridor behind you, from the direction of the reception desk — comes a loud, hurried rustling, like something dragging its own body in a panic.
Then it shoots past you. The swift little creature, dog-sized, with insect legs moving too fast for the eye to follow, passes so close that the rush of its wind brushes your skin. Your heart stops for a beat. It does not stop. It does not turn. It only... passes, as if you were not even there.
-> s12_hub

=== s12_hub ===
#KICKER:Part 1: The Beginning
#AUDIO:hall
#IMAGE:bg_hall
You stand on the threshold of the hall, half your body still hidden in the shadow of the cracked doorframe. Before you, the chaos churns — the creatures distracted, their attention scattered in every direction. This is an opportunity. Or a trap. Cold air stings your lungs, and every second you spend thinking is one more second of being seen.
+ [Flee back to the reception desk in a panic] -> s12_panic
+ [Hide behind the pile of old crates] -> s12_hide_1
+ [Slip through the hall while they are distracted] -> s12_run_1

=== faint_killed ===
#KICKER:Part 1: The Beginning
#AUDIO:corridor
#IMAGE:bg_corridor
The world spins. Your knees buckle — darkness swallows you from the edges of sight.
You never wake up.
In the dark, something finds your helpless body... and feasts.
// dipicu dinamis oleh FAINT_CHECK()/mekanik istirahat via
// story.ChoosePathString (bukan lewat divert graf)
~ DEATH()
-> END

=== rest_killed ===
#KICKER:Part 1: The Beginning
#AUDIO:corridor
#IMAGE:bg_corridor
You force your body to rest — for the fourth time, in the same place, in the same way.
Something has memorized your pattern. It does not even need to sneak.
You never wake up.
// dipicu dinamis oleh FAINT_CHECK()/mekanik istirahat via
// story.ChoosePathString (bukan lewat divert graf)
~ DEATH()
-> END

=== s12_panic ===
#KICKER:Part 1: The Beginning
#AUDIO:hall
#IMAGE:bg_hall
Fear takes over completely. It does not ask, it does not wait, it offers no choice — it simply turns your legs around and pushes your body away from the hall, from the creatures, from everything you cannot understand.
You try to slip out without a sound, your steps held back, your breath strangled in your throat. But the corridor is not empty. Several pairs of eyes stare at you from within the darkness — eyes that seem to have been waiting for you all along. And among them, the tall gaunt one moves. SO fast. Too fast for something that tall.
Its pointed fingers tear through your body before you can scream, before you can do anything at all. The world turns red, then dark, then nothing at all.
// respawn lama: s12_hub (bridge: pasang CHECKPOINT di hub terkait)
~ DEATH()
-> END

=== s12_hide_1 ===
#KICKER:Part 1: The Beginning
#AUDIO:crates
#IMAGE:bg_crates
You leap behind the stack of wooden crates in the darkest corner of the room. The wood is rough and damp against your back as your body presses into the ice-cold wall, curling as small as possible among the piled shadows.
You hold your breath. A sweet, piercing rot, mingled with the sharp sting of chemicals, washes over you as one of them passes — so close you can hear the wet sound of every step and feel its vibration traveling through the floor into your bones.
Time crawls with agonizing slowness, every second stretching like rubber. Then something fast and HUGE sweeps past right in front of you — a giant shadow barely seen — and vanishes into the corridor. You do not dare breathe until its sound is truly swallowed by the darkness.
-> s12_hide_2

=== s12_hide_2 ===
#KICKER:Part 1: The Beginning
#AUDIO:crates
#IMAGE:bg_crates
You crouch behind the crates, knees drawn tight to your chest. Your breath is caught in your throat — every inhale feels like a betrayal of yourself. Out there, the hall still churns with sounds you do not want to recognize, and all you can do is wait.
+ [Hold your breath. Do not move at all.] -> s12_hide_ok
+ [Peek through the gaps in the crates] -> s12_peek
+ [Get ready to run if you are spotted] -> s12_ready

=== s12_peek ===
#KICKER:Part 1: The Beginning
#AUDIO:crates
#IMAGE:bg_crates
#SFX:whisper
~ ADD_EMOTION("Takut", 1)
Through the narrow gap between the crates, the world was sliced into shards of darkness — and then its legs appeared. Not human legs. Something too long, with too many joints, dragging slowly from left to right with a scraping sound that raised every hair on your skin. And with it came the stench — thick, damp, rancid, like meat left to rot in a room without air — stabbing into your nose.
Then — one pair of legs stopped. Right in front of your crack. Now you could see them: its eyes, dim yellow, staring straight into the narrow gap where you crouched. Your world stopped. No sound. No breath. Just that gaze, piercing, as if it could see your fear pulsing in your throat.
Then it left. Just like that — turning away with indifference, as if you were only a shadow not worth chasing. Your knees nearly gave out, your chest bursting with the breath you'd only just dared to take. Relief flooded you — and with it, a fear somehow sharper than before. Because just now, it had almost seen you.
-> s12_hide_2

=== s12_ready ===
#KICKER:Part 1: The Beginning
#AUDIO:crates
#IMAGE:bg_crates
Every muscle in your body coiled tight like a bowstring drawn to its limit. Your eyes mapped the route in a heartbeat: from these crates to the door across the hall, zigzagging between the tall pillars, using every patch of shadow. No room for hesitation. One wrong step, and tonight ends.
You steadied your breathing — slow in through the nose, silent out through the mouth. Cold sweat traced your temple, sticky and chilling. Your body leaned forward, ready to bolt at any instant. Now, only waiting for the right moment.
-> s12_ready_2

=== s12_ready_2 ===
#KICKER:Part 1: The Beginning
#AUDIO:crates
#IMAGE:bg_crates
They were still busy with themselves — drifting between the crates, sniffing, unaware of your presence. And across from you, the door was visible. Open. Dark. Promising something better than this place. This second was your window.
+ [Stay hidden] -> s12_hide_ok
+ [Run now!] -> s12_run_1

=== s12_hide_ok ===
#KICKER:Part 1: The Beginning
#TAG:[Canon]
#AUDIO:crates
#IMAGE:bg_crates
~ ADD_TEMP("Ketakutan", 3)
You did not move. You did not even breathe. Your body pressed against the crates, becoming one with the darkness — cold, silent, shapeless. Only your heart hammered, and you prayed the sound would not escape your chest.
One by one, they drifted away — lured by some sound from elsewhere, those strange steps dragging off toward another corner of the hall. Slowly, the hall returned to 'calm'. A false calm, a calm that could shatter at any moment, but calm.
You had gone undetected. But the fear did not leave with them. It clung to your skin, your breath, every moving shadow — at least for a while, you would not be able to shake it.
-> s12_bridge

=== s12_run_1 ===
#KICKER:Part 1: The Beginning
#AUDIO:hall
#IMAGE:bg_hall
You bolted! A deep breath seared your lungs, your feet slamming the floor with thuds that sounded far too loud in the silent hall. Several pairs of eyes turned toward you — then turned away, indifferent. They didn't care. Not yet.
Halfway there. The door across the hall drew closer — you could almost feel the dark air beyond it. Then, from the corner of your eye: a swift movement from the side! Too fast for something that size.
The swift little creature veered without warning — not away, but toward you! Its slender legs flashed across the floor, its eyes locked on you. It was coming.
-> s12_run_2

=== s12_run_2 ===
#KICKER:Part 1: The Beginning
#AUDIO:hall
#IMAGE:bg_hall
It came fast — too fast. The door was only a few steps away, and you could hear those small claws scraping the floor behind you. Your choice now decided everything.
+ [Weave zigzag between them] -> s12_run_ok
+ [Sprint straight as fast as you can] -> s12_run_straight
+ [Abort — hide again] -> s12_hide_1

=== s12_run_straight ===
#KICKER:Part 1: The Beginning
#AUDIO:hall
#IMAGE:bg_hall
~ ADD_EMOTION("Takut", 1)
You ran straight, as fast as your legs could carry you. The world narrowed into a single line — door, door, door. No more pillars, no more shadows, only the goal and the roar of your own breath.
Claws slashed from the side — you dodged by a hair, your body tilting in a fraction of a second. The air split near your cheek. Too close. Too close. But your feet did not stop.
-> s12_run_ok

=== s12_run_ok ===
#KICKER:Part 1: The Beginning
#TAG:[Wounded]
#AUDIO:hall
#IMAGE:bg_hall
~ SET_STATUS("wounded")
~ SET_BODY("Kaki Kiri Terluka")
You reached the door — but at the last second, its claws raked your leg. Searing heat exploded in your left leg. You stumbled through the doorway, and when you looked back, a gash gaped open on your left leg, blood seeping dark into your trousers.
Pain swallowed your whole leg, throbbing with your heartbeat. You had made it through — but at a price. Every step now reminded you of that little creature.
For a while, you could not run fast. Your left leg would not allow it — and The Darkness does not wait for the limping.
-> s12_bridge

=== s12_bridge ===
#KICKER:Part 1: The Beginning
#AUDIO:hall
#IMAGE:bg_hall
The hall of the nightmare parade fell behind you, its sounds fading into a faint hum. The corridor ahead was silent — too silent, as if this place were holding its breath with you.
Your feet stepped — or limped — forward across the cold floor. In your bag, the experiment notes felt heavy, as though those papers held something you did not want to know.
Something waited for you ahead. You could feel it in the air growing colder, in the darkness growing thicker. This story was not over.
-> tbc

=== tbc ===
#AUDIO:corridor
#IMAGE:bg_corridor
To be continued…
-> END

