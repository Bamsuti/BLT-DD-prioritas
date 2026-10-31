# Checklist Kesesuaian UTS

Dokumen ini memetakan setiap butir ketentuan UTS ke bukti yang benar-benar ada di repository. Status ditulis apa adanya: yang sudah dikerjakan ditandai selesai, yang belum ditandai belum.

## 1. Tiga keluaran wajib

| Keluaran | Bukti | Status |
|---|---|---|
| Video presentasi maksimal 10 menit dan dapat dibuka dosen | [`docs/video/blt-dd-prioritas-promo.mp4`](video/blt-dd-prioritas-promo.mp4), 5 menit 7 detik, 1080p, narasi Bahasa Indonesia | Selesai |
| Proposal PDF | [`docs/proposal/PROPOSAL_UTS.pdf`](proposal/PROPOSAL_UTS.pdf) — 9 halaman | Selesai |
| Repository GitHub | <https://github.com/Bamsuti/BLT-DD-prioritas> — README, kode, test, dokumen, riwayat commit bertahap | Selesai |

Video juga dapat diputar langsung dari repository (raw GitHub) setelah commit terakhir. Tautan demo web: <https://bamsuti.github.io/BLT-DD-prioritas/>.

## 2. Isi proposal

Setiap butir ketentuan proposal ada di `docs/proposal/PROPOSAL_UTS.pdf` dan juga tersedia sebagai HTML sumbernya.

| Ketentuan | Lokasi di proposal | Status |
|---|---|---|
| Problem statement | Bagian 2 "Latar belakang dan masalah" | Ada |
| Persona pengguna | Bagian 5 "Persona pengguna utama" | Ada |
| Minimal 5 user story | Bagian 6, sembilan user story (US-01 … US-09) dengan kriteria penerimaan | Ada, melebihi minimum |
| Functional requirements | Bagian 7, K-01 … K-08 dalam tabel | Ada |
| User flow | Bagian 8, diagram alur login → beranda → data calon → penilaian → hasil | Ada |
| Sitemap | Bagian 9; versi Mermaid di [`docs/rancangan/SITEMAP.md`](rancangan/SITEMAP.md) | Ada |
| Wireframe / tautan Figma | Bagian 10, lima SVG wireframe tertanam di PDF | Ada sebagai SVG |
| Tech stack | Bagian 11 (Flutter, Dart, Firebase, GitHub Actions) | Ada |
| Rancangan database Firestore | Bagian 12, koleksi `calon_penerima` dan `users` beserta field | Ada |

**Catatan kejujuran Figma:** proyek ini **tidak memakai Figma** karena tidak ada berkas Figma yang benar-benar dibuat. Wireframe asli berupa SVG di `docs/screenshots/` dan ditampilkan di PDF. Proposal menyatakan hal ini secara eksplisit; tidak ada tautan Figma yang dibuat-buat. SVG dapat diimpor ke Figma bila dosen meminta kanal tersebut.

## 3. Isi video

Durasi total 5 menit 7 detik (307,16 detik) — di bawah batas 10 menit. Narasi dihasilkan Edge TTS `id-ID-ArdiNeural`; **SAW** ditulis SAW di layar dan diucapkan "Simple Additive Weighting" dalam narasi.

| Waktu | Bagian yang diminta | Isi |
|---|---|---|
| 00:00–00:27 | Pembuka | Nama, NIM, kelas, judul lengkap aplikasi |
| 00:27–01:02 | Masalah & pengguna | Data tersebar, penilaian manual, riwayat sulit ditelusuri; pengguna utama petugas pengelola data BLT-DD desa |
| 01:02–01:50 | Kebutuhan & prioritas fitur | Lima kebutuhan K-01…K-05; prioritas 1 CRUD + validasi, prioritas 2 penilaian SAW, pendukung login/responsif/Firebase |
| 01:50–02:31 | Desain | User flow, sitemap, tiga wireframe, aturan navigasi 760 px |
| 02:31–03:17 | Demo prototipe berjalan | Rekaman runtime: login → beranda → data calon → form kosong ditolak → penilaian → hasil |
| 03:17–03:30 | Tampilan responsif | Rekaman mobile 390×844 dengan navigasi bawah |
| 03:30–04:21 | Rencana teknis & data | Arsitektur Flutter → model SAW → backend → Firebase; skema Firestore `calon_penerima` dan `users`; catatan Firebase belum terhubung |
| 04:21–05:07 | Empat jawaban & penutup | Ringkasan empat pertanyaan, disclaimer simulasi, tautan repositori |

