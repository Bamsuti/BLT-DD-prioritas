# Matriks Pengujian

Dokumen ini mencatat pengujian yang **benar-benar dijalankan** dan yang belum. Status "Lulus" hanya diberikan bila perintah/perilaku sudah dieksekusi dan hasilnya teramati.

Seluruh pengujian fungsional dijalankan **mandiri oleh pembuat proyek**: test otomatis di mesin lokal, screenshot melalui Chrome headless, dan build APK melalui GitHub Actions. Tidak ada skenario yang menunggu pengujian atau persetujuan petugas desa. Validasi lapangan persona dan bobot berada di luar lingkup pengujian UTS dan tidak dihitung sebagai skenario yang tertunda.

## Lingkungan pengujian

| Item | Nilai |
|---|---|
| OS | Windows 10.0.26200 (x64) |
| Flutter | 3.47.7 stable (revision abaf9c5237) |
| Dart | 3.13.5 |
| Perangkat uji Web | Chrome headless (puppeteer-core 25), viewport 1280×800 dan 390×844, DPR 2 |
| Uji live Pages | Chrome headless 1280×800 terhadap <https://bamsuti.github.io/BLT-DD-prioritas/>, 1 November 2026 |
| Android SDK | Tidak tersedia lokal; build APK dijalankan di GitHub Actions (ubuntu-latest) |
| Project Firebase | Tidak tersedia |
| Pelaksana uji | Pembuat proyek (mandiri), tanpa penguji eksternal atau petugas desa |

## Ringkasan hasil

