# Matriks Pengujian

Dokumen ini mencatat pengujian yang **benar-benar dijalankan** dan yang belum. Status "Lulus" hanya diberikan bila perintah/perilaku sudah dieksekusi dan hasilnya teramati.

## Lingkungan pengujian

| Item | Nilai |
|---|---|
| OS | Windows 10.0.26200 (x64) |
| Flutter | 3.47.7 stable (revision abaf9c5237) |
| Dart | 3.13.5 |
| Perangkat uji Web | Chrome headless (puppeteer-core 25), viewport 1280×800 dan 390×844, DPR 2 |
| Android SDK | Tidak tersedia |
| Project Firebase | Tidak tersedia |

## Ringkasan hasil

| Pemeriksaan | Perintah | Hasil |
|---|---|---|
| Analisis statis | `flutter analyze` | `No issues found!` |
| Test otomatis | `flutter test` | `00:08 +24: All tests passed!` |
| Build Web | `flutter build web --dart-define=SCREENSHOT_MODE=true` | `√ Built build\web` |
| Screenshot runtime | `tools/capture_screenshots.js` | 14 PNG (7 halaman × desktop/mobile) |
| Build Android | — | Tidak dijalankan (Android SDK tidak tersedia) |
| Firebase Auth/Firestore | — | Tidak diuji (project belum dikonfigurasi) |

Contoh keluaran terminal yang tercatat:

```
Analyzing _final_repo...
No issues found! (ran in 5.9s)

00:08 +24: All tests passed!

Compiling lib\main.dart for the Web...   37.3s
√ Built build\web
```

## Matriks skenario

### A. Login dan autentikasi

| ID | Skenario | Hasil yang diharapkan | Status | Bukti |
|---|---|---|---|---|
| T-01 | Email dan kata sandi kosong | Pesan "Email wajib diisi." dan "Kata sandi wajib diisi." | **Lulus** | Test `Menolak email dan kata sandi kosong` |
| T-02 | Format email tidak valid | Pesan "Masukkan format email yang valid." | **Lulus** | Test `Menolak format email tidak valid` |
| T-03 | Kata sandi < 6 karakter | Pesan "Kata sandi minimal 6 karakter." | **Lulus** | Test `Menolak kata sandi kurang dari enam karakter` |
| T-04 | Kredensial demo salah | Tetap di Login + SnackBar pesan gagal | **Lulus** | Test `Menampilkan pesan ketika kredensial demo salah` |
| T-05 | Login demo benar | Beranda terbuka, sesi aktif | **Lulus** | Test `Login demo berhasil membuka Beranda` |
| T-06 | Logout | Sesi berakhir dan kembali ke Login | **Lulus** | Test `Keluar mengakhiri sesi dan kembali ke Login` |
| T-07 | Kredensial Firebase salah | Pesan error Firebase, tetap di Login | **Belum diuji** | Butuh project Firebase aktif |
| T-08 | Indikator loading saat login | Tombol menampilkan spinner dan nonaktif | **Belum diuji otomatis** | Terlihat di kode; perlu uji manual dengan latensi |

### B. Data calon (CRUD dan validasi)

| ID | Skenario | Hasil yang diharapkan | Status | Bukti |
|---|---|---|---|---|
| T-09 | ID, nama, dusun kosong | Simpan ditolak dengan pesan per field | **Lulus** | Test `Form menolak data wajib yang kosong` |
| T-10 | ID simulasi duplikat | Pesan "ID simulasi sudah digunakan." | **Lulus** | Test `Form menolak ID simulasi duplikat` (widget) dan `ID simulasi duplikat ditolak` (backend) |
| T-11 | Tambah calon valid | Data tersimpan dan muncul di daftar | **Lulus** | Test `Tambah dan ubah calon tercermin pada daftar` |
| T-12 | Ubah calon | Nama/nilai berubah di daftar dan backend | **Lulus** | Test yang sama (assertion `Calon Simulasi A Revisi`) |
| T-13 | Batal hapus | Data tetap ada | **Lulus** | Test `Hapus dapat dibatalkan lalu dikonfirmasi` |
| T-14 | Konfirmasi hapus | Data terhapus dari backend | **Lulus** | Test yang sama |
| T-15 | CRUD mode demo | Simpan, ubah, hapus konsisten di memori | **Lulus** | Test `CRUD calon tersimpan dan terhapus dari daftar` |
| T-16 | Nilai kriteria kosong | Validator menolak nilai null | **Tidak diuji langsung** | Dropdown selalu punya nilai awal 3; validator null tersedia di kode |
| T-17 | Perubahan nilai memengaruhi skor | Skor dihitung ulang (85,0 → 69,0 saat C1 = 1) | **Lulus** | Test `Nilai kriteria yang diubah memengaruhi skor` |
| T-18 | Penyimpanan gagal (I/O/aturan) | SnackBar pesan gagal, dialog tetap terbuka | **Belum diuji** | Butuh Firebase/kegagalan jaringan nyata |

