# Rencana Pengujian

## Keterbatasan lingkungan
Flutter SDK dan Dart tidak tersedia saat pembaruan ini. Perintah flutter pub get, flutter analyze, flutter test, flutter run, build, dan deploy belum dijalankan. Test file yang ditambahkan bukan bukti tes sudah lulus.

## Matriks skenario

| ID | Skenario | Hasil yang diharapkan | Aktual | Status | Bukti |
|---|---|---|---|---|---|
| T-01 | Email kosong | Validasi email wajib | Belum dijalankan | Belum diuji | — |
| T-02 | Email format salah | Validasi format tampil | Belum dijalankan | Belum diuji | — |
| T-03 | Kredensial Firebase salah | Tetap di login, pesan gagal | Perlu Firebase aktif | Belum diuji | — |
| T-04 | Nama calon kosong | Simpan ditolak | Belum dijalankan | Belum diuji | — |
| T-05 | ID simulasi kosong | Simpan ditolak | Belum dijalankan | Belum diuji | — |
| T-06 | ID simulasi duplikat | ID duplikat ditolak | Belum dijalankan | Belum diuji | — |
| T-07 | Tambah calon valid | Data muncul di daftar | Belum dijalankan | Belum diuji | — |
| T-08 | Ubah calon | Data daftar dan nilai diperbarui | Belum dijalankan | Belum diuji | — |
| T-09 | Batal hapus | Data tetap tersedia | Belum dijalankan | Belum diuji | — |
| T-10 | Konfirmasi hapus | Data hilang setelah operasi berhasil | Belum dijalankan | Belum diuji | — |
| T-11 | Nilai kriteria kosong | Form meminta nilai wajib | Belum dijalankan | Belum diuji | — |
| T-12 | Ubah nilai kriteria | Skor dihitung ulang | Belum dijalankan | Belum diuji | — |
| T-13 | Urutan ranking | Skor tertinggi pada urutan pertama | Belum dijalankan | Belum diuji | — |
| T-14 | Navigasi empat menu | Semua halaman terbuka | Belum dijalankan | Belum diuji | — |
| T-15 | Responsif di bawah/atas 760 px | Navigasi bawah/rail sesuai | Belum dijalankan | Belum diuji | — |
| T-16 | Firestore/koneksi gagal | Pesan error dan coba lagi tersedia | Perlu Firebase aktif | Belum diuji | — |
| T-17 | CRUD Firestore | Perubahan tercermin di daftar dan Console | Perlu Firebase aktif | Belum diuji | — |
| T-18 | Logout | Sesi ditutup, Login tampil | Belum dijalankan | Belum diuji | — |

## Test otomatis
test/widget_test.dart mencakup validasi email kosong, email salah, total bobot demo 100%, dan rentang skor. Jalankan pada komputer dengan Flutter SDK: flutter pub get, flutter analyze, flutter test. Simpan keluaran terminal aktual dan perbaiki error sebelum memberi status Lulus.

## Screenshot
Folder docs/screenshots berisi wireframe SVG, bukan screenshot runtime. Setelah aplikasi benar-benar dijalankan, simpan screenshot login, beranda, daftar, form validasi, penilaian, hasil, dan layar sempit/lebar. Jangan mengklaim screenshot runtime sebelum diambil langsung dari aplikasi yang berjalan.