Demonstrasi memakai rekaman aplikasi yang benar-benar dijalankan di GitHub Pages (`video/public/demo/desktop.mp4` 41,7 detik dan `mobile.mp4` 15,6 detik), bukan mockup.

## 4. Empat pertanyaan wajib

| Pertanyaan | Jawaban di video | Bagian |
|---|---|---|
| Masalah apa yang diselesaikan? | Pendataan calon dan penilaian tersebar di spreadsheet, perhitungan diulang dengan cara berbeda, riwayat sulit ditelusuri | 00:27 dan 04:21 |
| Siapa pengguna utama? | Petugas pengelola data BLT-DD di tingkat desa yang mendata calon, memperbarui nilai, dan menyiapkan bahan musyawarah | 00:27 dan 04:21 |
| Mengapa fitur diprioritaskan demikian? | Kualitas data (CRUD + validasi) lebih dulu karena menjadi dasar skor; penilaian SAW berikutnya; login, responsif, dan Firebase bersifat pendukung | 01:02 dan 04:21 |
| Bagaimana data disimpan? | Firebase Authentication untuk akun dan Cloud Firestore untuk `calon_penerima` + `users`; akses dibatasi role lewat `firestore.rules` | 03:30 dan 04:21 |

## 5. Ketentuan teknis aplikasi

| Ketentuan | Bukti | Status |
|---|---|---|
| Android + Web dari satu basis kode Flutter | `lib/` dipakai keduanya; scaffold `android/`, build Web Pages aktif | Selesai |
| Lebih dari 3 halaman | Login, Beranda, Data Calon, Penilaian, Hasil (5 halaman) | Selesai |
| CRUD | Tambah, ubah, hapus, lihat pada Data Calon | Selesai, diuji otomatis |
| Formulir valid dan dapat diuji | Validasi ID simulasi, nama, dusun, ID duplikat, tujuh nilai; 7 skenario uji | Selesai |
| Firebase Auth + Firestore bersyarat | Kode aktif hanya bila `--dart-define` lengkap; jika tidak, mode demo | Kode siap, **belum dihubungkan/diuji** |
| Tujuh kriteria konsisten | `C1`–`C7` dengan bobot 20/15/15/15/10/10/15 = 100% di model, halaman, test, dan dokumen | Selesai |
| Lima halaman sesuai rancangan | Sama dengan sitemap dan user flow | Selesai |
| Responsif pada 760 px | `NavigationBar` < 760 px, `NavigationRail` ≥ 760 px; screenshot dua viewport | Selesai, diuji otomatis |
| Minimal 15 skenario uji | `test/widget_test.dart` berisi 24 test otomatis + matriks manual di `docs/PENGUJIAN.md` | Selesai |
| Status jujur | README, proposal, video, dan checklist menandai Firebase belum terhubung, Android belum diuji di perangkat, Figma tidak dipakai | Selesai |
| Dokumentasi Bahasa Indonesia | README dan seluruh `docs/` berbahasa Indonesia | Selesai |
| Commit bermakna | Riwayat `git log` bertahap per fitur/dokumen | Selesai |
| Laporan akhir | `docs/proposal/PROPOSAL_UTS.pdf` | Selesai |

## 6. Yang belum dikerjakan (dinyatakan terbuka)

| Butir | Alasan |
|---|---|
| Firebase Auth + Firestore diuji dengan project nyata | Belum ada project Firebase dan akun uji; tidak boleh diklaim sebelum dijalankan |
| Firebase Hosting | Belum di-deploy; web berjalan di GitHub Pages |
| APK dijalankan di perangkat/emulator | APK debug hanya dibangun di CI, belum diinstal |
| Figma | Tidak ada berkas Figma; wireframe berupa SVG |
| Wawancara/validasi persona dengan petugas desa | Persona masih asumsi akademik |
| Validasi bobot dan formula dengan dosen/pihak desa | Bobot masih simulasi |

## 7. Cara memeriksa ulang

```bash
flutter pub get
flutter analyze          # harus "No issues found!"
flutter test             # 24 test harus lulus
flutter build web
cd video && npm run typecheck && npm run render
```

Video hasil render ada di `docs/video/blt-dd-prioritas-promo.mp4`; proposal di `docs/proposal/PROPOSAL_UTS.pdf`.
