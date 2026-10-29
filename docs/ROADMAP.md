# Roadmap BLT-DD Prioritas

Status berikut membedakan file/kode yang disiapkan dengan verifikasi runtime.

## Selesai sebagai artefak repository
- [x] README serta dokumen kebutuhan, persona, story, flow, wireframe, database, Firebase, pengujian, presentasi dan roadmap.
- [x] Model tujuh kriteria dengan bobot demo total 100%.
- [x] Kode lima halaman inti, form dan navigasi responsif.
- [x] Mode demo terpisah dari Firebase.
- [x] Kode Auth email/password dan CRUD Firestore yang bersyarat konfigurasi.
- [x] Draft rules berdasarkan autentikasi dan role.

## Sedang dikerjakan / perlu verifikasi
- [ ] Jalankan flutter pub get, flutter analyze, flutter test, dan aplikasi nyata dengan Flutter SDK.
- [ ] Perbaiki kesalahan compile/runtime yang ditemukan.
- [ ] Hasilkan scaffold Android/Web dengan flutter create --platforms=android,web . dan tinjau file generator.
- [ ] Ambil screenshot runtime, lalu tautkan pada README.
- [ ] Lengkapi matriks uji dengan hasil aktual.

## Belum dimulai
- [ ] Test CRUD, duplikasi ID, konfirmasi hapus, ranking, responsive layout, dan koneksi gagal yang lebih lengkap.
- [ ] Uji integrasi Firestore melalui emulator atau akun uji.
- [ ] Menyimpan snapshot hasil per periode dan versi bobot jika dibutuhkan.
- [ ] Audit trail jika kebutuhan pengguna telah disepakati.

## Memerlukan konfigurasi/keputusan pengguna
- [ ] Buat/pilih Firebase project dan isi opsi client lokal.
- [ ] Aktifkan Email/Password, buat akun uji, dan set role melalui jalur tepercaya.
- [ ] Review dan uji rules sebelum deployment.
- [ ] Validasi persona/kebutuhan dengan petugas sasaran.
- [ ] Finalisasi subkriteria, skala, arah benefit/cost, bobot, dan formula.
- [ ] Putuskan model data dan snapshot hasil.
- [ ] Deploy Firebase Hosting setelah build dan pengujian lulus.

Tidak ada klaim wawancara, tes lulus, Firebase aktif, screenshot runtime, atau deployment tanpa bukti.
