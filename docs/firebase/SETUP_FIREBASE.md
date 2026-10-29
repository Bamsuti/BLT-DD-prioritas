# Panduan Mengaktifkan Firebase

Status saat repository diperbarui: build Web dan mode demo sudah berjalan serta diuji otomatis, tetapi integrasi Firebase **belum dikonfigurasi atau diuji** dengan project nyata. Jangan mengirim password akun atau private key lewat chat dan jangan memasukkannya ke GitHub.

## Persiapan Firebase
1. Buat/pilih Firebase project pada akun pemilik proyek.
2. Aktifkan Authentication → Sign-in method → Email/Password.
3. Daftarkan aplikasi Web dan catat client config dari Firebase Console.
4. Jika akan menguji Android, daftarkan aplikasi Android dengan application ID `com.example.blt_dd_prioritas` (lihat `android/app/build.gradle.kts`). Ganti application ID bila perlu sebelum rilis.
5. Buat Cloud Firestore dalam mode/lokasi yang sesuai, lalu terapkan `firestore.rules` setelah diuji di Emulator Suite.

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
- [ ] Label aplikasi menunjukkan Mode Firebase aktif.
- [ ] Login berhasil dengan akun uji Firebase.
- [ ] Kredensial salah ditolak.
- [ ] Logout mengakhiri sesi.
- [ ] CRUD calon berhasil dan terlihat di Console.
- [ ] User tanpa dokumen role tidak dapat mengelola data.
- [ ] Rules diuji dalam lingkungan non-produksi terlebih dahulu.
- [ ] Kegagalan jaringan ditinjau.
