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
| (<img width="152" height="344" alt="image" src="https://github.com/user-attachments/assets/efb4b9c3-908b-4d77-91d9-b35ec0ae21a1" />
) |(<img width="152" height="344" alt="image" src="https://github.com/user-attachments/assets/d2893e70-d0e4-41cd-b4b3-257d6988ebb1" />
) |(<img width="151" height="344" alt="image" src="https://github.com/user-attachments/assets/aacb048e-6ed1-4f1c-a671-124d092c8333" />
) |

| Penilaian & Prioritas (form) | Hasil Prioritas |
|---|---|
|(<img width="150" height="344" alt="image" src="https://github.com/user-attachments/assets/0bd0f40e-d518-43e1-b846-0b4c75d11a1a" />
) |(<img width="150" height="344" alt="image" src="https://github.com/user-attachments/assets/be60f64d-aa37-4003-9c66-e8916dbd6749" />
) |

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
