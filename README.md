# BLT-DD Prioritas — Flutter Cross-Platform

Prototipe akademik untuk mencatat data simulasi calon penerima BLT-DD, menilai tujuh kriteria kerentanan, lalu meninjau urutan prioritas. Satu basis kode Flutter dijalankan sebagai aplikasi Web dan Android.

> **Status jujur:** aplikasi berjalan dalam **mode demo** (data di memori) dan sudah diuji otomatis dengan `flutter analyze` + `flutter test`. Sejak minggu 9, halaman masuk dilengkapi **pendaftaran akun** dan perpindahan halaman mengikuti status login (`authStateChanges()`). Project Firebase `bltdd-prioritas-6f007` (paket Spark gratis) sudah dibuat, Authentication Email/Password aktif, dan alur masuk/daftar/keluar/pemulihan sesi **diuji nyata** (7 kasus, lihat [docs/PENGUJIAN.md](docs/PENGUJIAN.md) tabel A2). Cloud Firestore belum dibuat sehingga isi Beranda pada mode Firebase masih memuat (lingkup minggu 10). Firebase Hosting belum di-deploy. APK debug berhasil dibangun melalui GitHub Actions, tetapi belum dijalankan di perangkat/emulator. Semua nama calon dan nilai adalah data sintetis; skor bukan keputusan resmi penerima bantuan.

