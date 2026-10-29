# BLT-DD Prioritas — Aplikasi Cross-Platform Flutter

Prototipe aplikasi untuk membantu petugas desa mengelola data simulasi calon penerima BLT-DD (Bantuan Langsung Tunai Dana Desa), mengisi penilaian berbasis kriteria, dan melihat urutan prioritas. Dibangun dengan **Flutter** sehingga satu basis kode dapat berjalan di **web** dan **Android**.

> **Peringatan penting:** Ini adalah prototipe akademik. Data disimpan sementara di memori aplikasi, login hanya validasi lokal, dan Firebase belum dihubungkan. Nama calon yang tampil adalah data simulasi, bukan data warga sebenarnya. Bobot dan skor merupakan contoh demonstrasi teknis, **bukan ketentuan resmi** untuk menetapkan penerima bantuan. Keputusan nyata harus mengikuti aturan desa, verifikasi lapangan, dan musyawarah.

---

## Identitas Proyek

| Item | Keterangan |
|---|---|
| Judul | Perancangan Aplikasi Penentuan Prioritas Calon Penerima BLT-DD Berbasis Cross-Platform Menggunakan Flutter dan Firebase |
| Mahasiswa | Nabhan Miqdad Mubarok |
| NIM | 23.01.55.0017 |
| Kelas | A1 |
| Mata kuliah | Mobile and Web Application Development |
| Repository | https://github.com/Bamsuti/BLT-DD-prioritas |

---

## Daftar Isi

