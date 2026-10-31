# Wireframe dan Keputusan Desain

Rancangan UTS menyebut lima halaman utama. SVG di folder docs/screenshots adalah wireframe statis untuk menunjukkan susunan halaman, bukan screenshot runtime.

Rancangan juga tersedia di Figma: [BLT-DD Prioritas — Wireframe](https://www.figma.com/make/xnbomh0HD3xaMEtZ0ehUwh/BLT-DD-Prioritas-Wireframe?t=xP6ZZ7tKgaItZh19-1). Tautan ini disediakan pemilik proyek. Lima SVG di bawah disertakan agar isi rancangan tetap dapat dibuka tanpa akun Figma.

## Prinsip
- Antarmuka memakai Bahasa Indonesia.
- Istilah halaman konsisten dengan presentasi UTS.
- Aksi diberi label, form menyediakan validasi, hapus meminta konfirmasi.
- Breakpoint target 760 px: NavigationBar pada layar sempit dan NavigationRail pada layar lebar.
- Warna primer maroon #7A1C2E mengikuti style guide presentasi; warna netral menjaga keterbacaan.

## Daftar halaman
| Halaman | Komponen utama | Wireframe |
|---|---|---|
| Login | Judul, status mode, email, kata sandi, tombol masuk | [01-login-wireframe.svg](../screenshots/01-login-wireframe.svg) |
| Beranda | Kartu ringkasan, catatan prototipe, pintasan | [02-beranda-wireframe.svg](../screenshots/02-beranda-wireframe.svg) |
| Data Calon Penerima | Daftar calon, ID simulasi, tambah/ubah/hapus | [03-data-calon-wireframe.svg](../screenshots/03-data-calon-wireframe.svg) |
| Penilaian & Prioritas | Tujuh kriteria, bobot demo, pintasan edit nilai | [04-penilaian-wireframe.svg](../screenshots/04-penilaian-wireframe.svg) |
| Hasil Prioritas | Peringkat, label simulasi, skor, penjelasan rumus | [05-hasil-prioritas-wireframe.svg](../screenshots/05-hasil-prioritas-wireframe.svg) |

Kelima SVG di atas disertakan sebagai aset rancangan; tautan Figma ada di bagian atas dokumen.

## Keputusan konsistensi
Tujuh kriteria dari presentasi menjadi acuan form dan model. ID dokumen dipisahkan dari ID simulasi yang dilihat pengguna. Form tambah/ubah menggunakan dialog yang sama. Hasil dihitung dari nilai, tidak diketik manual. Status demo dibedakan dari Firebase. Desain belum divalidasi melalui usability test.

## Implementasi aktual
Screenshot runtime hasil implementasi ada di `docs/screenshots/runtime/` (desktop 1280×800 dan mobile 390×844). Tampilan mengikuti prinsip di atas dengan penyesuaian: kartu ringkasan Beranda memakai `Wrap` agar tidak overflow pada layar sempit, dan dialog form dapat digulir.