| Pemeriksaan | Perintah | Hasil |
|---|---|---|
| Analisis statis | `flutter analyze` | `No issues found!` |
| Test otomatis | `flutter test` | `00:11 +28: All tests passed!` |
| Build Web | `flutter build web --dart-define=SCREENSHOT_MODE=true` | `√ Built build\web` |
| Screenshot runtime | `tools/capture_screenshots.js` + tangkapan live Pages | 26 PNG (7 halaman × desktop/mobile + SnackBar, hasil enam calon, dan 10 bukti masuk/daftar minggu 9) |
| Uji masuk/daftar (minggu 9) | Chrome headless mengisi form login/daftar pada build Web biasa | 11/11 kasus sesuai harapan (tabel A1) |
| Build Android | `flutter build apk --debug` di GitHub Actions | Berhasil (run #7); belum dijalankan di perangkat |
| CI | GitHub Actions run #7 | Semua langkah berhasil |
| Uji live Pages | Chrome headless ke demo publik | Form kosong ditolak per kolom; SnackBar "Data Calon Simulasi Enam (SIM-006) tersimpan." dan baris baru tampil; SIM-006 masuk peringkat hasil |
| Firebase Auth/Firestore | — | Tidak diuji (project belum dikonfigurasi) |

Contoh keluaran terminal yang tercatat:

```
Analyzing _final_repo...
No issues found! (ran in 68.6s)

00:11 +28: All tests passed!
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

### A1. Tabel uji masuk dan daftar (minggu 9, 11 kasus)

Minggu 9 menambahkan alur pendaftaran akun dan cek status login melalui StreamBuilder. Sebelas kasus berikut dijalankan langsung pada aplikasi Web hasil `flutter build web` (tanpa mode dokumentasi) melalui Chrome headless berukuran 1280×800: kolom diisi dan tombol ditekan seperti pengguna biasa dengan bantuan pohon semantik (`?semantics=1`), lalu setiap langkah disimpan sebagai tangkapan layar. Kasus yang sama juga ditutup oleh test otomatis.

| No | Kasus | Langkah | Hasil yang diharapkan | Status | Bukti |
|---|---|---|---|---|---|
| MD-1 | Halaman masuk tampil | Buka aplikasi | Kolom Email, Kata sandi, dan tombol Masuk tampil | **Lulus** | `01-login-desktop.png` |
| MD-2 | Kolom kosong ditolak | Tekan Masuk tanpa mengisi apa pun | Pesan "Email wajib diisi." dan "Kata sandi wajib diisi." | **Lulus** | Widget test `Menolak email dan kata sandi kosong`; `15-masuk-kolom-kosong.png` |
| MD-3 | Format email tidak valid | Email `bukan-email`, kata sandi 6 karakter | Pesan "Masukkan format email yang valid." | **Lulus** | Widget test `Menolak format email tidak valid`; `16-masuk-email-tidak-valid.png` |
| MD-4 | Beralih ke mode daftar | Tekan "Belum punya akun? Daftar" | Judul dan tombol berubah menjadi Daftar, kolom Ulangi kata sandi tampil | **Lulus** | `09-login-mode-daftar.png` |
| MD-5 | Daftar dengan email yang sudah dipakai | Mode daftar, email `petugas@blt-dd.local` | SnackBar "Email sudah terdaftar. Silakan masuk." | **Lulus (mode demo)** | Widget test `Daftar dengan email yang sudah dipakai ditolak`; `10-daftar-email-terpakai.png` |
| MD-6 | Ulangi kata sandi tidak sama | Mode daftar, kedua kata sandi berbeda | Pesan "Ulangi kata sandi tidak sama." dan pendaftaran ditolak | **Lulus** | Widget test `Mode daftar menolak ulangi kata sandi yang tidak sama`; `11-daftar-ulangi-tidak-sama.png` |
| MD-7 | Kata sandi salah saat masuk | Email demo, kata sandi salah | Tetap di halaman masuk, SnackBar pesan gagal | **Lulus** | `17-masuk-kata-sandi-salah.png` |
| MD-8 | Masuk berhasil | Email dan kata sandi demo benar | Beranda terbuka dengan sapaan petugas | **Lulus** | Widget test `Login demo berhasil membuka Beranda`; `12-login-berhasil-beranda.png` |
| MD-9 | Keluar dari sesi | Tekan Keluar di Beranda | Kembali ke halaman masuk | **Lulus** | Widget test `Keluar mengakhiri sesi dan kembali ke Login`; `14-keluar-kembali-masuk.png` |
| MD-10 | Daftar akun baru | Mode daftar, email baru yang valid | SnackBar "Akun berhasil dibuat. Selamat datang di BLT-DD Prioritas." dan langsung berada di Beranda | **Lulus (mode demo)** | Widget test `Daftar akun demo baru langsung membuka Beranda`; `13-daftar-baru-beranda.png` |
| MD-11 | Muat ulang halaman di mode demo | Tekan refresh pada browser saat sesi demo aktif | Kembali ke halaman masuk karena sesi demo tidak disimpan | **Lulus (perilaku terdokumentasi)** | `18-refresh-demo-kembali-masuk.png`; muatan ulang kedua memastikan form bersih |

Catatan: MD-2 sampai MD-10 juga ditutup oleh test otomatis sehingga total test kini 28. Kasus MD-5, MD-10, dan MD-11 diuji pada mode demo — akun pendaftaran disimpan di memori aplikasi. Pada mode Firebase, pendaftaran memakai `createUserWithEmailAndPassword` dan pemulihan sesi memakai `authStateChanges()`; keduanya belum diuji karena project Firebase belum tersedia (lihat bagian E).

### B. Data calon (CRUD dan validasi)

| ID | Skenario | Hasil yang diharapkan | Status | Bukti |
|---|---|---|---|---|
| T-09 | ID, nama, dusun kosong | Simpan ditolak dengan pesan per field | **Lulus** | Test `Form menolak data wajib yang kosong` |
| T-10 | ID simulasi duplikat | Pesan "ID simulasi sudah digunakan." | **Lulus** | Test `Form menolak ID simulasi duplikat` (widget) dan `ID simulasi duplikat ditolak` (backend) |
| T-11 | Tambah calon valid | Data tersimpan, SnackBar tampil, dan baris baru muncul di daftar | **Lulus** | Test `Tambah dan ubah calon tercermin pada daftar`; uji live Pages → `08-form-snackbar-desktop.png` |
| T-12 | Ubah calon | Nama/nilai berubah di daftar dan backend | **Lulus** | Test yang sama (assertion `Calon Simulasi A Revisi`) |
| T-13 | Batal hapus | Data tetap ada | **Lulus** | Test `Hapus dapat dibatalkan lalu dikonfirmasi` |
| T-14 | Konfirmasi hapus | Data terhapus dan empty state tampil setelah semua data dihapus | **Lulus** | Test yang sama; assertion `Belum ada data` dan `Klik "Tambah calon"` |
| T-15 | CRUD mode demo | Simpan, ubah, hapus konsisten di memori | **Lulus** | Test `CRUD calon tersimpan dan terhapus dari daftar` |
| T-16 | Nilai kriteria kosong | Validator menolak nilai null | **Tidak diuji langsung** | Dropdown selalu punya nilai awal 3; validator null tersedia di kode |
| T-17 | Perubahan nilai memengaruhi skor | Skor dihitung ulang (85,0 → 69,0 saat C1 = 1) | **Lulus** | Test `Nilai kriteria yang diubah memengaruhi skor` |
| T-18 | Penyimpanan gagal (I/O/aturan) | SnackBar pesan gagal, dialog tetap terbuka | **Belum diuji** | Butuh Firebase/kegagalan jaringan nyata |

### B1. Tabel uji formulir (8 kasus)

Formulir Data Calon memiliki 4 kolom teks (ID simulasi, nama, dusun, catatan opsional) dan 7 dropdown kriteria skala 1–5 — dua jenis input.

| No | Kasus | Input | Hasil yang diharapkan | Status | Bukti |
|---|---|---|---|---|---|
| F-1 | Kolom wajib kosong | Tekan Simpan tanpa mengisi apa pun | Tiga pesan per kolom: "ID simulasi wajib diisi.", "Nama calon wajib diisi.", "Dusun/kelompok wajib diisi."; data tidak tersimpan | **Lulus** | Test `Form menolak data wajib yang kosong`; uji live Pages → `07-form-validasi-desktop.png` |
| F-2 | ID simulasi duplikat | ID `SIM-001` | Pesan "ID simulasi sudah digunakan." dan simpan ditolak | **Lulus** | Test widget dan test backend |
| F-3 | Data valid | `SIM-006`, `Calon Simulasi Enam`, `Dusun Enam`, skor awal 3 | Dialog tertutup, SnackBar "Data … tersimpan.", baris baru tampil di daftar | **Lulus** | Test widget; uji live Pages → `08-form-snackbar-desktop.png` |
| F-4 | Ubah data | Ubah nama menjadi `Calon Simulasi A Revisi` | Daftar menampilkan nama baru; ID tidak berubah | **Lulus** | Test `Tambah dan ubah calon tercermin pada daftar` |
| F-5 | Batal hapus | Tekan Batal pada konfirmasi | Data tetap ada | **Lulus** | Test `Hapus dapat dibatalkan lalu dikonfirmasi` |
| F-6 | Konfirmasi hapus | Tekan Hapus pada konfirmasi | Data hilang dari daftar | **Lulus** | Test yang sama |
| F-7 | Empty state | Hapus seluruh calon | Tampil "Belum ada data" dan "Klik \"Tambah calon\" untuk memasukkan data pertama." | **Lulus** | Test yang sama; assertion teks empty state |
| F-8 | Nilai di luar 1–5 | Tidak tersedia pilihan di luar 1–5 | Tidak dapat dimasukkan karena dropdown; validator juga menolak nilai null | **Lulus secara konstruksi** | Dropdown 1–5 di form; validator null ada di kode dan tidak diuji langsung (T-16) |

Catatan: F-1, F-2, F-3, F-4, F-5, F-6, F-7 dijalankan melalui test otomatis; F-1 dan F-3 juga diverifikasi pada aplikasi live di GitHub Pages. F-8 diverifikasi dari struktur input, bukan input manual di luar rentang.

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
| T-35 | Build Android debug | APK terbentuk dan berjalan | **Lulus (build)** | APK debug berhasil dibangun di CI; belum diinstal/dijalankan di perangkat |
| T-36 | GitHub Actions | Analyze, test, build Web/APK hijau | **Lulus** | [Run #7](https://github.com/Bamsuti/BLT-DD-prioritas/actions/runs/40902045482) selesai dengan status success |

## Cakupan test otomatis (28 test)

`test/widget_test.dart` berisi 28 test: 6 test model/perhitungan, 3 test layanan demo, dan 19 widget test. Test mencakup validasi login, kredensial demo, pendaftaran akun (mode daftar, ulangi kata sandi, email sudah dipakai, akun baru langsung masuk, akun baru dipakai masuk kembali), logout, CRUD, duplikat ID, konfirmasi hapus, perhitungan skor, tie-break, kontrak Firestore, navigasi responsif, dan mode dokumentasi.

## Keterbatasan pengujian

- Widget test berjalan pada mesin uji Flutter, bukan perangkat fisik; gesture, keyboard, dan performa nyata belum diukur.
- Screenshot runtime berasal dari Chrome headless, bukan emulator Android.
- APK debug dibangun di CI, tetapi belum diinstal atau dijalankan pada perangkat/emulator.
- Tidak ada pengujian aksesibilitas (screen reader), pengujian beban, atau pengujian keamanan dinamis.
- Pendaftaran akun diuji pada mode demo (akun tersimpan di memori dan hilang saat halaman dimuat ulang). Pendaftaran lewat Firebase Auth, pesan error asli Firebase, dan pemulihan sesi `authStateChanges()` belum diuji karena project/kredensial belum tersedia pada sesi ini.
- Firebase, rules, dan Hosting belum diuji karena tidak ada project/kredensial pada sesi ini.
- Pengujian bersifat verifikasi fungsional mandiri, bukan validasi lapangan; tidak ada pengujian oleh petugas desa dan hasilnya tidak menunggu pengujian tersebut.

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