1. [Teknologi yang Digunakan](#teknologi-yang-digunakan)
2. [Langkah 1 — Masalah dan Kebutuhan](#langkah-1--masalah-dan-kebutuhan)
3. [Langkah 2 — Flow dan Wireframe](#langkah-2--flow-dan-wireframe)
4. [Langkah 3 — Halaman dan Navigasi](#langkah-3--halaman-dan-navigasi)
5. [Langkah 4 — Form dan Pengujian](#langkah-4--form-dan-pengujian)
6. [Rencana Database Firebase](#rencana-database-firebase)
7. [Struktur Project](#struktur-project)
8. [Cara Menjalankan](#cara-menjalankan)
9. [Screenshot](#screenshot)
10. [Daftar Pekerjaan Setelah UTS](#daftar-pekerjaan-setelah-uts)

---

## Teknologi yang Digunakan

| Lapisan | Teknologi | Keterangan |
|---|---|---|
| Framework UI | Flutter 3.47.7 (stable) | Satu basis kode untuk web dan mobile |
| Bahasa | Dart 3 | Null-safety, widget-based UI |
| State management | StatefulWidget bawaan | Cukup untuk prototipe akademik |
| Desain | Material 3 | Tema kustom dengan warna primer maroon `#7A1C2E` |
| Backend (rencana) | Firebase Spark/Blaze | Auth, Cloud Firestore, Hosting |
| Screenshot otomatis | Playwright + Python | Chromium headless mengambil gambar runtime dari `build/web/` |
| Pengujian | flutter_test | Widget test untuk halaman login |

---

## Langkah 1 — Masalah dan Kebutuhan

### Masalah

Di banyak desa, pendataan calon penerima BLT-DD dan penyusunan urutan prioritas masih dilakukan secara manual menggunakan spreadsheet atau kertas kerja. Hal ini menyebabkan:

- Proses pembaruan data lambat dan rawan duplikasi.
- Perbandingan antarcalon dilakukan satu per satu, sehingga butuh waktu lama.
- Bobot dan kriteria tidak terdokumentasi secara konsisten.
- Riwayat perubahan nilai sulit dilacak.

### Pengguna Utama

**Petugas Pengelola Data BLT-DD Desa** — bertugas mengumpulkan data warga, mengisi penilaian kriteria, dan menyusun daftar prioritas untuk dibahas dalam musyawarah desa.

Persona lebih detail tersedia di [`docs/rancangan/PERSONA.md`](docs/rancangan/PERSONA.md).

### Kebutuhan Utama

| ID | Kebutuhan | Alasan |
|---|---|---|
| K1 | Login dengan akun petugas | Hanya petugas berwenang yang boleh mengubah data |
| K2 | Mengelola data calon penerima | Data warga tersimpan terstruktur dan mudah diubah |
| K3 | Mengisi nilai kriteria secara terstandarisasi | Skala dan bobot sama untuk setiap calon |
| K4 | Melihat urutan prioritas otomatis | Mempercepat penyusunan bahan musyawarah |
| K5 | Akses via ponsel dan browser | Petugas dapat bekerja di lapangan maupun di kantor desa |

### Ruang Lingkup Prototipe

**Masuk lingkup:**

- Login demo dengan validasi lokal.
- CRUD data calon simulasi (di memori).
- Form penilaian 7 kriteria skala 1–5.
- Perhitungan skor preferensi demo.
- Tampilan responsif web dan mobile.

**Di luar lingkup prototipe:**

- Integrasi Firebase Authentication dan Cloud Firestore (direncanakan pasca-UTS).
- Penggunaan data pribadi warga nyata.
- Penetapan penerima bantuan otomatis tanpa verifikasi/musyawarah.
- Pencairan dana dan pelaporan keuangan.

---

## Langkah 2 — Flow dan Wireframe

### User Flow Utama

```text
Mulai
  |
  v
Login -- email/password tidak valid --> Pesan validasi --> Login
  |
  v
Beranda
  |--------------------|---------------------|
  v                    v                     v
Data Calon       Penilaian & Prioritas   Hasil Prioritas
  |                    |                     ^
  | Tambah/Ubah        | cek nilai           |
  | validasi form      | hitung skor --------|
  v
Daftar calon
```

Alur inti:

`Mulai → Login → Beranda → Data Calon Penerima → Penilaian & Prioritas → Hasil Prioritas`

### User Story Utama

| # | User story | Kriteria penerimaan |
|---|---|---|
| 1 | Sebagai petugas, saya ingin login agar hanya petugas berwenang yang mengelola data. | Email wajib mengandung `@`; password minimal 4 karakter; validasi lokal menolak input kosong. |
| 2 | Sebagai petugas, saya ingin menambah dan melihat data calon. | Form menyimpan nama, dusun, dan catatan; data muncul di daftar. |
| 3 | Sebagai petugas, saya ingin memasukkan nilai 7 kriteria. | Setiap kriteria memiliki skala 1–5 dengan keterangan; tidak boleh kosong. |
| 4 | Sebagai petugas, saya ingin melihat hasil prioritas. | Sistem menghitung skor dan menampilkan peringkat dari tertinggi ke terendah. |
| 5 | Sebagai petugas, saya ingin mengakses aplikasi via ponsel dan browser. | Navigasi dan konten menyesuaikan lebar layar. |

User story lengkap: [`docs/rancangan/USER_STORY.md`](docs/rancangan/USER_STORY.md).  
Use case inti: [`docs/rancangan/USE_CASE.md`](docs/rancangan/USE_CASE.md).

### Wireframe dan Keputusan Desain

Wireframe awal disusun di Figma untuk 5 halaman utama: Login, Beranda, Data Calon Penerima, Penilaian & Prioritas, dan Hasil Prioritas.

Keputusan desain penting:

| Keputusan | Alasan |
|---|---|
| Menu pendek (Beranda · Data Calon · Penilaian · Hasil) | Lebih mudah dibaca di layar sempit |
| Form tambah/ubah sebagai dialog di halaman Data Calon | Pengguna tetap dalam konteks daftar calon |
| Navigation rail untuk layar lebar, bottom navigation untuk layar sempit | Satu basis kode Flutter tetap nyaman di web dan ponsel |
| Palet warna maroon `#7A1C2E` | Warna formal yang sesuai dengan nuansa aplikasi pemerintahan/desa |

Wireframe dan palet warna: [`docs/rancangan/WIREFRAME.md`](docs/rancangan/WIREFRAME.md).  
Keputusan desain: [`docs/rancangan/DESIGN_DECISIONS.md`](docs/rancangan/DESIGN_DECISIONS.md).

---

## Langkah 3 — Halaman dan Navigasi

### Daftar Halaman

| Halaman | Fungsi | File |
|---|---|---|
| **Login** | Validasi email & password demo | [`lib/pages/login_page.dart`](lib/pages/login_page.dart) |
| **Beranda** | Ringkasan data calon, kriteria, hasil prioritas, dan top 3 calon | [`lib/pages/beranda_page.dart`](lib/pages/beranda_page.dart) |
| **Data Calon Penerima** | Daftar calon, tambah/ubah/hapus, dialog form 7 kriteria | [`lib/pages/data_calon_page.dart`](lib/pages/data_calon_page.dart) |
| **Penilaian & Prioritas** | Menampilkan 7 kriteria dan bobot demo, pintasan ke hasil | [`lib/pages/penilaian_page.dart`](lib/pages/penilaian_page.dart) |
| **Hasil Prioritas** | Peringkat calon berdasarkan skor preferensi demo | [`lib/pages/hasil_prioritas_page.dart`](lib/pages/hasil_prioritas_page.dart) |

### Navigasi Responsif

- **Layar < 760 px:** `NavigationBar` di bagian bawah dengan 4 item.
- **Layar ≥ 760 px:** `NavigationRail` di sisi kiri dengan ikon dan label.
- Semua halaman setelah login terhubung melalui shell yang sama: [`lib/pages/app_shell.dart`](lib/pages/app_shell.dart).

### Hubungan Fitur dengan Kebutuhan

| Kebutuhan | Fitur yang Memenuhi | Bukti di Kode |
|---|---|---|
| K1 — Login | Halaman Login dengan `Form` validation | `lib/pages/login_page.dart` |
| K2 — Kelola calon | CRUD di `CandidatesPage` + `CandidateDialog` | `lib/pages/data_calon_page.dart` |
| K3 — Kriteria standar | 7 dropdown kriteria skala 1–5 | `lib/models/candidate_model.dart` |
| K4 — Prioritas otomatis | Perhitungan `preference` berbobot | `lib/models/candidate_model.dart` |
| K5 — Cross-platform | Responsive shell + Flutter web build | `lib/pages/app_shell.dart`, `build/web/` |

---

## Langkah 4 — Form dan Pengujian

### Form Tambah/Ubah Calon

Form berada dalam dialog (`CandidateDialog`) dan terdiri dari:

1. **Nama/label calon** — wajib diisi.
2. **Dusun/kelompok** — wajib diisi (simulasi).
3. **Catatan** — opsional.
4. **7 kriteria skala 1–5** menggunakan `DropdownButtonFormField`:
   - Penghasilan keluarga (bobot 20%)
   - Jumlah tanggungan (bobot 15%)
   - Kondisi dinding (bobot 15%)
   - Kondisi lantai (bobot 15%)
   - Akses air bersih (bobot 10%)
   - Sumber penerangan (bobot 10%)
   - Tabungan keluarga (bobot 15%)

Nilai **5** berarti kondisi lebih rentan/memenuhi syarat prioritas lebih tinggi pada prototipe ini.

### Rumus Skor Preferensi Demo

```
preference = Σ ( (nilai kriteria / 5) × bobot )
```

Total bobot = 100%. Hasil diurutkan dari skor tertinggi ke terendah.

### Pengujian Otomatis

File pengujian: [`test/widget_test.dart`](test/widget_test.dart)

| # | Kasus uji | Yang dicek |
|---|---|---|
| 1 | Judul dan tombol login tampil | `find.text('BLT-DD Prioritas')`, `find.text('Masuk ke prototipe')` |
| 2 | Validasi email kosong dan password < 4 karakter | Pesan kesalahan muncul |
| 3 | Login valid berpindah ke Beranda | Teks ringkasan beranda ditemukan |

> **Catatan lingkungan:** `flutter test` kadang mengalami kendali koneksi `flutter_tester` di lingkungan sandbox. Ini adalah keterbatasan lingkungan, bukan kesalahan kode. `flutter analyze` berhasil tanpa masalah.

### Matriks Pengujian Manual

| No. | Skenario | Hasil yang diharapkan |
|---|---|---|
| 1 | Klik masuk dengan email kosong | Pesan validasi tampil |
| 2 | Email tanpa karakter `@` | Pesan validasi email tampil |
| 3 | Tambah calon tanpa nama | Form menolak penyimpanan |
| 4 | Tambah calon dengan nama dan dusun | Data muncul di daftar |
| 5 | Ubah data calon | Data daftar diperbarui |
| 6 | Hapus calon dan konfirmasi | Data hilang dari daftar |
| 7 | Tambah beberapa nilai berbeda | Urutan hasil dihitung ulang |
| 8 | Ubah lebar browser di bawah/atas 760 px | Navigasi berubah dari bawah ke rail |

---

## Rencana Database Firebase

Firebase belum aktif pada prototipe ini. Rencana koleksi Cloud Firestore pasca-UTS:

| Koleksi | Field utama | Kegunaan |
|---|---|---|
| `users` | `uid`, `nama`, `email`, `role`, `createdAt` | Autentikasi dan peran petugas |
| `calon_penerima` | `id`, `namaLabel`, `dusun`, `catatan`, `statusVerifikasi`, `createdAt`, `updatedAt` | Data calon |
| `penilaian` | `id`, `calonId`, `nilaiKriteria[7]`, `penilaiUid`, `updatedAt` | Nilai 7 kriteria |
| `kriteria_bobot` | `kode`, `nama`, `bobot`, `versi` | Konfigurasi kriteria dan bobot |
| `hasil_prioritas` | `id`, `calonId`, `skor`, `peringkat`, `periode`, `versiBobot`, `createdAt` | Hasil perhitungan |
| `riwayat_proses` (opsional) | `id`, `aksi`, `pelakuUid`, `waktu`, `ringkasan` | Audit trail |

Security rules akan dibatasi berdasarkan autentikasi dan peran pengguna.

---

## Struktur Project

```text
BLT-DD-prioritas-flutter/
├── android/              # Konfigurasi Android
├── build/web/            # Hasil build Flutter Web
├── docs/
│   ├── rancangan/        # Dokumen rancangan (persona, user story, flow, wireframe, dll.)
│   └── screenshots/      # Screenshot runtime dan preview desain
├── lib/
│   ├── core/
│   │   └── theme.dart    # Tema, warna, dan tipografi aplikasi
│   ├── data/
│   │   └── data_simulasi.dart  # Data calon simulasi
│   ├── models/
│   │   └── candidate_model.dart  # Model calon dan perhitungan skor
│   ├── pages/
│   │   ├── app_shell.dart
│   │   ├── beranda_page.dart
│   │   ├── data_calon_page.dart
│   │   ├── hasil_prioritas_page.dart
│   │   ├── login_page.dart
│   │   └── penilaian_page.dart
│   ├── widgets/
│   │   └── app_widgets.dart  # Widget reusable
│   └── main.dart
├── test/
│   └── widget_test.dart  # Widget test login
├── tools/
│   └── take_screenshots.py  # Script Playwright untuk screenshot otomatis
├── pubspec.yaml
└── README.md
```

---

## Cara Menjalankan

### Prasyarat

- Flutter SDK stabil (mendukung Dart 3.3+)
- Chrome untuk menjalankan versi web
- Git untuk mengelola repository

### Perintah

```bash
flutter doctor
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
```

Untuk build web:

```bash
flutter build web
```

Untuk Android, siapkan Android Studio/Android SDK lalu jalankan:

```bash
flutter run
```

### Regenerasi Screenshot

```bash
flutter build web
python tools/take_screenshots.py
```

Script menggunakan query parameter `?page=N` untuk navigasi otomatis demi kebutuhan screenshot. Ini bukan fitur aplikasi bagi pengguna akhir.

---

## Screenshot

### Runtime Flutter Web

| Login | Beranda |
|---|---|
| ![Login web](docs/screenshots/01-web-login.png) | ![Beranda web](docs/screenshots/01-web-beranda.png) |

| Data Calon | Form Tambah Calon |
|---|---|
| ![Data calon](docs/screenshots/03-data-calon-web.png) | ![Form calon](docs/screenshots/04-form-calon-web.png) |

| Penilaian & Prioritas | Hasil Prioritas |
|---|---|
| ![Penilaian](docs/screenshots/05-penilaian-web.png) | ![Hasil prioritas](docs/screenshots/06-hasil-prioritas-web.png) |

### Runtime Mobile

| Login Mobile | Beranda Mobile |
|---|---|
| ![Login mobile](docs/screenshots/07-mobile-login.png) | ![Beranda mobile](docs/screenshots/07-mobile-beranda.png) |

### Preview Rancangan Awal

Preview desain sebelum implementasi tersedia di folder `docs/screenshots/` dengan nama `*-preview.png`.

---

## Daftar Pekerjaan Setelah UTS

1. **Selaraskan kriteria dan bobot** dengan arahan dosen serta ketentuan yang berlaku.
2. **Integrasi Firebase Authentication** untuk login petugas yang aman.
3. **Hubungkan CRUD ke Cloud Firestore** agar data persisten.
4. **Terapkan security rules** berbasis autentikasi dan peran.
5. **Tambahkan validasi data lapangan** dan status verifikasi calon.
6. **Uji ulang alur** secara manual dan otomatis.
7. **Deploy web** melalui Firebase Hosting bila diperlukan.

---

## Referensi Rancangan

- Presentasi UTS: `BLT-DD_Prioritas_Presentasi_UTS.pptx`
- Wireframe Figma: https://www.figma.com/make/xnbomh0HD3xaMEtZ0ehUwh/BLT-DD-Prioritas-Wireframe
- Dokumen rancangan: [`docs/rancangan/`](docs/rancangan/)
