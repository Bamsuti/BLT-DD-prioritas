# Video Presentasi UTS

Video ini adalah media presentasi UTS. Isinya mengikuti urutan yang diminta: pembuka dan identitas, masalah dan pengguna, kebutuhan dan prioritas fitur, desain (user flow, sitemap, wireframe), demo prototipe yang benar-benar berjalan, rencana teknis dan penyimpanan data, lalu empat jawaban kunci dan penutup.

- Berkas: [blt-dd-prioritas-promo.mp4](video/blt-dd-prioritas-promo.mp4)
- Publikasi YouTube: <https://youtu.be/AnvDqdBBxeM> — tautan publik; judul dan durasi 5:07 terverifikasi
- Ukuran: 24.272.781 byte (±24,3 MB)
- SHA-256: `dc6f9892cb3fc894c049cbe3bb66d7f77255b0a9fd9ef8de52e0fc15cca8ad67`
- Durasi: 5 menit 7 detik (307,18 detik) — batas UTS 10 menit
- Narasi: Bahasa Indonesia, suara `id-ID-ArdiNeural` dari Microsoft Edge TTS (gratis, tanpa API key), rate 0,95
- Singkatan **SAW** ditulis SAW pada layar dan dokumen; dalam narasi diucapkan "Simple Additive Weighting"
- Musik: tidak ada
- Visual: motion graphic Remotion, wireframe SVG, screenshot runtime, dan rekaman layar aplikasi

## Spesifikasi teknis

| Properti | Nilai |
|---|---|
| Resolusi | 1920 × 1080 (16:9) |
| Frame rate | 30 fps |
| Codec video | H.264 |
| Codec audio | AAC, 48 kHz, stereo |
| Jumlah frame | 9.215 |
| Sumber | `video/` (Remotion 4.0.539, React 19, TypeScript 5.9.3) |
| Lingkungan render | Windows, Node.js v24.16.0, Chrome Headless Shell bawaan Remotion |

Angka resolusi, durasi, dan codec diperiksa dengan `ffprobe` terhadap berkas hasil render, bukan perkiraan. Hasil pemeriksaan:

```text
Duration: 00:05:07.18, start: 0.000000, bitrate: 632 kb/s
Stream #0:0: Video: h264 (High), yuvj420p, 1920x1080, 30 fps
Stream #0:1: Audio: aac (LC), 48000 Hz, stereo, 317 kb/s
```

Kadar audio diperiksa dengan `volumedetect` pada 30 detik pertama: `mean_volume -20,4 dB`, `max_volume -6,5 dB`, jadi narasi benar-benar terekam. Delapan cuplikan bingkai (detik 5, 40, 80, 130, 170, 205, 235, 285) diperiksa secara visual untuk memastikan setiap babak tampil tanpa elemen terpotong.

## Struktur video

| Waktu | Babak | Isi |
|---|---|---|
| 00:00–00:27 | Pembuka | Nama, NIM, kelas, judul lengkap, identitas mata kuliah |
| 00:27–01:02 | Masalah & pengguna | Data tersebar, penilaian manual berulang, riwayat sulit ditelusuri; pengguna utama petugas pengelola data BLT-DD desa |
| 01:02–01:50 | Kebutuhan & prioritas | Lima kebutuhan K-01–K-05; prioritas 1 CRUD + validasi formulir, prioritas 2 penilaian dan skor SAW, pendukung login/responsif/Firebase |
| 01:50–02:31 | Desain | User flow lima halaman, sitemap, tiga wireframe, aturan navigasi 760 px |
| 02:31–03:17 | Demo prototipe | Rekaman runtime: login → beranda → data calon → form kosong ditolak → penilaian → hasil |
| 03:17–03:30 | Tampilan responsif | Rekaman mobile 390×844 dengan navigasi bawah; perbandingan desktop |
| 03:30–04:21 | Rencana teknis & data | Arsitektur Flutter → model SAW → backend → Firebase; skema Firestore `calon_penerima` dan `users`; role dan rules; catatan Firebase belum terhubung |
| 04:21–05:07 | Empat jawaban & penutup | Ringkasan empat pertanyaan wajib, disclaimer simulasi, tautan repositori |

Naskah lengkap dan caption tersimpan di `video/scripts/narration.json`. Durasi tiap babak dihitung dari durasi audio TTS yang sebenarnya dan tersimpan di `video/src/audio-timing.json`.

## Empat pertanyaan wajib

| Pertanyaan | Jawaban |
|---|---|
| Masalah apa yang diselesaikan? | Pendataan calon dan penilaian tersebar di spreadsheet, perhitungan diulang dengan cara berbeda, riwayat sulit ditelusuri |
| Siapa pengguna utama? | Petugas pengelola data BLT-DD di tingkat desa yang mendata calon, memperbarui nilai, dan menyiapkan bahan musyawarah |
| Mengapa fitur diprioritaskan demikian? | Kualitas data (CRUD + validasi) lebih dulu karena menjadi dasar skor; penilaian SAW berikutnya; login, responsif, dan Firebase bersifat pendukung |
| Bagaimana data disimpan? | Firebase Authentication untuk akun dan Cloud Firestore untuk koleksi `calon_penerima` dan `users`, dengan akses berbasis role |

## Demo di dalam video

Bagian demo memakai rekaman layar dari aplikasi yang berjalan di <https://bamsuti.github.io/BLT-DD-prioritas/>, bukan mockup:

- `video/public/demo/desktop.mp4` — 40,5 detik, 1280×800, alur login sampai hasil termasuk form kosong yang ditolak.
- `video/public/demo/mobile.mp4` — 14,4 detik, 390×844, navigasi bawah.

Rekaman diambil dengan Chrome headless (CDP screencast) terhadap build Web mode demo, lalu diubah menjadi MP4 dengan ffmpeg.

## Alur produksi

```bash
cd video
npm install
npm run tts        # perlu internet: menghasilkan public/audio/*.mp3 dan src/audio-timing.json
npm run typecheck
npm run render     # menghasilkan ../docs/video/blt-dd-prioritas-promo.mp4
```

- `scripts/tts.mjs` memakai paket `msedge-tts` dan `music-metadata` untuk menulis audio serta timing.
- `src/scenes/` berisi delapan babak; `src/Video.tsx` menyusun urutan, durasi, dan audio per babak.
- `src/components/SceneChrome.tsx` menangani latar, header, dan caption yang dibagi mengikuti panjang teks.
- Screenshot di `video/public/screenshots/` disalin dari `docs/screenshots/runtime/`, yaitu hasil build Web yang benar-benar dijalankan.

## Batasan yang dinyatakan di video

- Seluruh data demonstrasi bersifat sintetis; tidak ada data warga nyata.
- Skor SAW hanya bahan simulasi dan bukan keputusan resmi penerima bantuan.
- Firebase Authentication dan Cloud Firestore sudah disiapkan di kode, tetapi belum dihubungkan ke proyek nyata, sehingga aplikasi berjalan dalam mode demo.
- Video tidak mengklaim pengujian perangkat Android, koneksi Firebase, atau deployment Hosting yang belum dilakukan.

Video ini dirender pada 31 Oktober 2026 sebagai bagian dari pengerjaan prototipe akademik.
