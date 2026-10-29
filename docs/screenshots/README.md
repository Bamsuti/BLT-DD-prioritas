# Screenshot dan Wireframe

## Screenshot runtime (`runtime/`)

Diambil dari **build Web Flutter yang dijalankan** melalui Chrome headless (puppeteer-core), bukan mockup:

| File | Halaman | Viewport |
|---|---|---|
| `01-login-desktop.png`, `01-login-mobile.png` | Login | 1280×800 / 390×844 |
| `02-beranda-*.png` | Beranda | 1280×800 / 390×844 |
| `03-data-calon-*.png` | Data Calon Penerima | 1280×800 / 390×844 |
| `04-penilaian-*.png` | Penilaian & Prioritas | 1280×800 / 390×844 |
| `05-hasil-*.png` | Hasil Prioritas | 1280×800 / 390×844 |
| `06-form-tambah-*.png` | Dialog tambah calon | 1280×800 / 390×844 |
| `07-form-validasi-*.png` | Dialog dengan pesan validasi | 1280×800 / 390×844 |

Semua gambar memakai data simulasi bawaan (`SIM-001`–`SIM-005`) pada mode demo. Skala perangkat 2× agar teks tajam.

Cara menghasilkan ulang:

```bash
flutter build web --dart-define=SCREENSHOT_MODE=true
npx http-server build/web -p 8080
npm i puppeteer-core
CHROME_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe" \
  node tools/capture_screenshots.js http://127.0.0.1:8080
```

`SCREENSHOT_MODE` hanya untuk dokumentasi: halaman dibuka langsung melalui `?page=N` (0 = Login, 1–4 = Beranda/Data Calon/Penilaian/Hasil, 5 = dialog form, 6 = dialog dengan validasi). Build normal tetap mewajibkan login.

## Wireframe (`*.svg`)

Lima SVG di folder ini adalah wireframe rancangan awal dari tahap UTS untuk menjelaskan susunan halaman. Gambar tersebut **bukan** bukti runtime; gunakan screenshot di `runtime/` untuk bukti implementasi.
