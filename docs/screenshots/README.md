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

Bukti alur masuk/daftar minggu 9 (diambil dari build Web biasa tanpa mode dokumentasi, viewport 1280×800, melalui Chrome headless dengan pohon semantik):

| File | Kasus (matriks A1 di docs/PENGUJIAN.md) |
|---|---|
| `09-login-mode-daftar.png` | MD-4 — mode daftar dengan kolom ulangi kata sandi |
| `10-daftar-email-terpakai.png` | MD-5 — SnackBar "Email sudah terdaftar. Silakan masuk." |
| `11-daftar-ulangi-tidak-sama.png` | MD-6 — pesan "Ulangi kata sandi tidak sama." |
| `12-login-berhasil-beranda.png` | MD-8 — masuk berhasil membuka Beranda |
| `13-daftar-baru-beranda.png` | MD-10 — akun baru langsung di Beranda dengan SnackBar |
| `14-keluar-kembali-masuk.png` | MD-9 — keluar kembali ke halaman masuk |
| `15-masuk-kolom-kosong.png` | MD-2 — kolom kosong ditolak per kolom |
| `16-masuk-email-tidak-valid.png` | MD-3 — format email ditolak |
| `17-masuk-kata-sandi-salah.png` | MD-7 — kata sandi salah, tetap di halaman masuk |
| `18-refresh-demo-kembali-masuk.png` | MD-11 — muat ulang pada mode demo kembali ke halaman masuk |

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
