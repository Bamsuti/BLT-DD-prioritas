# Kebutuhan Pengguna dan Keterlacakan

Kebutuhan diturunkan dari masalah dan scope pada presentasi UTS. Persona pengguna adalah asumsi awal yang perlu divalidasi.

| Kode | Kebutuhan | Fitur | Halaman | Bukti pemeriksaan | Status |
|---|---|---|---|---|---|
| K-01 | Petugas perlu login dan mengetahui login gagal | Validasi email/password, loading, error, logout | Login | Form Login dan LoginPage | Kode disiapkan; belum diuji runtime |
| K-02 | Petugas perlu ringkasan kondisi data | Jumlah calon/kriteria dan pintasan | Beranda | Ringkasan dihitung dari data | Kode disiapkan; belum diuji runtime |
| K-03 | Petugas perlu mengelola calon | Tambah, lihat, ubah, hapus dan konfirmasi | Data Calon | Form, daftar, dialog hapus | Kode disiapkan; belum diuji runtime |
| K-04 | Petugas perlu mengisi tujuh nilai konsisten | Dropdown skala 1–5 dan validasi wajib | Form calon, Penilaian | Model criteria dan validator | Kode disiapkan; belum diuji runtime |
| K-05 | Data simulasi perlu memiliki kode | ID simulasi wajib dan cek duplikat pada daftar termuat | Data Calon | Field ID dan validator | Kode disiapkan; belum diuji runtime |
| K-06 | Petugas perlu meninjau hasil | Normalisasi, pembobotan, pengurutan | Hasil Prioritas | Fungsi preferenceScore | Rumus demo disiapkan; bobot belum divalidasi |
| K-07 | Petugas butuh akses pada layar berbeda | NavigationBar dan NavigationRail | Seluruh halaman setelah login | Breakpoint 760 px di AppShell | Kode disiapkan; belum diuji perangkat |
| K-08 | Petugas perlu mengetahui status data | Status Demo/Firebase, pesan error dan coba lagi | Login, AppShell | Indikator mode dan error handling | Kode disiapkan; belum diuji layanan nyata |

## Batasan
Data demo sintetis dan hanya ada dalam memori. Firebase hanya aktif jika konfigurasi tersedia dan inisialisasi sukses. Implementasi Firestore saat ini menaruh profil dan skor dalam dokumen calon_penerima. Koleksi lain belum dipakai kode.
