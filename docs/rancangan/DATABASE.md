# Rancangan Database

## Keputusan prototipe
Untuk menjaga alur CRUD awal sederhana, kode saat ini menyimpan data calon dan tujuh nilai kriteria pada satu dokumen di koleksi calon_penerima. Skor hasil prioritas dihitung di klien saat diperlukan dan belum disimpan sebagai snapshot historis.

## Koleksi yang dipakai kode: calon_penerima

| Field | Jenis | Wajib | Keterangan |
|---|---|---|---|
| ID dokumen | string | Ya | Dibuat Firestore; mode demo memakai ID internal lokal |
| idSimulasi | string | Ya | Kode sintetis unik dalam daftar termuat, misalnya SIM-001 |
| namaLabel | string | Ya | Label calon fiktif, bukan data warga |
| dusun | string | Ya | Dusun/kelompok simulasi |
| catatan | string | Tidak | Catatan opsional, maksimum 200 karakter pada form |
| scores.C1 sampai scores.C7 | integer 1–5 | Ya | Nilai tujuh kriteria |
| createdAt | timestamp | Ya saat Firebase | Server timestamp saat dibuat |
| updatedAt | timestamp | Ya saat Firebase | Server timestamp saat diubah |

Mapping: C1 Penghasilan keluarga; C2 Jumlah tanggungan; C3 Kondisi dinding; C4 Kondisi lantai; C5 Akses air bersih; C6 Sumber penerangan; C7 Tabungan keluarga.

Kontrak field di atas diuji otomatis (`Nilai kontrak Firestore sesuai field yang didokumentasikan`) dan serialisasi model menyimpan tepat tujuh nilai. Nama field harus tetap sinkron dengan `Candidate.toMap()`/`fromMap()`.

## Koleksi users

| Field | Jenis | Keterangan |
|---|---|---|
| ID dokumen | string | UID dari Firebase Authentication |
| role | string | `admin` atau `petugas`; dibaca oleh `firestore.rules` |
| nama | string | Nama petugas (opsional, tidak dibaca kode klien saat ini) |
| createdAt | timestamp | Opsional |

Dokumen ini dibuat manual oleh administrator melalui Console/jalur tepercaya. Rules saat ini menetapkan `allow write: if false` untuk `users`, sehingga user tidak dapat menaikkan role sendiri.

## Koleksi untuk fase berikutnya

| Koleksi | Field utama | Fungsi / relasi | Status |
|---|---|---|---|
| users | uid, nama, email, role, createdAt | ID dokumen adalah UID Firebase Auth; rules membaca role | Dipakai rules; provisioning manual |
| penilaian | calonId, nilaiKriteria, penilaiUid, updatedAt | Merujuk ID dokumen calon_penerima | Belum digunakan; skor sekarang nested di calon |
| kriteria_bobot | kode, nama, bobot, arah, versi | Konfigurasi versi kriteria/bobot | Belum digunakan; bobot konstanta model |
| hasil_prioritas | calonId, skorAkhir, peringkat, periode, versiBobot, createdAt | Snapshot hasil tiap periode | Belum digunakan; hasil dihitung saat tampilan dibuka |
| riwayat_proses | aksi, pelakuUid, waktu, ringkasan | Audit perubahan | Opsional, belum digunakan |

## Relasi dan pengamanan
Satu petugas dapat mengelola banyak calon. Satu calon mempunyai tujuh skor. Untuk histori multi-periode, hasil perlu menyimpan versi bobot dan periode agar peringkat lama tidak ikut berubah. Jangan commit data pribadi warga. ID simulasi bukan NIK. Jangan memakai rules terbuka. Role tidak boleh dapat diubah bebas dari klien oleh user biasa.
