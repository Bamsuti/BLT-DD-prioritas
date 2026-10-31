# Checklist Kesesuaian UTS

Dokumen ini memetakan setiap butir ketentuan UTS ke bukti yang benar-benar ada di repository. Status ditulis apa adanya: yang sudah dikerjakan ditandai selesai, yang belum ditandai belum.

## 1. Tiga keluaran wajib

| Keluaran | Bukti | Status |
|---|---|---|
| Video presentasi maksimal 10 menit dan dapat dibuka dosen | [`docs/video/blt-dd-prioritas-promo.mp4`](video/blt-dd-prioritas-promo.mp4), 6 menit 15 detik, 1080p, narasi Bahasa Indonesia; [YouTube](https://youtu.be/AnvDqdBBxeM) | Selesai |
| Proposal PDF | [`docs/proposal/PROPOSAL_UTS.pdf`](proposal/PROPOSAL_UTS.pdf) — 11 halaman | Selesai |
| Repository GitHub | <https://github.com/Bamsuti/BLT-DD-prioritas> — README, kode, test, dokumen, riwayat commit bertahap | Selesai |

Video dapat diunduh langsung dari repository (raw GitHub) dan diputar dengan pemutar video apa pun. Versi terbaru di repository berdurasi 6:15 (rekaman form valid + SnackBar); tautan YouTube <https://youtu.be/AnvDqdBBxeM> masih memuat versi 5:07 sebelumnya dan perlu diunggah ulang oleh mahasiswa karena proses unggah tidak dapat dilakukan dari lingkungan ini. Tautan demo web: <https://bamsuti.github.io/BLT-DD-prioritas/>.

### 1.1 Isi README repository

| Ketentuan README | Lokasi di `README.md` | Status |
|---|---|---|
| Identitas proyek (nama, NIM, kelas, mata kuliah, judul) | Bagian "Identitas proyek" | Ada |
| Deskripsi proyek | Bagian "Masalah dan tujuan" serta "Fitur yang tersedia" | Ada |
| Tautan Figma | Tabel identitas baris "Wireframe" dan bagian "Proposal UTS" | Ada |
| Petunjuk menjalankan | Bagian "Menjalankan aplikasi (mode demo)" dan "Konfigurasi Firebase" | Ada |
| Screenshot | Bagian "Screenshot runtime", 16 gambar desktop dan mobile | Ada |
| Riwayat commit bertahap | `git log --oneline` menampilkan commit terpisah per fitur/dokumen | Ada |

## 2. Isi proposal

Setiap butir ketentuan proposal ada di `docs/proposal/PROPOSAL_UTS.pdf` dan juga tersedia sebagai HTML sumbernya.

| Ketentuan | Lokasi di proposal | Status |
|---|---|---|
| Problem statement | Bagian 1 "Problem Statement", termasuk ruang lingkup dan empat pertanyaan kunci | Ada |
| Persona pengguna | Bagian 2 "Persona" | Ada |
| Minimal 5 user story | Bagian 3 "User Story", sembilan user story (US-01 … US-09) dengan kriteria penerimaan | Ada, melebihi minimum |
| Functional requirements | Bagian 4 "Kebutuhan Fungsional", K-01 … K-08 dalam tabel | Ada |
| User flow | Bagian 5 "User Flow", alur login → beranda → data calon → penilaian → hasil | Ada |
| Sitemap | Bagian 6 "Sitemap"; versi Mermaid di [`docs/rancangan/SITEMAP.md`](rancangan/SITEMAP.md) | Ada |
| Wireframe / tautan Figma | Bagian 7 "Wireframe", lima SVG tertanam di PDF, plus tautan Figma di bawah | Ada |
| Tech stack | Bagian 8 "Tech Stack" (Flutter, Dart, Firebase, GitHub Actions) | Ada |
| Rancangan database Firestore | Bagian 9 "Rancangan Database Firestore", koleksi `calon_penerima` dan `users` beserta field | Ada |

**Tautan Figma:** [BLT-DD Prioritas — Wireframe](https://www.figma.com/make/xnbomh0HD3xaMEtZ0ehUwh/BLT-DD-Prioritas-Wireframe?t=xP6ZZ7tKgaItZh19-1). Tautan ini disediakan pemilik proyek dan merespons HTTP 200 saat diperiksa. Lima SVG di `docs/screenshots/` tetap disertakan agar PDF dapat dibuka tanpa akses Figma.

## 3. Isi video

Durasi total 6 menit 15 detik (375,4 detik) — di bawah batas 10 menit. Narasi dihasilkan Edge TTS `id-ID-ArdiNeural`; **SAW** ditulis SAW di layar dan diucapkan "Simple Additive Weighting" dalam narasi.

| Waktu | Bagian yang diminta | Isi |
|---|---|---|
| 00:00–00:27 | Pembuka | Nama, NIM, kelas, judul lengkap aplikasi |
| 00:27–01:02 | Masalah & pengguna | Data tersebar, penilaian manual, riwayat sulit ditelusuri; pengguna utama petugas pengelola data BLT-DD desa |
| 01:02–02:06 | Kebutuhan & prioritas fitur | Lima user story utama (US-01, US-03, US-05, US-06, US-07) dan sembilan user story di proposal; kebutuhan K-01…K-08; **Must**: CRUD, validasi, penilaian tujuh kriteria, skor SAW; **Should**: login, ringkasan, responsif, status data |
| 02:06–02:52 | Desain | User flow, sitemap, wireframe Figma, aturan navigasi 760 px; implementasi mengikuti susunan wireframe |
| 02:52–03:47 | Demo prototipe berjalan | Rekaman runtime: login → beranda → data calon → Simpan kosong ditolak per kolom → isi ID/nama/dusun → SnackBar "tersimpan" → baris baru tampil → penilaian → hasil (SIM-006 masuk peringkat) |
| 03:47–04:00 | Tampilan responsif | Rekaman mobile 390×844 dengan navigasi bawah |
| 04:00–05:10 | Rencana teknis & data | Flutter → model SAW → backend → Firebase Spark; skema `calon_penerima` dan `users`; Hosting direncanakan; rencana Pertemuan 9–15 |
| 05:10–06:15 | Empat jawaban & penutup | Ringkasan empat pertanyaan, kendala dan pelajaran, disclaimer simulasi, tautan repositori |

Demonstrasi memakai rekaman aplikasi yang benar-benar dijalankan di GitHub Pages (`video/public/demo/desktop.mp4` 52,7 detik dan `mobile.mp4` 14,4 detik), bukan mockup.

## 4. Empat pertanyaan wajib

| Pertanyaan | Jawaban di video | Bagian |
|---|---|---|
| Masalah apa yang diselesaikan? | Pendataan calon dan penilaian tersebar di spreadsheet, perhitungan diulang dengan cara berbeda, riwayat sulit ditelusuri | 00:27 dan 05:10 |
| Siapa pengguna utama? | Petugas pengelola data BLT-DD di tingkat desa yang mendata calon, memperbarui nilai, dan menyiapkan bahan musyawarah | 00:27 dan 05:10 |
| Mengapa fitur diprioritaskan demikian? | Kualitas data (CRUD + validasi) lebih dulu karena menjadi dasar skor; penilaian SAW berikutnya; login, responsif, dan Firebase bersifat pendukung | 01:02 dan 05:10 |
| Bagaimana data disimpan? | Firebase Authentication untuk akun dan Cloud Firestore untuk `calon_penerima` + `users`; akses dibatasi role lewat `firestore.rules`; Hosting direncanakan | 04:00 dan 05:10 |

## 5. Ketentuan teknis aplikasi

| Ketentuan | Bukti | Status |
|---|---|---|
| Android + Web dari satu basis kode Flutter | `lib/` dipakai keduanya; scaffold `android/`, build Web Pages aktif | Selesai |
| Lebih dari 3 halaman | Login, Beranda, Data Calon, Penilaian, Hasil (5 halaman) | Selesai |
| CRUD | Tambah, ubah, hapus, lihat pada Data Calon | Selesai, diuji otomatis |
| Formulir valid dan dapat diuji | 4 kolom teks (ID, nama, dusun, catatan) + 7 dropdown kriteria = 2 jenis input; validasi per kolom; simpan valid memunculkan SnackBar dan baris baru; 5 widget test formulir, matriks manual T-09…T-17, serta tabel 8 kasus uji formulir di `docs/PENGUJIAN.md` | Selesai |
| Data simulasi dan empty state | Lima calon contoh `SIM-001`–`SIM-005`; setelah semua dihapus tampil "Belum ada data" dan petunjuk "Klik Tambah calon" (diuji otomatis) | Selesai |
| Firebase Auth + Firestore bersyarat | Kode aktif hanya bila `--dart-define` lengkap; jika tidak, mode demo | Kode siap, **belum dihubungkan/diuji** |
| Tujuh kriteria konsisten | `C1`–`C7` dengan bobot 20/15/15/15/10/10/15 = 100% di model, halaman, test, dan dokumen | Selesai |
| Lima halaman sesuai rancangan | Sama dengan sitemap dan user flow | Selesai |
| Responsif pada 760 px | `NavigationBar` < 760 px, `NavigationRail` ≥ 760 px; screenshot dua viewport | Selesai, diuji otomatis |
| Minimal 15 skenario uji | `test/widget_test.dart` berisi 24 test otomatis + matriks manual di `docs/PENGUJIAN.md` | Selesai |
| Pengujian mandiri oleh pembuat | Seluruh bukti dihasilkan dari mesin pembuat dan CI; tidak menunggu penguji eksternal atau petugas desa | Selesai |
| Status jujur | README, proposal, video, dan checklist menandai Firebase belum terhubung, Android belum diuji di perangkat, dan tautan Figma disertakan | Selesai |
| Dokumentasi Bahasa Indonesia | README dan seluruh `docs/` berbahasa Indonesia | Selesai |
| Commit bermakna | Riwayat `git log` bertahap per fitur/dokumen | Selesai |
| Laporan akhir | `docs/proposal/PROPOSAL_UTS.pdf` | Selesai |

## 6. Yang belum dikerjakan / di luar pengujian mandiri

Pengujian UTS dilakukan mandiri oleh pembuat dan tidak menunggu pengujian oleh petugas desa. Butir berikut adalah keterbatasan yang dinyatakan terbuka; dua butir terakhir bersifat validasi lapangan di luar lingkup pengujian.

| Butir | Alasan |
|---|---|
| Firebase Auth + Firestore diuji dengan project nyata | Belum ada project Firebase dan akun uji; tidak boleh diklaim sebelum dijalankan |
| Firebase Hosting | Belum di-deploy; web berjalan di GitHub Pages |
| APK dijalankan di perangkat/emulator | APK debug hanya dibangun di CI, belum diinstal |
| Validasi lapangan persona dengan petugas desa | Di luar lingkup pengujian mandiri; persona masih asumsi akademik |
| Validasi bobot dan formula dengan dosen/pihak desa | Di luar pengujian fungsional mandiri; bobot masih simulasi |

## 7. Cara memeriksa ulang

```bash
flutter pub get
flutter analyze          # harus "No issues found!"
flutter test             # 24 test harus lulus
flutter build web
cd video && npm run typecheck && npm run render
```

Video hasil render ada di `docs/video/blt-dd-prioritas-promo.mp4`; proposal di `docs/proposal/PROPOSAL_UTS.pdf`.

## 8. Kesesuaian rubrik resmi brief UTS

| Bagian rubrik | Bobot | Ketentuan | Bukti |
|---|---|---|---|
| A — Masalah, pengguna, persona | 20 | Masalah jelas, pengguna/persona, minimal 5 user story, kebutuhan konsisten | Proposal bagian 1–3 (persona + US-01…US-09); video 00:27–01:02 dan 01:02–02:06; README "Masalah dan tujuan" |
| B — Desain solusi | 20 | User flow, sitemap, wireframe/Figma, konsistensi rancangan dan aplikasi | Proposal bagian 5–7; `docs/rancangan/USER_FLOW.md`, `SITEMAP.md`; Figma; video 02:06–02:52 |
| C — Implementasi aplikasi | 35 | Aplikasi berjalan, minimal 3 halaman Must terhubung, formulir ≥3 kolom/2 jenis input, validasi jelas, pesan status, data tampil di daftar, data simulasi dan empty state | Demo web GitHub Pages; 5 halaman terhubung; 4 kolom teks + 7 dropdown; validasi per kolom; SnackBar "tersimpan"; baris baru tampil; `Belum ada data` diuji; video 02:52–03:47 |
| D — Teknologi dan rancangan data | 10 | Flutter/Dart, Firebase Spark, Auth, Firestore, Hosting, rancangan koleksi/field | Flutter 3.47.7/Dart 3.13.5; Firebase Spark direncanakan; Auth + Firestore bersyarat di kode; Hosting direncanakan; skema `calon_penerima` + `users`; **integrasi nyata belum diuji** |
| E — Presentasi video | 15 | ≤10 menit, empat pertanyaan, keputusan rancangan/prioritas dijelaskan, kendala dan pelajaran jujur | Video 6:15; empat pertanyaan di 00:27–01:02 dan 05:10–06:15; user story dan prioritas Must/Should di 01:02–02:06; kendala dan pelajaran di penutup; rencana Pertemuan 9–15 di 04:00–05:10 |

## 9. Pengumpulan dan pemeriksaan tautan

Berkas UTS diunggah mahasiswa melalui **E-Learning UNISBANK** paling lambat **Kamis, 5 November 2026, 23.59 WIB**. Pengunggahan ke E-Learning tidak dilakukan dari lingkungan ini; yang disiapkan adalah proposal PDF, video MP4, dan repository publik.

Tautan diperiksa tanpa sesi login (curl tanpa kredensial, 1 November 2026):

| Tautan | Hasil |
|---|---|
| <https://github.com/Bamsuti/BLT-DD-prioritas> | HTTP 200 |
| <https://bamsuti.github.io/BLT-DD-prioritas/> | HTTP 200 |
| <https://youtu.be/AnvDqdBBxeM> | HTTP 200 (versi 5:07; perlu unggah ulang) |
| <https://www.figma.com/make/xnbomh0HD3xaMEtZ0ehUwh/BLT-DD-Prioritas-Wireframe?t=xP6ZZ7tKgaItZh19-1> | HTTP 200 |
| Raw MP4 `docs/video/blt-dd-prioritas-promo.mp4` | HTTP 200 |
| <https://github.com/Bamsuti/BLT-DD-prioritas/actions> | HTTP 200 |
