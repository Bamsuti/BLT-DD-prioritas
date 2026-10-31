# Panduan Demonstrasi Presentasi UTS

Dokumen ini adalah skenario demonstrasi. Status di bawah mencerminkan apa yang **sudah** dijalankan pada lingkungan pengembangan (Windows, Flutter 3.47.7) dan apa yang masih perlu dilakukan saat presentasi.

## 1. Proposal — masalah, pengguna, scope

Buka [docs/proposal/PROPOSAL_UTS.pdf](proposal/PROPOSAL_UTS.pdf). Jelaskan latar belakang masalah, persona petugas pengelola data BLT-DD, sembilan user story, kebutuhan K-01–K-08, user flow, sitemap, lima wireframe, tech stack, dan rancangan Firestore. Tegaskan batasan: tidak menangani pencairan dana, tidak terintegrasi ke sistem pemerintah, tidak memakai data warga nyata, dan tidak menggantikan musyawarah. Peta kesesuaian butir UTS ada di [docs/UTS_CHECKLIST.md](UTS_CHECKLIST.md).

## 2. Desain

Buka `PERSONA.md`, `USER_STORY.md`, `USER_FLOW.md`, `SITEMAP.md`, `WIREFRAME.md`, lalu `docs/screenshots/runtime/`. Tunjukkan lima halaman, alur login berhasil/gagal, validasi form, dan hubungan kebutuhan dengan fitur. Wireframe SVG adalah rancangan awal; screenshot di `runtime/` adalah bukti implementasi. Wawancara pengguna belum diklaim dilakukan. Tautan Figma: [BLT-DD Prioritas — Wireframe](https://www.figma.com/make/xnbomh0HD3xaMEtZ0ehUwh/BLT-DD-Prioritas-Wireframe?t=xP6ZZ7tKgaItZh19-1).

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
5. Buka Data Calon Penerima, tambah calon dengan ID simulasi unik dan nama fiktif, isi tujuh nilai.
6. Ubah calon dan tunjukkan skor berubah di daftar.
7. Buka dialog hapus, tekan Batal, lalu ulangi dan konfirmasi penghapusan.
8. Buka Penilaian & Prioritas: tunjukkan tujuh kriteria dan bobot demo 20/15/15/15/10/10/15.
9. Buka Hasil Prioritas: jelaskan rumus SAW — sebutkan sebagai *Simple Additive Weighting* — (`r = nilai/5`, `V = Σ bobot×r`, skor = V×100) dan urutan menurun.
10. Perkecil jendela browser melewati 760 px untuk memperlihatkan `NavigationRail` berubah menjadi `NavigationBar`.
11. Tekan Keluar dan pastikan kembali ke Login.

Catatan: mode demo menyimpan data di memori; reload mengembalikan data contoh. Jangan menyatakan Firestore berhasil jika Firebase belum aktif dan diuji.

## 4. Repository dan bukti

Buka repository GitHub, `README.md`, `lib/`, `test/`, `docs/`, `firestore.rules`, dan riwayat commit. Demo web tersedia di https://bamsuti.github.io/BLT-DD-prioritas/ (mode demo, bukan Firebase). Tunjukkan bahwa:

- 24 test otomatis lulus (`flutter test`);
- build Web berhasil dan screenshot runtime tersedia;
- proposal PDF sembilan halaman dan video 5:07 tersedia di `docs/`;
- kode Firebase bersyarat dan belum diuji dengan project nyata;
- tidak ada kredensial, token, atau data warga di repository.

## Checklist presentasi

- [x] Scaffold Android/Web tersedia dan diperiksa strukturnya.
- [x] `flutter pub get`, `flutter analyze`, `flutter test` dijalankan; hasil dicatat di `docs/PENGUJIAN.md`.
- [x] Build Web berhasil.
- [x] Screenshot runtime diambil dari build Web (desktop dan mobile).
- [x] Proposal UTS PDF lengkap (masalah, persona, sembilan user story, kebutuhan, user flow, sitemap, wireframe, tech stack, Firestore).
- [x] Video presentasi delapan babak dirender (5:07, 1080p, narasi TTS, demo runtime asli).
- [x] Video menjawab empat pertanyaan wajib (masalah, pengguna, prioritas, penyimpanan data).
- [x] Build web diterbitkan di GitHub Pages dan halaman login terverifikasi terbuka.
- [x] Skenario uji mode demo diisi hasil aktual.
- [x] Bobot dan interpretasi ditandai sebagai simulasi.
- [x] Tidak ada data pribadi atau rahasia konfigurasi di repository.
- [x] APK debug berhasil dibangun melalui GitHub Actions (run #7).
- [ ] Demo berjalan di perangkat Android fisik (APK belum diinstal/diuji di perangkat).
- [ ] Firebase Auth + Firestore diuji dengan project nyata.
- [ ] Firebase Hosting di-deploy.
