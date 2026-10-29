# Kebutuhan Pengguna dan Keterlacakan

Kebutuhan diturunkan dari masalah dan scope pada presentasi UTS. Persona pengguna adalah asumsi awal yang perlu divalidasi.

| Kode | Kebutuhan | Fitur | Halaman | Bukti pemeriksaan | Status |
|---|---|---|---|---|---|
| K-01 | Petugas perlu login dan mengetahui login gagal | Validasi email/password, loading, error, logout | Login | 6 test login/logout | Teruji otomatis (mode demo) |
| K-02 | Petugas perlu ringkasan kondisi data | Jumlah calon/kriteria dan pintasan | Beranda | Ringkasan dihitung dari data; screenshot runtime | Teruji visual |
| K-03 | Petugas perlu mengelola calon | Tambah, lihat, ubah, hapus dan konfirmasi | Data Calon | 4 test CRUD/validasi | Teruji otomatis (mode demo) |
| K-04 | Petugas perlu mengisi tujuh nilai konsisten | Dropdown skala 1–5 dan validasi wajib | Form calon, Penilaian | Model criteria dan validator | Teruji otomatis |
| K-05 | Data simulasi perlu memiliki kode | ID simulasi wajib dan cek duplikat pada daftar termuat | Data Calon | Field ID dan validator | Teruji otomatis |
| K-06 | Petugas perlu meninjau hasil | Normalisasi, pembobotan, pengurutan | Hasil Prioritas | 5 test model + screenshot | Teruji otomatis; bobot belum divalidasi |
| K-07 | Petugas butuh akses pada layar berbeda | NavigationBar dan NavigationRail | Seluruh halaman setelah login | 2 test viewport 420/1280 px + screenshot 390 px | Teruji otomatis dan visual |
| K-08 | Petugas perlu mengetahui status data | Status Demo/Firebase, pesan error dan coba lagi | Login, AppShell | Indikator mode dan error handling | Sebagian: label demo tampil; jalur Firebase belum diuji |

## Batasan
Data demo sintetis dan hanya ada dalam memori. Firebase hanya aktif jika konfigurasi tersedia dan inisialisasi sukses; jalur Firebase belum diuji dengan project nyata. Implementasi Firestore menaruh profil dan skor dalam dokumen calon_penerima. Koleksi lain belum dipakai kode.