### C. Perhitungan dan hasil

| ID | Skenario | Hasil yang diharapkan | Status | Bukti |
|---|---|---|---|---|
| T-19 | Tujuh kriteria dan total bobot | 7 kriteria, total 100% | **Lulus** | Test `Terdapat tujuh kriteria dengan total bobot 100 persen` |
| T-20 | Rentang skor | 0 ≤ skor ≤ 1 | **Lulus** | Test `Skor SAW berada pada rentang 0 sampai 1` |
| T-21 | Urutan ranking | Skor tertinggi di posisi pertama (85,0) | **Lulus** | Test `Ranking mengurutkan skor tertinggi ke terendah` |
| T-22 | Skor sama | Tie-break berdasarkan kode simulasi | **Lulus** | Test `Skor sama diurutkan berdasarkan kode simulasi` |
| T-23 | Serialisasi model | Tujuh nilai dan data utama tetap utuh | **Lulus** | Test `Serialisasi menyimpan tujuh kriteria dan data utama` |
| T-24 | Kontrak field Firestore | Field sesuai `docs/rancangan/DATABASE.md` | **Lulus** | Test `Nilai kontrak Firestore sesuai field yang didokumentasikan` |
| T-25 | Halaman hasil menampilkan peringkat | Peringkat 1–5 dengan skor 0–100 | **Lulus (visual)** | Screenshot `05-hasil-desktop.png` / `05-hasil-mobile.png` |

### D. Navigasi dan responsivitas

| ID | Skenario | Hasil yang diharapkan | Status | Bukti |
|---|---|---|---|---|
| T-26 | Navigasi empat menu (layar lebar) | `NavigationRail` tampil dan halaman berganti | **Lulus** | Test `NavigationRail tampil pada layar lebar dan berpindah halaman` |
| T-27 | Navigasi layar sempit | `NavigationBar` tampil dan Data Calon terbuka | **Lulus** | Test `NavigationBar tampil pada layar sempit` |
| T-28 | Breakpoint 760 px | Rail pada 1280 px, bar pada 420 px | **Lulus** | Dua test di atas + screenshot 390 px |
| T-29 | Render 7 halaman pada Web | Tidak blank, teks tidak terpotong | **Lulus (visual)** | 14 screenshot runtime, diperiksa satu per satu |

### E. Firebase dan deployment

| ID | Skenario | Hasil yang diharapkan | Status | Bukti |
|---|---|---|---|---|
| T-30 | Inisialisasi Firebase | Label "Mode Firebase" dan login Firebase | **Belum diuji** | Project belum dibuat |
| T-31 | CRUD Firestore | Perubahan terlihat di Console | **Belum diuji** | Butuh project + role user |
| T-32 | Rules menolak user tanpa role | Permission denied | **Belum diuji** | Butuh Emulator Suite |
| T-33 | Rules menolak tulis `users` dari client | Permission denied | **Belum diuji** | Butuh Emulator Suite |
| T-34 | Firebase Hosting | URL publik dapat diakses | **Belum di-deploy** | Belum ada URL |
| T-35 | Build Android debug | APK terbentuk dan berjalan | **Tidak dapat dijalankan** | Android SDK tidak tersedia di lingkungan ini |
| T-36 | GitHub Actions | Analyze, test, build Web/APK hijau | **Belum terverifikasi** | Workflow baru berjalan setelah push |

## Cakupan test otomatis (24 test)

`test/widget_test.dart` berisi 24 test: 6 test model/perhitungan, 3 test layanan demo, dan 15 widget test. Test mencakup validasi login, kredensial demo, logout, CRUD, duplikat ID, konfirmasi hapus, perhitungan skor, tie-break, kontrak Firestore, navigasi responsif, dan mode dokumentasi.

## Keterbatasan pengujian

- Widget test berjalan pada mesin uji Flutter, bukan perangkat fisik; gesture, keyboard, dan performa nyata belum diukur.
- Screenshot runtime berasal dari Chrome headless, bukan emulator Android.
- Tidak ada pengujian aksesibilitas (screen reader), pengujian beban, atau pengujian keamanan dinamis.
- Firebase, rules, dan Hosting belum diuji karena tidak ada project/kredensial pada sesi ini.

## Cara mengulang pengujian

```bash
flutter pub get
flutter analyze
flutter test

# Screenshot runtime
flutter build web --dart-define=SCREENSHOT_MODE=true
npx http-server build/web -p 8080
npm i puppeteer-core
CHROME_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe" \
  node tools/capture_screenshots.js http://127.0.0.1:8080
```
