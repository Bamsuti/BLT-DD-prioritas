# Panduan Demonstrasi Presentasi UTS

Dokumen ini adalah skenario demonstrasi. Status di bawah mencerminkan apa yang **sudah** dijalankan pada lingkungan pengembangan (Windows, Flutter 3.47.7) dan apa yang masih perlu dilakukan saat presentasi.

## 1. Proposal — masalah, pengguna, scope

Buka [docs/proposal/PROPOSAL_UTS.pdf](proposal/PROPOSAL_UTS.pdf). Jelaskan latar belakang masalah, persona petugas pengelola data BLT-DD, sembilan user story, kebutuhan K-01–K-08, user flow, sitemap, lima wireframe, tech stack, dan rancangan Firestore. Tegaskan batasan: tidak menangani pencairan dana, tidak terintegrasi ke sistem pemerintah, tidak memakai data warga nyata, dan tidak menggantikan musyawarah. Peta kesesuaian butir UTS ada di [docs/UTS_CHECKLIST.md](UTS_CHECKLIST.md).

## 2. Desain

Buka `PERSONA.md`, `USER_STORY.md`, `USER_FLOW.md`, `SITEMAP.md`, `WIREFRAME.md`, lalu `docs/screenshots/runtime/`. Tunjukkan lima halaman, alur login berhasil/gagal, validasi form, dan hubungan kebutuhan dengan fitur. Wireframe SVG adalah rancangan awal; screenshot di `runtime/` adalah bukti implementasi. Wawancara pengguna belum diklaim dilakukan. Pengujian fungsional dilakukan mandiri oleh pembuat, tanpa menunggu pengujian petugas desa. Tautan Figma: [BLT-DD Prioritas — Wireframe](https://www.figma.com/make/xnbomh0HD3xaMEtZ0ehUwh/BLT-DD-Prioritas-Wireframe?t=xP6ZZ7tKgaItZh19-1).

## 3. Demo Flutter

Persiapan (sudah diverifikasi di lingkungan ini):

```bash
flutter pub get
flutter analyze    # No issues found!
flutter test       # 24 test, All tests passed!
flutter run -d chrome
```

Langkah demonstrasi:

1. Tunjukkan hasil `flutter analyze` dan `flutter test` dari terminal.
2. Buka Login. Tunjukkan label **Mode demo**, coba email kosong/format salah, lalu login dengan akun demo.
3. Jelaskan bahwa mode demo bukan Firebase Authentication.
4. Tunjukkan ringkasan Beranda: 5 calon, 7 kriteria, dan tiga skor tertinggi (SIM-001 = 85,0).
5. Buka Data Calon Penerima, tekan **Tambah calon**, lalu langsung tekan **Simpan** — tunjukkan tiga pesan validasi per kolom dan data tidak tersimpan. Isi ID simulasi unik (`SIM-006`), nama fiktif, dusun, dan tujuh nilai; tekan **Simpan** — tunjukkan SnackBar "Data … tersimpan." dan baris baru di daftar.
6. Ubah calon dan tunjukkan skor berubah di daftar.
7. Buka dialog hapus, tekan Batal, lalu ulangi dan konfirmasi penghapusan. Hapus seluruh data untuk memperlihatkan empty state "Belum ada data".
8. Buka Penilaian & Prioritas: tunjukkan tujuh kriteria dan bobot demo 20/15/15/15/10/10/15.
9. Buka Hasil Prioritas: jelaskan rumus SAW — sebutkan sebagai *Simple Additive Weighting* — (`r = nilai/5`, `V = Σ bobot×r`, skor = V×100) dan urutan menurun.
10. Perkecil jendela browser melewati 760 px untuk memperlihatkan `NavigationRail` berubah menjadi `NavigationBar`.
11. Tekan Keluar dan pastikan kembali ke Login.

Catatan: mode demo menyimpan data di memori; reload mengembalikan data contoh. Jangan menyatakan Firestore berhasil jika Firebase belum aktif dan diuji.

## 3a. Persiapan pertanyaan klarifikasi (Q5–Q7)

**Q5 — Tunjukkan satu validasi, aturan bisnisnya, dan kaitkan dengan user story.**
Buka form tambah, tekan Simpan kosong. Pesan "ID simulasi wajib diisi.", "Nama calon wajib diisi.", dan "Dusun/kelompok wajib diisi." muncul per kolom. Aturan bisnis: calon hanya boleh tersimpan bila memiliki kode simulasi unik, nama, dusun, dan tujuh nilai 1–5. Ini adalah kriteria penerimaan **US-03** ("ID simulasi, nama, dusun, dan tujuh nilai wajib; ID duplikat ditolak; setelah simpan calon tampil"). Setelah data valid disimpan, SnackBar "tersimpan" muncul dan baris baru tampil.

**Q6 — Apa yang terjadi bila formulir kosong atau nilai di luar rentang?**
Kosong: Simpan diblokir dan setiap kolom wajib memberi pesan sendiri. Nilai di luar 1–5 tidak dapat diketik karena memakai dropdown 1–5 (nilai awal 3). Kode simulasi duplikat ditolak dengan pesan "ID simulasi sudah digunakan."; catatan dibatasi 200 karakter.

**Q7 — Apa yang belum selesai dan rencananya sebelum UAS?**
Belum selesai: project Firebase nyata (Spark), Auth + role, pengujian rules di Emulator Suite, penyimpanan Firestore, deploy Hosting, dan uji APK di perangkat. Rencana Pertemuan 9–15: hubungkan project Firebase → buat akun dan role → uji security rules → pindahkan CRUD ke Firestore → deploy Hosting → uji APK → konsultasi bobot/istilah. Rincian ada di proposal bagian 11.

## 4. Repository dan bukti

Buka repository GitHub, `README.md`, `lib/`, `test/`, `docs/`, `firestore.rules`, dan riwayat commit. Demo web tersedia di https://bamsuti.github.io/BLT-DD-prioritas/ (mode demo, bukan Firebase). Tunjukkan bahwa:

- 24 test otomatis lulus (`flutter test`);
- build Web berhasil dan screenshot runtime tersedia;
- proposal PDF dan video 6:15 tersedia di `docs/`;
- kode Firebase bersyarat dan belum diuji dengan project nyata;
- tidak ada kredensial, token, atau data warga di repository.

## Checklist presentasi

- [x] Scaffold Android/Web tersedia dan diperiksa strukturnya.
- [x] `flutter pub get`, `flutter analyze`, `flutter test` dijalankan; hasil dicatat di `docs/PENGUJIAN.md`.
- [x] Build Web berhasil.
- [x] Screenshot runtime diambil dari build Web (desktop dan mobile).
- [x] Proposal UTS PDF lengkap (masalah, persona, sembilan user story, kebutuhan, user flow, sitemap, wireframe, tech stack, Firestore).
- [x] Video presentasi delapan babak dirender (6:15, 1080p, narasi TTS, demo runtime asli termasuk form valid + SnackBar); tautan YouTube <https://youtu.be/AnvDqdBBxeM> masih versi 5:07 dan perlu diunggah ulang.
- [x] Video menjawab empat pertanyaan wajib (masalah, pengguna, prioritas, penyimpanan data).
- [x] Build web diterbitkan di GitHub Pages dan halaman login terverifikasi terbuka.
- [x] Skenario uji mode demo diisi hasil aktual.
- [x] Bobot dan interpretasi ditandai sebagai simulasi.
- [x] Tidak ada data pribadi atau rahasia konfigurasi di repository.
- [x] APK debug berhasil dibangun melalui GitHub Actions (run #7).
- [ ] Demo berjalan di perangkat Android fisik (APK belum diinstal/diuji di perangkat).
- [ ] Firebase Auth + Firestore diuji dengan project nyata.
- [ ] Firebase Hosting di-deploy.