**Akses demo web:** https://bamsuti.github.io/BLT-DD-prioritas/ — diterbitkan melalui GitHub Pages, berjalan dalam mode demo dengan akun `demo@blt-dd.local` / `demo123`.

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
| Demo web | https://bamsuti.github.io/BLT-DD-prioritas/ |
| Proposal UTS | [docs/proposal/PROPOSAL_UTS.pdf](docs/proposal/PROPOSAL_UTS.pdf) |
| Video presentasi | [YouTube](https://youtu.be/HNK0bMPqo08) · [MP4 6:15](docs/video/blt-dd-prioritas-promo.mp4) |
| Wireframe | [Figma](https://www.figma.com/make/xnbomh0HD3xaMEtZ0ehUwh/BLT-DD-Prioritas-Wireframe?t=xP6ZZ7tKgaItZh19-1) · [lima SVG](docs/rancangan/WIREFRAME.md) |
| Versi aplikasi | 1.0.0+1 |

## Masalah dan tujuan

Pendataan calon, pembaruan nilai, dan peninjauan peringkat sulit ditelusuri bila dikelola dalam beberapa spreadsheet terpisah. Prototipe ini menyatukan login petugas, pengelolaan data calon, penilaian tujuh kriteria, dan hasil prioritas dalam satu aplikasi responsif.

Ruang lingkup dibatasi pada:

- pengelolaan data simulasi dan perhitungan skor demo;
- tidak menangani pencairan dana atau integrasi sistem pemerintah;
- tidak memakai data warga nyata;
- tidak menggantikan verifikasi lapangan maupun musyawarah desa.

## Fitur yang tersedia

| Fitur | Keterangan | Status |
|---|---|---|
| Login petugas | Validasi email/kata sandi, indikator proses, pesan gagal, logout | Berfungsi di mode demo, diuji otomatis |
| Daftar akun petugas (minggu 9) | Mode daftar dengan kolom ulangi kata sandi; akun baru langsung masuk; email terpakai dan kata sandi lemah ditolak dengan pesan Bahasa Indonesia | Berfungsi di mode demo, diuji otomatis + Chrome headless |
| Cek status login (minggu 9) | Halaman mengikuti aliran status sesi (`StreamBuilder` + `authStateChanges()` di Firebase); keluar dan pendaftaran otomatis mengganti halaman tanpa Navigator | Berfungsi di mode demo, diuji otomatis + Chrome headless |
| Login Firebase | Email/Password via Firebase Authentication; sesi tersimpan dipulihkan; pesan kesalahan Bahasa Indonesia | Berfungsi; diuji nyata pada project `bltdd-prioritas-6f007` (7 kasus, tabel A2) |
| Mode demo eksplisit | Akun lokal sintetis, label "Mode demo" pada layar | Berfungsi, diuji otomatis |
| Beranda | Jumlah calon, jumlah kriteria, jumlah hasil dihitung dari data termuat; pintasan navigasi | Berfungsi |
| Data calon (CRUD) | Tambah, lihat, ubah, hapus dengan dialog konfirmasi | Berfungsi di mode demo, diuji otomatis |
| Validasi form | ID simulasi, nama, dusun wajib; ID duplikat ditolak; tujuh nilai kriteria | Berfungsi, diuji otomatis |
| Penilaian | Tujuh kriteria + bobot demo + tombol isi nilai | Berfungsi |
| Hasil prioritas | Skor 0–100, urut menurun, penjelasan rumus, disclaimer | Berfungsi |
| Navigasi responsif | `NavigationBar` (< 760 px) dan `NavigationRail` (≥ 760 px) | Berfungsi, diuji otomatis |
| Firebase Auth + Firestore | Auth aktif saat `--dart-define` lengkap dan sudah diuji nyata; Firestore belum dibuat sehingga data calon masih mode demo | Auth diuji nyata; Firestore menunggu minggu 10 |

## Tujuh kriteria dan bobot demo

| Kode | Kriteria | Bobot |
|---|---|---|
| C1 | Penghasilan keluarga | 20% |
| C2 | Jumlah tanggungan | 15% |
| C3 | Kondisi dinding | 15% |
| C4 | Kondisi lantai | 15% |
| C5 | Akses air bersih | 10% |
| C6 | Sumber penerangan | 10% |
| C7 | Tabungan keluarga | 15% |
| | **Total** | **100%** |

Skala nilai 1–5, di mana **nilai lebih tinggi berarti kondisi lebih rentan**. Karena itu seluruh kriteria diperlakukan sebagai *benefit* pada perhitungan demo.

Rumus SAW (Simple Additive Weighting) demo:

```
rᵢⱼ = xᵢⱼ / 5
Vᵢ  = Σ (wⱼ × rᵢⱼ)          untuk tujuh kriteria
Skor = Vᵢ × 100
```

Contoh: SIM-001 memiliki nilai C1–C7 = 5, 4, 4, 4, 3, 4, 5.

```
V = (0,20×1,0) + (0,15×0,8) + (0,15×0,8) + (0,15×0,8)
  + (0,10×0,6) + (0,10×0,8) + (0,15×1,0) = 0,85
Skor akhir = 85,0
```

Bobot, skala, dan arah benefit/cost masih asumsi demo dan belum divalidasi dengan dosen atau ketentuan resmi BLT-DD.

## Screenshot runtime

Screenshot diambil dari **build Web yang benar-benar dijalankan** (Flutter Web + Chrome headless), bukan mockup. Data yang tampil adalah data simulasi bawaan aplikasi.

| Halaman | Desktop (1280×800) | Mobile (390×844) |
|---|---|---|
| Login | ![Login desktop](docs/screenshots/runtime/01-login-desktop.png) | ![Login mobile](docs/screenshots/runtime/01-login-mobile.png) |
| Beranda | ![Beranda desktop](docs/screenshots/runtime/02-beranda-desktop.png) | ![Beranda mobile](docs/screenshots/runtime/02-beranda-mobile.png) |
| Data calon | ![Data calon desktop](docs/screenshots/runtime/03-data-calon-desktop.png) | ![Data calon mobile](docs/screenshots/runtime/03-data-calon-mobile.png) |
| Penilaian & prioritas | ![Penilaian desktop](docs/screenshots/runtime/04-penilaian-desktop.png) | ![Penilaian mobile](docs/screenshots/runtime/04-penilaian-mobile.png) |
| Hasil prioritas | ![Hasil desktop](docs/screenshots/runtime/05-hasil-desktop.png) | ![Hasil mobile](docs/screenshots/runtime/05-hasil-mobile.png) |
| Form tambah calon | ![Form desktop](docs/screenshots/runtime/06-form-tambah-desktop.png) | ![Form mobile](docs/screenshots/runtime/06-form-tambah-mobile.png) |
| Validasi form | ![Validasi desktop](docs/screenshots/runtime/07-form-validasi-desktop.png) | ![Validasi mobile](docs/screenshots/runtime/07-form-validasi-mobile.png) |
| Simpan berhasil (SnackBar) | ![SnackBar desktop](docs/screenshots/runtime/08-form-snackbar-desktop.png) | — |
| Hasil dengan data baru | ![Hasil enam calon](docs/screenshots/runtime/09-hasil-enam-calon-desktop.png) | — |
| Mode daftar (minggu 9) | ![Mode daftar](docs/screenshots/runtime/09-login-mode-daftar.png) | — |
| Daftar ditolak: email terpakai | ![Email terpakai](docs/screenshots/runtime/10-daftar-email-terpakai.png) | — |
| Masuk berhasil | ![Masuk berhasil](docs/screenshots/runtime/12-login-berhasil-beranda.png) | — |
| Akun baru langsung di Beranda | ![Daftar berhasil](docs/screenshots/runtime/13-daftar-baru-beranda.png) | — |
| Pengguna terdaftar di Firebase Console | ![Console Users](docs/screenshots/runtime/19-firebase-console-users.png) | — |
| Mode Firebase: daftar akun baru | ![Firebase daftar](docs/screenshots/runtime/21-firebase-daftar-baru-beranda.png) | — |
| Mode Firebase: sesi bertahan setelah refresh | ![Firebase sesi](docs/screenshots/runtime/22-firebase-refresh-sesi-bertahan.png) | — |

Wireframe rancangan awal tetap disimpan sebagai SVG di `docs/screenshots/` dan bukan bukti runtime.

## Proposal UTS

Proposal lengkap tersedia sebagai PDF 11 halaman: [docs/proposal/PROPOSAL_UTS.pdf](docs/proposal/PROPOSAL_UTS.pdf). Isinya mencakup identitas, latar belakang dan masalah, ruang lingkup, persona, sembilan user story, kebutuhan fungsional K-01–K-08, user flow, sitemap, lima wireframe, tech stack, rumus SAW, rancangan Firestore, keamanan, status verifikasi, dan tautan.

- Sumber HTML: [docs/proposal/PROPOSAL_UTS.html](docs/proposal/PROPOSAL_UTS.html)
- Sitemap versi Mermaid: [docs/rancangan/SITEMAP.md](docs/rancangan/SITEMAP.md)
- Peta kesesuaian butir UTS: [docs/UTS_CHECKLIST.md](docs/UTS_CHECKLIST.md)

**Tautan Figma:** [BLT-DD Prioritas — Wireframe](https://www.figma.com/make/xnbomh0HD3xaMEtZ0ehUwh/BLT-DD-Prioritas-Wireframe?t=xP6ZZ7tKgaItZh19-1). Tautan ini disediakan pemilik proyek. Lima SVG di `docs/screenshots/` tetap disertakan sebagai aset rancangan yang tertanam di proposal, sehingga dokumen dapat dibuka tanpa akses Figma.

## Video penjelasan

Video 16:9 berdurasi 6 menit 15 detik, di bawah batas 10 menit, menjelaskan masalah, pengguna utama, prioritas fitur, desain, demo prototipe (termasuk form kosong ditolak, data valid disimpan, SnackBar, dan baris baru tampil), rencana teknis termasuk rencana Pertemuan 9–15, serta empat pertanyaan wajib.

- Video: [YouTube](https://youtu.be/HNK0bMPqo08) · [unduh MP4](docs/video/blt-dd-prioritas-promo.mp4) — 6:15, 1080p
- Spesifikasi: 1920×1080, 30 fps, H.264 + AAC, suara Edge TTS `id-ID-ArdiNeural`, tanpa musik
- Isi per babak dan rincian produksi: [docs/VIDEO.md](docs/VIDEO.md)
- Sumber dan cara render: `video/` (Remotion)

Bagian demo memakai rekaman runtime aplikasi yang benar-benar dijalankan (login → beranda → data calon → validasi form → penilaian → hasil), bukan mockup. Firebase belum terhubung ke proyek nyata dan seluruh skor bersifat simulasi.

## Arsitektur dan struktur proyek

```
lib/
├── main.dart                  # bootstrap + gerbang login/mode dokumentasi
├── config/firebase_config.dart# opsi Firebase dari --dart-define
├── core/theme.dart            # warna, tema Material 3
├── data/data_simulasi.dart    # lima calon sintetis SIM-001..SIM-005
├── models/candidate_model.dart# Criterion, Candidate, rumus SAW, ranking
├── pages/
│   ├── login_page.dart
│   ├── app_shell.dart         # AppBar, navigasi responsif, CRUD, logout
│   ├── beranda_page.dart
│   ├── data_calon_page.dart   # daftar + dialog form tujuh kriteria
│   ├── penilaian_page.dart
│   └── hasil_prioritas_page.dart
├── services/app_backend.dart  # mode demo + Firebase Auth/Firestore
└── widgets/app_widgets.dart   # SummaryCard, SectionCard, InfoBanner, dll.
test/widget_test.dart          # 28 pengujian otomatis
tools/capture_screenshots.js   # skrip screenshot runtime
video/                         # sumber video Remotion + narasi Edge TTS
docs/                          # rancangan, Firebase, pengujian, presentasi
docs/video/                    # hasil render video penjelasan (MP4)
firestore.rules                # draft aturan akses berbasis role
firebase.json                  # konfigurasi Firestore rules + Hosting
```

Alur data: `AppShell` memuat daftar calon dari `AppBackend` → halaman menerima `List<Candidate>` → form mengirim `Candidate` kembali → backend menyimpan (memori atau Firestore) → daftar dimuat ulang → skor dihitung ulang oleh `rankCandidates()`.

## Alur pengguna

```
Login / Daftar → Beranda → Data Calon Penerima → Penilaian & Prioritas → Hasil Prioritas → Keluar
```

- Belum punya akun petugas: beralih ke mode daftar melalui tautan "Belum punya akun? Daftar", mengisi email, kata sandi, dan ulangi kata sandi, lalu akun baru langsung membuka Beranda.
- Login gagal menampilkan pesan validasi atau pesan autentikasi dan tetap di halaman Login.
- Login berhasil membuka Beranda dengan ringkasan yang dihitung dari data termuat.
- CRUD calon memakai dialog form yang sama untuk tambah dan ubah.
- Hapus selalu meminta konfirmasi dan menampilkan pesan berhasil/gagal.
- Keluar memanggil `signOut` dan kembali ke Login; halaman berganti otomatis karena mengikuti status login.

Rincian ada di [docs/rancangan/USER_FLOW.md](docs/rancangan/USER_FLOW.md).

## Menjalankan aplikasi (mode demo)

Prasyarat: Flutter SDK 3.47.7 (Dart 3.13.5), Git, dan Chrome. Android memerlukan Android SDK.

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Untuk build Web:

```bash
flutter build web
```

Akun demo lokal:

- Email: `demo@blt-dd.local`
- Kata sandi: `demo123`

Akun ini hanya berlaku pada mode demo dan bukan Firebase Authentication. Jangan memakai kata sandi ini untuk akun nyata.

### Mode dokumentasi (screenshot)

Build dengan `--dart-define=SCREENSHOT_MODE=true`, lalu buka `?page=N`:

| `page` | Halaman |
|---|---|
| 0 | Login |
| 1–4 | Beranda, Data Calon, Penilaian, Hasil |
| 5 | Data Calon + dialog form terbuka |
| 6 | Data Calon + dialog form dengan pesan validasi |

Mode ini hanya untuk dokumentasi dan tidak melewati autentikasi pada build normal.

## Konfigurasi Firebase

Kode membaca konfigurasi client dari `--dart-define` (lihat `lib/config/firebase_config.dart`):

- `FIREBASE_API_KEY`
- `FIREBASE_APP_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_AUTH_DOMAIN` (opsional)
- `FIREBASE_STORAGE_BUCKET` (opsional, tidak dipakai fitur saat ini)

Contoh (placeholder, isi dengan nilai project Anda):

```bash
flutter run -d chrome \
  --dart-define=FIREBASE_API_KEY=ISI_SENDIRI \
  --dart-define=FIREBASE_APP_ID=ISI_SENDIRI \
  --dart-define=FIREBASE_MESSAGING_SENDER_ID=ISI_SENDIRI \
  --dart-define=FIREBASE_PROJECT_ID=ISI_SENDIRI
```

Jika konfigurasi tidak lengkap atau inisialisasi gagal, aplikasi tetap berjalan di mode demo dan menampilkan label yang sesuai. Panduan lengkap: [docs/firebase/SETUP_FIREBASE.md](docs/firebase/SETUP_FIREBASE.md).

Untuk web publik di GitHub Pages, workflow membaca nilai yang sama dari repository secrets (`FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_PROJECT_ID`, `FIREBASE_AUTH_DOMAIN`, `FIREBASE_STORAGE_BUCKET`). Tanpa secrets, build publik tetap mode demo. Tambahkan juga `bamsuti.github.io` ke Authorized domains di Firebase Authentication.

**Sudah dilakukan (minggu 9):** project `bltdd-prioritas-6f007` dibuat pada paket Spark gratis, Authentication Email/Password diaktifkan, aplikasi dibangun dengan nilai `--dart-define` di atas, dan alur masuk/daftar/keluar/pemulihan sesi diuji nyata (tabel A2 di [docs/PENGUJIAN.md](docs/PENGUJIAN.md)). Nilai konfigurasi tidak disimpan di repo — disuntikkan saat build, sehingga tetap aman.

**Yang belum dilakukan:** Firestore belum dibuat (data calon masih mode demo pada build Firebase), secrets Pages untuk demo publik belum diisi, akun petugas belum diberi role di `users/{uid}`, rules belum diuji di Emulator Suite, dan Hosting belum di-deploy.

## Keamanan dan privasi

- Tidak ada password, private key, token, atau service account di repository ini.
- Kredensial demo (`demo@blt-dd.local` / `demo123`) adalah akun sintetis internal mode demo, bukan akun layanan nyata.
- Data contoh memakai label fiktif (`Calon Simulasi A`–`E`, `SIM-001`–`SIM-005`), bukan NIK atau data warga.
- `firestore.rules` **tidak** membuka akses publik: hanya user terautentikasi dengan dokumen `users/{uid}` berrole `admin`/`petugas` yang boleh mengakses data operasional, dan dokumen `users` tidak dapat ditulis dari client.
- Rules masih draft dan wajib diuji di lingkungan non-produksi sebelum dipakai.

## Pengujian

Lingkungan: Windows, Flutter 3.47.7 stable, Dart 3.13.5.

Seluruh pengujian dijalankan mandiri oleh pembuat: test otomatis dan screenshot di mesin lokal, build APK di GitHub Actions. Tidak ada pengujian yang menunggu petugas desa; validasi lapangan persona dan bobot berada di luar lingkup UTS.

| Pemeriksaan | Perintah | Hasil |
|---|---|---|
| Analisis statis | `flutter analyze` | **No issues found** |
| Test otomatis | `flutter test` | **28 test, semua lulus** |
| Build Web | `flutter build web` | **Berhasil** |
| Screenshot runtime | Chrome headless terhadap build Web dan demo live | **34 file** (14 utama + 2 bukti SnackBar/hasil + 10 bukti masuk/daftar minggu 9 + 8 bukti Firebase) |
| Uji masuk/daftar (minggu 9) | Chrome headless mengisi form login/daftar pada build Web biasa | **11/11 kasus sesuai harapan** (MD-1 s.d. MD-11) |
| Uji mode Firebase nyata (minggu 9) | Chrome headless terhadap build Web dengan `--dart-define` Firebase | **7/7 kasus sesuai harapan** (FB-1 s.d. FB-7); akun terdaftar diverifikasi di Console |
| Video penjelasan | `npm run render` di `video/` | **Berhasil**; 6 menit 15 detik, 1920×1080, audio AAC terverifikasi |
| Uji live GitHub Pages | Chrome headless ke demo publik | **Berhasil**; form kosong ditolak per kolom, SnackBar "tersimpan", dan baris SIM-006 tampil |
| Deploy web (GitHub Pages) | Workflow `Deploy Web to GitHub Pages` | **Berhasil**; halaman publik merespons 200 dan tampilan login terverifikasi |
| Build Android | GitHub Actions `flutter build apk --debug` | **Berhasil**; belum dijalankan di perangkat |
| Firebase Auth | Build dengan `--dart-define` project `bltdd-prioritas-6f007` | **Diuji nyata**; 7/7 kasus (daftar, masuk, keluar, sesi bertahan, 2 pesan galat) |
| Firebase Firestore | — | **Belum dibuat/diuji** (lingkup minggu 10) |
| Firebase Hosting | — | **Belum di-deploy** |

CI: [GitHub Actions](https://github.com/Bamsuti/BLT-DD-prioritas/actions) menjalankan analyze, 28 test, build Web, dan build APK debug pada setiap push ke `main`. Hasil terbaru dapat dilihat langsung di halaman Actions.

Cakupan 28 test otomatis: tujuh kriteria & total bobot, rentang skor, urutan ranking, tie-break, serialisasi dan kontrak field Firestore, CRUD mode demo, penolakan ID duplikat, login demo salah/benar, validasi email & kata sandi, pendaftaran akun (ulangi kata sandi tidak sama, email sudah dipakai, akun baru langsung masuk, akun baru dipakai masuk kembali), logout, navigasi lebar/sempit, validasi form, tambah/ubah/hapus, SnackBar data tersimpan, empty state "Belum ada data", perubahan nilai memengaruhi skor, dan mode dokumentasi.

Matriks skenario lengkap beserta status per skenario: [docs/PENGUJIAN.md](docs/PENGUJIAN.md).

## Status verifikasi

| Area | Status |
|---|---|
| Kode inti, form, navigasi | Selesai, `flutter analyze` bersih |
| Mode demo in-memory | Berfungsi, diuji otomatis |
| Test otomatis | 28/28 lulus |
| Masuk dan daftar (minggu 9) | Selesai; mode demo diuji otomatis + Chrome headless (11 kasus) dan mode Firebase nyata (7 kasus, tabel A2) |
| Build Web | Berhasil |
| Screenshot runtime | Tersedia dan diambil dari build Web |
| Video penjelasan | Dirender 1 November 2026; 6:15, 1080p, delapan babak, narasi Edge TTS, demo runtime asli (validasi + SnackBar), tanpa musik |
| Proposal UTS | PDF dengan persona, sembilan user story, kebutuhan **Must/Should**, user flow, sitemap, wireframe, tech stack Firebase Spark, rancangan Firestore, dan jawaban Q5–Q7 |
| Deploy web | GitHub Pages aktif 29 Oktober 2026; aplikasi berjalan mode demo |
| Scaffold Android | Tersedia (Gradle Kotlin DSL, `minSdk` mengikuti Flutter, izin INTERNET) |
| Build Android | APK debug berhasil dibangun di GitHub Actions; belum diuji di perangkat/emulator |
| Firebase Auth + Firestore | Auth terhubung ke `bltdd-prioritas-6f007` dan diuji nyata (A2); Firestore belum dibuat |
| Login Firebase | Alur Email/Password, pemulihan sesi, dan pesan error lulus uji nyata; akun terdaftar terverifikasi di Console |
| Firestore rules | Draft; belum diuji/deploy |
| CI GitHub Actions | Berjalan pada setiap push: analyze, 28 test, build Web, build APK debug |
| Firebase Hosting | Belum di-deploy |

## Roadmap

1. Membuat Firestore, menguji CRUD + rules di Emulator Suite (project dan Auth Email/Password sudah selesai pada minggu 9).
2. Menguji rules (user tanpa role, role petugas, akses tulis `users`).
3. Build dan uji APK di perangkat/emulator Android.
4. Deploy Firebase Hosting setelah build Web final.
5. Menyimpan snapshot hasil per periode + versi bobot dan audit trail.
6. Validasi persona, bobot, subkriteria, dan formula bersama dosen/petugas.

Rincian: [docs/ROADMAP.md](docs/ROADMAP.md).

## Dokumentasi

- [Proposal UTS (PDF)](docs/proposal/PROPOSAL_UTS.pdf)
- [Checklist kesesuaian UTS](docs/UTS_CHECKLIST.md)
- [Identitas, kebutuhan, dan keterlacakan](docs/rancangan/KEBUTUHAN.md)
- [Persona](docs/rancangan/PERSONA.md)
- [User story](docs/rancangan/USER_STORY.md)
- [User flow](docs/rancangan/USER_FLOW.md)
- [Sitemap](docs/rancangan/SITEMAP.md)
- [Wireframe](docs/rancangan/WIREFRAME.md)
- [Rancangan database](docs/rancangan/DATABASE.md)
- [Panduan Firebase](docs/firebase/SETUP_FIREBASE.md)
- [Matriks pengujian](docs/PENGUJIAN.md)
- [Panduan presentasi UTS](docs/PRESENTASI_UTS.md)
- [Roadmap](docs/ROADMAP.md)
- [Keterangan screenshot](docs/screenshots/README.md)
- [Video penjelasan (spesifikasi dan produksi)](docs/VIDEO.md)

---

Prototipe ini dibuat untuk keperluan akademik. Skor dan peringkat yang dihasilkan tidak boleh digunakan sebagai dasar keputusan penerima bantuan tanpa verifikasi dan musyawarah resmi.
