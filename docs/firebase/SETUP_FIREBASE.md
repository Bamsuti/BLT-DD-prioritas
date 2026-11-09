# Panduan Mengaktifkan Firebase

Status saat repository diperbarui (minggu 9): project **`bltdd-prioritas-6f007`** sudah dibuat pada paket Spark gratis, Authentication Email/Password sudah aktif, dan alur masuk/daftar/keluar/pemulihan sesi **sudah diuji nyata** dengan build `--dart-define` (tabel A2 di `docs/PENGUJIAN.md`). Yang belum: Firestore belum dibuat, secrets Pages belum diisi, rules belum diuji di Emulator Suite, Hosting belum di-deploy. Jangan mengirim password akun atau private key lewat chat dan jangan memasukkannya ke GitHub.

## Persiapan Firebase
1. [x] Buat/pilih Firebase project pada akun pemilik proyek — `bltdd-prioritas-6f007` (paket Spark, tanpa billing).
2. [x] Aktifkan Authentication → Sign-in method → Email/Password.
3. [x] Daftarkan aplikasi Web dan catat client config dari Firebase Console.
4. [ ] Jika akan menguji Android, daftarkan aplikasi Android dengan application ID `com.example.blt_dd_prioritas` (lihat `android/app/build.gradle.kts`). Ganti application ID bila perlu sebelum rilis.
5. [ ] Buat Cloud Firestore dalam mode/lokasi yang sesuai, lalu terapkan `firestore.rules` setelah diuji di Emulator Suite.

## Konfigurasi runtime
Kode membaca opsi melalui dart-define. Nilai diperlukan berasal dari Firebase Console sendiri:
- FIREBASE_API_KEY
- FIREBASE_APP_ID
- FIREBASE_MESSAGING_SENDER_ID
- FIREBASE_PROJECT_ID
- FIREBASE_AUTH_DOMAIN (opsional sesuai platform/project)
- FIREBASE_STORAGE_BUCKET (opsional; fitur storage tidak digunakan)

Pola perintah di bawah hanya contoh dengan placeholder:

    flutter run -d chrome --dart-define=FIREBASE_API_KEY=ISI_SENDIRI --dart-define=FIREBASE_APP_ID=ISI_SENDIRI --dart-define=FIREBASE_MESSAGING_SENDER_ID=ISI_SENDIRI --dart-define=FIREBASE_PROJECT_ID=ISI_SENDIRI --dart-define=FIREBASE_AUTH_DOMAIN=ISI_SENDIRI

Untuk build Web, jalankan flutter build web dengan dart-define yang sama. Ganti seluruh placeholder dengan nilai milik proyek Anda. Jika konfigurasi tidak lengkap atau inisialisasi gagal, aplikasi tetap pada mode demo. Lihat label pada layar untuk memastikan mode yang aktif.

Login memakai Firebase Authentication (Email/Password) saat konfigurasi lengkap. Sesi tersimpan dipulihkan sebelum halaman awal ditentukan, sehingga pengguna yang sudah login tidak kembali ke halaman Login saat memuat ulang. Pesan kesalahan seperti domain belum diizinkan, metode belum aktif, atau API key salah ditampilkan dalam Bahasa Indonesia.

## Pendaftaran akun petugas (minggu 9)

Halaman masuk memiliki tautan "Belum punya akun? Daftar" untuk membuat akun baru tanpa perlu menambahkan akun dari Console:

1. Buka mode daftar, isi email, kata sandi (minimal 6 karakter), dan ulangi kata sandi.
2. Kode memanggil `createUserWithEmailAndPassword`; jika berhasil, pengguna langsung masuk ke Beranda karena halaman mengikuti aliran `authStateChanges()`.
3. Email yang sudah terdaftar ditolak dengan pesan "Email sudah terdaftar. Silakan masuk." dan kata sandi terlalu lemah ditolak dengan pesan dari Firebase ("Kata sandi terlalu lemah, minimal 6 karakter.").
4. Akun yang dibuat muncul di Firebase Console → Authentication → Users dan bisa langsung dipakai untuk masuk kembali.

Catatan: pada mode demo, pendaftaran disimulasikan di memori sehingga akun baru hilang saat halaman dimuat ulang. Pada mode Firebase nyata, seluruh alur di atas sudah diuji (FB-2 pendaftaran, FB-6 email terpakai ditolak) dan akun terdaftar terverifikasi di Console → Authentication → Users (`19-firebase-console-users.png`). Peran (role) tetap dikelola lewat dokumen `users/{uid}` seperti bagian berikut — pendaftaran tidak otomatis memberi akses data Firestore.

