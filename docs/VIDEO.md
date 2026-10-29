# Video Penjelasan: Masalah, Target, dan Ruang Lingkup

Video ini merupakan media pendukung presentasi. Isinya menjelaskan tiga hal yang diminta: masalah yang melatarbelakangi prototipe, target pengguna, dan ruang lingkup yang dikerjakan.

- Berkas: [blt-dd-prioritas-promo.mp4](video/blt-dd-prioritas-promo.mp4)
- Ukuran: 10.240.064 byte (±10,2 MB)
- Durasi: 119,3 detik (1 menit 59 detik)
- Narasi: Bahasa Indonesia, suara `id-ID-ArdiNeural` dari Microsoft Edge TTS (gratis, tanpa API key), rate 0,95
- Musik: tidak ada
- Visual: motion graphic Remotion dengan screenshot runtime mode demo

## Spesifikasi teknis

| Properti | Nilai |
|---|---|
| Resolusi | 1920 × 1080 (16:9) |
| Frame rate | 30 fps |
| Codec video | H.264 |
| Codec audio | AAC, 48 kHz, stereo |
| Jumlah frame | 3.579 |
| Sumber | `video/` (Remotion 4.0.539, React 19, TypeScript 5.9.3) |
| Lingkungan render | Windows, Node.js v24.16.0, Chrome Headless Shell bawaan Remotion |

Angka di atas diperiksa dengan `ffprobe` terhadap berkas hasil render, bukan perkiraan.

## Struktur video

| Waktu | Babak | Isi |
|---|---|---|
| 00:00–00:12 | Pembuka | Judul, identitas, dan gambaran singkat prototipe |
| 00:12–00:38 | Masalah | Data tersebar, perhitungan berulang, riwayat sulit ditelusuri |
| 00:38–01:01 | Target | Petugas pengelola data BLT-DD dan lima halaman utama |
| 01:01–01:36 | Ruang lingkup | Yang termasuk, yang tidak termasuk, dan status Firebase |
| 01:36–01:59 | Penutup | Peringatan bahan simulasi, data sintetis, tautan repositori |

Naskah lengkap dan caption tersimpan di `video/scripts/narration.json`. Durasi tiap babak dihitung dari durasi audio TTS yang sebenarnya, tersimpan di `video/src/audio-timing.json`.

## Alur produksi

```bash
cd video
npm install
npm run tts        # perlu internet: menghasilkan public/audio/*.mp3 dan src/audio-timing.json
npm run typecheck
npm run render     # menghasilkan ../docs/video/blt-dd-prioritas-promo.mp4
```

- `scripts/tts.mjs` memakai paket `msedge-tts` dan `music-metadata` untuk menulis audio serta timing.
- `src/scenes/` berisi lima babak; `src/Video.tsx` menyusun urutan, durasi, dan audio per babak.
- `src/components/SceneChrome.tsx` menangani latar, header, dan caption yang dibagi mengikuti panjang teks.
- Screenshot di `video/public/screenshots/` disalin dari `docs/screenshots/runtime/`, yaitu hasil build Web yang benar-benar dijalankan.

## Batasan yang dinyatakan di video

- Seluruh data demonstrasi bersifat sintetis; tidak ada data warga nyata.
- Skor SAW hanya bahan simulasi dan bukan keputusan resmi penerima bantuan.
- Firebase Authentication dan Cloud Firestore sudah disiapkan di kode, tetapi belum dihubungkan ke proyek nyata, sehingga aplikasi berjalan dalam mode demo.
- Video tidak mengklaim pengujian perangkat Android, koneksi Firebase, atau deployment Hosting yang belum dilakukan.

Video ini dibuat pada 29 Oktober 2026 sebagai bagian dari pengerjaan prototipe akademik.
