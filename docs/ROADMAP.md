# Roadmap BLT-DD Prioritas

Status dibedakan antara artefak yang sudah diverifikasi dan pekerjaan yang masih terbuka.

## Selesai dan terverifikasi

- [x] Model tujuh kriteria, bobot demo total 100%, dan rumus SAW.
- [x] Lima halaman: Login, Beranda, Data Calon, Penilaian, Hasil Prioritas.
- [x] CRUD calon dengan dialog form tujuh kriteria, validasi, dan konfirmasi hapus.
- [x] Navigasi responsif (`NavigationRail` ≥ 760 px, `NavigationBar` < 760 px).
- [x] Mode demo terpisah dari Firebase dengan label yang jelas.
- [x] `flutter analyze` bersih dan 24 test otomatis lulus.
- [x] Build Web berhasil; 14 screenshot runtime desktop/mobile.
- [x] Scaffold Android (Gradle Kotlin DSL) dan izin INTERNET.
- [x] Dokumentasi rancangan, Firebase, pengujian, presentasi, dan roadmap.
- [x] Draft rules berbasis autentikasi + role tanpa akses publik.

## Berikutnya (butuh konfigurasi/keputusan)

- [ ] Buat project Firebase dan isi konfigurasi client melalui `--dart-define`.
- [ ] Aktifkan Email/Password, buat akun uji, dan set dokumen `users/{uid}.role`.
- [ ] Uji Auth + CRUD Firestore dan tinjau hasilnya di Console.
- [ ] Uji `firestore.rules` di Firebase Emulator Suite (user tanpa role, role petugas, tulis `users`).
- [ ] Build dan uji APK pada perangkat/emulator Android.
- [ ] Deploy Firebase Hosting dan uji URL publik.
- [ ] Verifikasi hasil GitHub Actions setelah push.

## Pengembangan lanjutan

- [ ] Simpan snapshot `hasil_prioritas` per periode dan versi bobot.
- [ ] Tambahkan audit trail perubahan nilai.
- [ ] Validasi persona, istilah, subkriteria, arah benefit/cost, dan bobot bersama dosen/petugas.
- [ ] Tambahkan pengujian aksesibilitas dan performa.
- [ ] Ekspor laporan (PDF/Excel) bila dibutuhkan.

Tidak ada klaim Firebase aktif, Hosting ter-deploy, atau build Android berhasil sampai pekerjaan tersebut benar-benar dijalankan dan dicatat.
