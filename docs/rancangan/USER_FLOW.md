# User Flow — BLT-DD Prioritas

## Diagram alur utama

    Mulai
      |
      v
    Login
      |-- email kosong/format salah --> Pesan validasi --> Login
      |-- kredensial salah -----------> Pesan gagal ----> Login
      |-- login berhasil
      v
    Beranda
      |--> Data Calon Penerima --> Tambah/Ubah/Hapus --> Daftar calon
      |--> Penilaian & Prioritas --> Ubah nilai tujuh kriteria
      |--> Hasil Prioritas -------> Tinjau skor/peringkat
      |
      v
    Selesai / Keluar

## Login berhasil
1. Pengguna mengisi email dan kata sandi.
2. Validator memeriksa kolom wajib, format email, dan panjang kata sandi.
3. Jika Firebase terkonfigurasi dan inisialisasi berhasil, aplikasi memakai Firebase Authentication. Jika tidak, mode demo menerima akun lokal yang ditampilkan pada Login.
4. Login berhasil menuju Beranda.
5. Tombol Keluar memanggil sign-out dan kembali ke Login.

## Login gagal
Input yang tidak valid ditolak oleh validator. Kredensial yang salah menghasilkan pesan dan pengguna tetap pada Login. Pengguna dapat memperbaiki input dan mencoba lagi. Gangguan koneksi atau konfigurasi bukan bukti bahwa Firebase telah berhasil dihubungkan.

## Tambah dan ubah data
1. Buka Data Calon Penerima, kemudian pilih Tambah atau Ubah.
2. Isi ID simulasi, nama/label, dusun/kelompok, catatan opsional, dan tujuh nilai.
3. Form menolak ID/nama/dusun kosong, ID duplikat dalam daftar termuat, serta nilai kriteria yang belum dipilih.
4. Simpan menggunakan memori pada mode demo atau koleksi calon_penerima saat Firebase aktif.
5. Daftar dimuat ulang setelah operasi selesai. Jika gagal, aplikasi menampilkan pesan.

## Hapus
Pilih ikon Hapus lalu baca dialog konfirmasi. Batal tidak menghapus data. Hapus melaksanakan operasi backend dan memperbarui daftar jika berhasil.

## Penilaian dan hasil
1. Halaman Penilaian & Prioritas menampilkan tujuh kriteria dan bobot demo.
2. Pilih Isi nilai pada calon, ubah nilai di form, lalu Simpan.
3. Hasil menghitung normalisasi nilai terhadap nilai maksimum pada masing-masing kriteria, mengalikan dengan bobot demo, menjumlahkan skor, dan mengurutkan menurun.
4. Hasil hanya simulasi/bahan pertimbangan. Proses nyata tetap membutuhkan validasi, verifikasi, dan musyawarah.

## Fungsi lima halaman
- Login: validasi, autentikasi dan status mode.
- Beranda: ringkasan dinamis dan pintasan.
- Data Calon Penerima: CRUD calon dan form.
- Penilaian & Prioritas: definisi tujuh kriteria, bobot demo, dan pintasan edit nilai.
- Hasil Prioritas: skor terhitung dan peringkat.

Persona petugas pengelola data BLT-DD masih asumsi awal; wawancara belum diklaim dilakukan.