## Aktivasi pada web GitHub Pages
Build publik di https://bamsuti.github.io/BLT-DD-prioritas/ memakai nilai dari repository secrets. Keenam secrets (`FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_MESSAGING_SENDER_ID`, `FIREBASE_PROJECT_ID`, `FIREBASE_AUTH_DOMAIN`, `FIREBASE_STORAGE_BUCKET`) telah diisi pada 10 November 2026 dan workflow dipicu ulang (run `42661733692`); build publik kini terverifikasi memuat konfigurasi Firebase nyata dan akun terdaftar dapat masuk. Bila secrets kosong, build kembali berjalan dalam mode demo.

1. Buka Settings → Secrets and variables → Actions pada repository.
2. Tambahkan secrets berikut dengan nilai dari Firebase Console (Project settings → Your apps → Web app):
   - FIREBASE_API_KEY
   - FIREBASE_APP_ID
   - FIREBASE_MESSAGING_SENDER_ID
   - FIREBASE_PROJECT_ID
   - FIREBASE_AUTH_DOMAIN
   - FIREBASE_STORAGE_BUCKET
3. Di Firebase Authentication → Settings → Authorized domains, tambahkan bamsuti.github.io.
4. Jalankan ulang workflow Deploy Web to GitHub Pages (Actions → Run workflow) atau push perubahan pada lib/.
5. Buka aplikasi, pastikan label berubah menjadi Firebase, lalu login dengan akun uji.

Nilai client config Firebase bukan private key, tetapi tetap disimpan sebagai secrets agar tidak tertulis di repository. Jangan pernah menambahkan service account, password akun, atau private key ke repository maupun secrets aplikasi web.

## Akun petugas dan role
1. Buat akun uji di Firebase Authentication.
2. Salin UID akun tersebut dari Console.
3. Buat dokumen users/{UID} pada Firestore secara manual melalui jalur tepercaya.
4. Isi field role dengan admin atau petugas.
5. Uji rules. Dokumen users tidak dapat ditulis dari client oleh rules saat ini, sehingga user biasa tidak bisa mengubah rolenya sendiri.

## Data Firestore
Kode melakukan CRUD di calon_penerima. Field meliputi idSimulasi, namaLabel, dusun, catatan, map scores berisi C1–C7, createdAt, updatedAt. Koleksi penilaian, kriteria_bobot, hasil_prioritas, dan riwayat_proses adalah rancangan untuk fase berikutnya dan belum ditulis kode ini.

## Security Rules
firestore.rules mengizinkan akses pada data operasional kepada user terautentikasi yang dokumen users/{uid}-nya memiliki role admin/petugas. Aturan ini draft awal; periksa validasi tipe data, akses admin, skenario query, dan gunakan Firebase Emulator Suite sebelum dipakai. Jangan deploy rules tanpa review.

## Firebase Hosting
`flutter build web` sudah berhasil pada mode demo. Setelah build dengan konfigurasi Firebase yang tepat, pasang Firebase CLI, login, pilih project, inisialisasi Hosting ke `build/web`, periksa konfigurasi SPA (`firebase.json` sudah memiliki rewrite ke `index.html`), lalu deploy. Buka URL yang dikeluarkan CLI dan uji login, CRUD, refresh, navigasi, dan rules. Firebase Hosting belum di-deploy dari sesi ini; tidak ada URL deployment yang diklaim.

## Checklist aktivasi
- [x] Label aplikasi menunjukkan Mode Firebase aktif. (A2 FB-1)
- [x] Login berhasil dengan akun uji Firebase. (A2 FB-5)
- [x] Kredensial salah ditolak. (A2 FB-7)
- [x] Pendaftaran akun baru berhasil dan akun muncul di Console → Authentication → Users. (A2 FB-2, bukti `19-firebase-console-users.png`)
- [x] Pendaftaran dengan email yang sudah terdaftar ditolak. (A2 FB-6)
- [x] Logout mengakhiri sesi. (A2 FB-4)
- [x] Sesi dipulihkan saat halaman dimuat ulang. (A2 FB-3)
- [ ] CRUD calon berhasil dan terlihat di Console. (Firestore belum dibuat)
- [ ] User tanpa dokumen role tidak dapat mengelola data.
- [ ] Rules diuji dalam lingkungan non-produksi terlebih dahulu.
- [ ] Kegagalan jaringan ditinjau.
