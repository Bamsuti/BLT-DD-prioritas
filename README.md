# BLT-DD Prioritas

Perancangan Aplikasi Penentuan Prioritas Calon Penerima BLT-DD Berbasis Cross-Platform Menggunakan Flutter dan Firebase.
Proyek individu MK Mobile and Web Application Development (Ganjil 2026/2027).

## Identitas
- Nama: Nabhan Miqdad Mubarok
- NIM: 23.01.55.0017
- Kelas: A1

## Masalah, pengguna, scope
- **Masalah:** pengolahan dan penentuan prioritas calon penerima BLT-DD masih manual (spreadsheet), lama dan sulit ditelusuri.
- **Pengguna utama:** petugas pengelola data BLT-DD di pemerintah desa (persona berbasis asumsi, belum divalidasi wawancara).
- **Fitur Must:** login, kelola data calon penerima, penilaian kriteria, hasil ranking prioritas, tampilan responsif Android + Web.
- **Batasan:** data simulasi, tidak menyalurkan bantuan, tidak terhubung sistem pemerintah, tanpa billing.

## Tautan
- Desain Figma: https://www.figma.com/make/xnbomh0HD3xaMEtZ0ehUwh/BLT-DD-Prioritas-Wireframe
- Video proposal: (isi tautan)

## Halaman
Login · Beranda · Data Calon Penerima · Penilaian & Prioritas · Hasil Prioritas
(menu utama: Beranda, Data Calon Penerima, Hasil Prioritas; form tambah/edit berupa dialog)

## Cara menjalankan
```bash
flutter pub get
flutter run -d chrome
```

## Screenshot
| Login | Beranda | Data Calon |
|---|---|---|
| ![Login](docs/screenshot-login.png) | ![Beranda](docs/screenshot-beranda.png) | ![Data Calon](docs/screenshot-data-calon.png) |

| Penilaian & Prioritas (form) | Hasil Prioritas |
|---|---|
| ![Penilaian](docs/screenshot-penilaian.png) | ![Hasil](docs/screenshot-hasil.png) |

## Pengujian form (data simulasi)
| # | Kasus | Hasil diharapkan | Status |
|---|---|---|---|
| 1 | Semua kosong | Semua kolom wajib menampilkan pesan | Sesuai |
| 2 | Pendapatan kosong, tanggungan 0 | Dua pesan kesalahan | Sesuai |
| 3 | Catatan > 200 karakter | "Maksimal 200 karakter" | Sesuai |
| 4 | Kondisi rumah kosong | "Pilih kondisi rumah" | Sesuai |
| 5 | Semua valid | SnackBar berhasil, data tampil di Hasil Prioritas | Sesuai |

## Rencana database (Cloud Firestore, paket Spark)
| Koleksi | Field utama |
|---|---|
| users | uid, email, nama, peran, dibuat_pada |
| calon_penerima | nama, nik (simulasi), alamat, dibuat_pada, diubah_pada |
| penilaian | calon_id, penghasilan, tanggungan, dinding, lantai, air, penerangan, tabungan, catatan, status_lengkap, diinput_pada |
| kriteria_bobot | kode, nama, jenis, bobot |
| hasil_prioritas | calon_id, skor_akhir, peringkat, dihitung_pada, proses_id |

## Status dan batasan prototype
- Data tersimpan di memori (hilang saat dimuat ulang); belum terhubung Firebase.
- Keputusan terbuka: 7 kriteria (Minggu 2) vs 5 kolom form (Minggu 7) akan diselaraskan.
- Belum ada kasus uji untuk login gagal.

## Rencana setelah UTS
1. Perbaiki hasil dari umpan balik. 2. Hubungkan Firebase (Auth, Firestore, Hosting). 3. Kelola data dan proses bisnis inti.
