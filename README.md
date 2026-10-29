# BLT-DD Prioritas — Flutter Cross-Platform

Prototipe akademik untuk mengelola data simulasi calon penerima BLT-DD, menilai tujuh kriteria, dan meninjau urutan prioritas. Satu basis kode Flutter dirancang untuk Web dan Android.

> **Status penting:** kode Firebase tersedia dan hanya diaktifkan jika opsi konfigurasi tersedia serta inisialisasi sukses. Tanpa konfigurasi, aplikasi berjalan dalam mode demo dengan penyimpanan memori sementara. Akun demo bukan Firebase Authentication. Nama calon dan nilai adalah data sintetis; bobot dan skor tidak resmi dan tidak boleh digunakan sebagai keputusan bantuan nyata.

## Identitas proyek

| Item | Keterangan |
|---|---|
| Judul | Perancangan Aplikasi Penentuan Prioritas Calon Penerima BLT-DD Berbasis Cross-Platform Menggunakan Flutter dan Firebase |
| Mahasiswa | Nabhan Miqdad Mubarok |
| NIM | 23.01.55.0017 |
| Kelas | A1 |
| Mata kuliah | Mobile and Web Application Development |
| Periode | Ganjil 2026/2027 |
| Repository | https://github.com/Bamsuti/BLT-DD-prioritas |

## Masalah dan tujuan
Pendataan calon, pembaruan data, perbandingan nilai, serta peninjauan peringkat dapat sulit ditelusuri ketika dikelola dalam spreadsheet terpisah. Prototipe ini menggabungkan login, daftar calon, penilaian tujuh kriteria, dan hasil prioritas. Pengguna utama diasumsikan petugas pengelola data BLT-DD; persona belum diklaim tervalidasi melalui wawancara.

## Fitur kode
- Login dengan validasi email/password, indikator proses, pesan gagal, dan logout.
- Mode demo eksplisit dengan akun lokal sintetis.
- Beranda dengan ringkasan jumlah calon dan kriteria yang dihitung dari data termuat.
- CRUD calon dengan konfirmasi hapus.
- ID simulasi wajib dan pemeriksaan duplikat terhadap daftar yang dimuat.
- Form dengan tujuh kriteria, dropdown skala 1–5, dan validasi.
- Skor SAW demo dihitung dari nilai serta bobot model, kemudian diurutkan.
- NavigationBar untuk layar sempit dan NavigationRail untuk layar lebar.
- Integrasi bersyarat Firebase Authentication dan CRUD Cloud Firestore.
- Draft Firestore Security Rules berbasis autentikasi dan peran.

## Tujuh kriteria dari presentasi UTS
1. Penghasilan keluarga.
2. Jumlah tanggungan.
3. Kondisi dinding.
4. Kondisi lantai.
5. Akses air bersih.
6. Sumber penerangan.
7. Tabungan keluarga.

Bobot demo: 20%, 15%, 15%, 15%, 10%, 10%, 15% (total 100%). Nilai tinggi untuk sementara diartikan sebagai kerentanan lebih tinggi, sehingga seluruh kriteria diperlakukan sebagai benefit pada rumus demo. Bobot, skala, subkriteria, dan arah benefit/cost belum divalidasi dengan dosen/pengguna atau ketentuan resmi.

Rumus demo: Vᵢ = Σ(wⱼ × rᵢⱼ), rᵢⱼ = xᵢⱼ / nilai maksimum kriteria. Hasil hanya bahan demonstrasi teknis dan tidak menggantikan verifikasi maupun musyawarah.

## User flow
Mulai → Login → Beranda → Data Calon Penerima / Penilaian & Prioritas / Hasil Prioritas → Selesai. Login gagal menampilkan validasi/pesan lalu tetap di halaman Login. Lihat docs/rancangan/USER_FLOW.md untuk rincian.

