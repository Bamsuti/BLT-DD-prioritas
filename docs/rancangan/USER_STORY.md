# User Story dan Kriteria Penerimaan

| ID | User story | Kriteria penerimaan |
|---|---|---|
| US-01 | Sebagai petugas, saya ingin login agar dapat membuka halaman pengelolaan. | Email kosong dan format salah ditolak; password wajib minimal enam karakter; kredensial Firebase salah memberi pesan; login berhasil menuju Beranda. |
| US-02 | Sebagai petugas, saya ingin melihat ringkasan agar mengetahui kondisi daftar. | Jumlah calon dari data yang dimuat; jumlah kriteria tujuh; pintasan membuka halaman benar. |
| US-03 | Sebagai petugas, saya ingin menambah calon agar data terkelola. | ID simulasi, nama/label, dusun, tujuh nilai wajib; ID duplikat ditolak; setelah simpan calon tampil di daftar. |
| US-04 | Sebagai petugas, saya ingin mengubah calon agar koreksi data terlihat. | Form memuat nilai lama; setelah simpan daftar menampilkan perubahan; ID dokumen tidak berubah. |
| US-05 | Sebagai petugas, saya ingin konfirmasi sebelum menghapus. | Batal mempertahankan data; Hapus menghilangkan data setelah operasi berhasil; error ditampilkan. |
| US-06 | Sebagai petugas, saya ingin mengisi kriteria agar calon dibandingkan secara konsisten. | Ada tujuh dropdown skala 1–5; field wajib; perubahan disimpan melalui Simpan. |
| US-07 | Sebagai petugas, saya ingin melihat ranking agar dapat meninjau skor. | Skor dihitung dari nilai dan bobot; ranking menurun; hasil bertanda simulasi/bukan keputusan resmi. |
| US-08 | Sebagai petugas, saya ingin memakai aplikasi di web dan ponsel. | Layar sempit memakai NavigationBar; lebar memakai NavigationRail; seluruh menu bisa dibuka. |
| US-09 | Sebagai petugas, saya ingin keluar agar sesi tidak tetap aktif. | SignOut dipanggil di Firebase; mode demo menghapus sesi lokal; pengguna kembali ke Login. |

Kriteria di atas menjadi dasar pengujian. Status saat ini: US-01 sampai US-08 jalur mode demo sudah diuji otomatis (24 test lulus); jalur Firebase pada US-01 dan US-09 bagian Firebase belum diuji karena project belum dikonfigurasi.
