# Panduan Demonstrasi Presentasi UTS

Ini adalah rencana demonstrasi, bukan catatan bahwa semua aksi sudah diuji.

## 1. Proposal — masalah, pengguna, scope
Buka README.md dan docs/rancangan/KEBUTUHAN.md. Jelaskan bahwa prototipe menggabungkan alur data calon, penilaian tujuh kriteria, dan peninjauan skor. Petugas pengelola data BLT-DD adalah persona asumsi awal yang masih perlu divalidasi. Tegaskan batasan: tidak menangani pencairan dana, tidak terintegrasi langsung ke sistem pemerintah, tidak menggunakan data warga nyata, dan tidak menggantikan musyawarah.

## 2. Desain
Buka PERSONA.md, USER_STORY.md, USER_FLOW.md, dan WIREFRAME.md. Tunjukkan lima halaman, alur login berhasil/gagal, validasi form, dan hubungan kebutuhan dengan fitur. Wireframe SVG adalah preview statis, bukan screenshot runtime. Wawancara pengguna belum diklaim dilakukan.

## 3. Demo Flutter
1. Jalankan flutter pub get, flutter analyze, dan flutter test; sebut hasil dari terminal yang terlihat.
2. Jalankan flutter run -d chrome atau perangkat Android.
3. Tunjukkan Login, validasi input, dan label Mode Demo/Firebase.
4. Mode demo: email demo@blt-dd.local dan kata sandi demo123.
5. Tunjukkan ringkasan Beranda, lalu Data Calon.
6. Tambahkan calon menggunakan ID simulasi unik, nama label sintetis, dusun, dan tujuh nilai.
7. Ubah calon dan tunjukkan hasilnya pada daftar.
8. Buka dialog hapus lalu Batal; ulangi dan konfirmasi penghapusan.
9. Tunjukkan tujuh kriteria dan bobot demo.
10. Tunjukkan hasil ranking dan jelaskan skor berasal dari data.
11. Resize browser ke bawah/atas 760 px untuk memperlihatkan navigasi.
12. Pilih Keluar dan pastikan kembali ke Login.

Mode demo menyimpan data di memori; reload dapat menghilangkannya. Jangan menyatakan Firestore berhasil jika Firebase belum aktif dan diuji.

## 4. Repository
Buka repository GitHub, README, lib, test, docs, firestore.rules, dan riwayat commit. Jelaskan mana yang berupa kode dan dokumentasi, dan bahwa koneksi Firebase baru diakui setelah layanan dites. Jangan menyebut tes/runtime/deployment yang tidak memiliki bukti.

## Checklist sebelum rekaman
- [ ] Scaffold Android/Web tersedia dan sudah diperiksa.
- [ ] flutter pub get, flutter analyze, flutter test selesai dan keluarannya dicatat.
- [ ] Demo berjalan di Chrome atau Android.
- [ ] Screenshot runtime diambil.
- [ ] Skenario uji diisi hasil aktual.
- [ ] Bobot dan interpretasi tetap ditandai simulasi sampai tervalidasi.
- [ ] Tidak ada data pribadi atau rahasia konfigurasi yang terlihat.