## Struktur utama
- lib/main.dart — halaman, navigasi, formulir
- lib/models/candidate.dart — model, tujuh kriteria, kalkulasi skor demo
- lib/services/app_backend.dart — mode demo dan layanan Firebase
- lib/config/firebase_config.dart — opsi konfigurasi client via dart-define
- test/widget_test.dart — widget test dan test model
- docs/rancangan/ — kebutuhan, persona, user story, alur, wireframe, database
- docs/firebase/ — panduan konfigurasi
- docs/screenshots/ — wireframe SVG, bukan screenshot runtime
- docs/PENGUJIAN.md, docs/PRESENTASI_UTS.md, docs/ROADMAP.md
- firestore.rules — aturan akses awal
- web/index.html — entry HTML Web

Scaffold platform Android/Web (termasuk file Gradle/wrapper yang dihasilkan Flutter) perlu dibuat dan diperiksa menggunakan Flutter SDK lokal jika belum ada. Flutter SDK tidak tersedia dalam sesi pembaruan ini, sehingga file platform generator tidak direka manual.

## Menjalankan mode demo
Prasyarat: Flutter SDK yang mendukung Dart 3.3+, Git, dan Chrome. Dari root proyek:
1. Jika platform folder belum tersedia, jalankan: flutter create --platforms=android,web .
2. Jalankan: flutter pub get
3. Jalankan: flutter analyze
4. Jalankan: flutter test
5. Jalankan: flutter run -d chrome
Untuk Android, siapkan Android SDK kemudian jalankan flutter run.

Akun simulasi lokal:
- Email: demo@blt-dd.local
- Kata sandi: demo123

Akun ini hanya untuk mode demo lokal. Ketika konfigurasi Firebase lengkap dan inisialisasi berhasil, login menggunakan Firebase Authentication dan akun demo lokal tidak berlaku. Jangan membuat akun Firebase nyata dengan kata sandi contoh.

## Konfigurasi Firebase
Baca docs/firebase/SETUP_FIREBASE.md. Konfigurasi client dibaca melalui dart-define. Jangan unggah password, token, private key, atau rahasia pengguna. Firebase belum dapat dinyatakan aktif sampai akun, Email/Password, role, rules, dan CRUD benar-benar diuji.

Kode saat ini menyimpan data calon dan ketujuh skor di satu koleksi calon_penerima. Koleksi penilaian, kriteria_bobot, hasil_prioritas, dan riwayat_proses adalah rancangan lanjutan yang belum dipakai kode aplikasi.

## Status verifikasi
| Area | Status |
|---|---|
| Kode inti halaman dan form | Ditambahkan; belum diverifikasi dengan Flutter SDK dalam sesi ini |
| Mode demo in-memory | Diimplementasikan; belum diuji runtime dalam sesi ini |
| Firebase Auth dan Firestore | Kode bersyarat konfigurasi; belum dihubungkan ke project nyata |
| Firestore rules | Draft; perlu review dan pengujian rules |
| Scaffold Android/Web | Perlu dibuat/diperiksa melalui Flutter SDK lokal |
| Screenshot runtime | Belum tersedia; yang ada adalah wireframe statis |
| Firebase Hosting | Belum di-deploy |
| flutter pub get/analyze/test/run | Belum dijalankan dalam sesi ini |

## Wireframe
- [Login](docs/screenshots/01-login-wireframe.svg)
- [Beranda](docs/screenshots/02-beranda-wireframe.svg)
- [Data Calon](docs/screenshots/03-data-calon-wireframe.svg)
- [Penilaian](docs/screenshots/04-penilaian-wireframe.svg)
- [Hasil Prioritas](docs/screenshots/05-hasil-prioritas-wireframe.svg)

Gambar tersebut adalah wireframe statis, bukan tangkapan layar aplikasi yang berjalan.

## Dokumentasi lanjutan
- [Persona](docs/rancangan/PERSONA.md)
- [Kebutuhan dan keterlacakan](docs/rancangan/KEBUTUHAN.md)
- [User story](docs/rancangan/USER_STORY.md)
- [User flow](docs/rancangan/USER_FLOW.md)
- [Wireframe](docs/rancangan/WIREFRAME.md)
- [Database](docs/rancangan/DATABASE.md)
- [Panduan Firebase](docs/firebase/SETUP_FIREBASE.md)
- [Matriks pengujian](docs/PENGUJIAN.md)
- [Panduan presentasi UTS](docs/PRESENTASI_UTS.md)
- [Roadmap](docs/ROADMAP.md)
