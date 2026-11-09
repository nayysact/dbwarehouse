**STRATEGI SCD: PROSES PRODUKSI**

Tipe 0 \= nilai tidak pernah diubah. Tipe 1 \= nilai lama ditimpa. Tipe 2 \= baris baru ditambah, baris lama ditutup.

**Dim\_tanggal**

| Kolom | Tipe | Alasan |
| ----- | ----- | ----- |
| Semua kolom (tanggal, tahun, semester, kuartal, bulan, nama\_bulan, nama\_hari, dan seterusnya) | 0 | Fakta kalender tidak pernah berubah: 15 Maret 2013 selalu hari Jumat dan kuartal 1\. Tabel ini dibangkitkan skrip standar sponsor, bukan dari sumber, dan tidak diubah ETL |

**Dim\_produk**

| Kolom | Tipe | Alasan |
| ----- | ----- | ----- |
| produk\_id | Natural key | Dipakai ETL untuk mencocokkan baris dimensi dengan product.productid |
| nomor\_produk | 0 | Kode produk adalah identitas, tidak boleh berubah setelah masuk |
| nama\_produk | 1 | Perubahan nama biasanya perbaikan penulisan, dan analisis scrap tidak butuh nama lama |
| warna | 1 | Perbaikan atribut, riwayatnya tidak dianalisis |
| subkategori | 1 | Pertanyaan bisnis memakai kategori produk terkini. Kalau tipe 2, satu produk terpecah jadi banyak baris tanpa manfaat bagi enam pertanyaan di piagam |
| kategori | 1 | Alasan sama dengan subkategori |
| biaya\_standar | 2 | Biaya standar berubah dari waktu ke waktu dan sumber menyimpan riwayatnya (production.productcosthistory). Work order tahun 2011 harus memakai biaya standar tahun 2011, bukan biaya terbaru |
| harga\_jual | 2 | Sama: production.productlistpricehistory menyimpan riwayat harga. Riwayat dijaga supaya analisis tidak bergeser saat harga berubah |
| berlaku\_mulai, berlaku\_sampai, is\_current | Kolom SCD | Penanda periode berlaku tiap versi baris tipe 2 |

**Dim\_alasan\_scrap**

| Kolom | Tipe | Alasan |
| ----- | ----- | ----- |
| nama\_alasan | 1 | Hanya 16 alasan dan sangat jarang berubah. Kalau nama diperbaiki, nama lama tidak dibutuhkan |

**Dim\_lokasi**

| Kolom | Tipe | Alasan |
| ----- | ----- | ----- |
| nama\_lokasi | 1 | Perbaikan penulisan, riwayat tidak dianalisis |
| tarif\_biaya | 1 | Hanya 14 lokasi kerja, dan analisis tidak membandingkan tarif antarperiode |
| ketersediaan | 1 | Atribut deskriptif, riwayat tidak dibutuhkan |

**Cara kerja tipe 2 di dim\_produk**

| Kejadian | Tindakan ETL |
| ----- | ----- |
| Produk baru | Tambah satu baris: berlaku\_mulai \= awal riwayat, berlaku\_sampai \= 9999-12-31, is\_current \= true |
| biaya\_standar atau harga\_jual berubah | Tutup baris lama (berlaku\_sampai \= tanggal perubahan dikurangi 1 hari, is\_current \= false), lalu tambah baris baru dengan produk\_key baru dan is\_current \= true |
| Kolom tipe 1 berubah (nama, warna, subkategori, kategori) | Timpa di semua baris produk\_id tersebut, tanpa baris baru |
| Kolom tipe 0 (nomor\_produk) | Tidak pernah diubah |
| Produk tanpa riwayat biaya atau harga | Satu baris saja dengan nilai dari product.standardcost dan product.listprice, berlaku\_sampai \= 9999-12-31 |

**Pengaruh ke tabel fakta dan cube**

| Hal | Aturan |
| ----- | ----- |
| Mencari produk\_key saat memuat fakta | Pakai produk\_id yang sama dan startdate work order BETWEEN berlaku\_mulai AND berlaku\_sampai. Jangan pakai is\_current \= true, karena biayanya tidak sesuai waktu produksi |
| fact\_produksi\_tahap | Pakai startdate work order induknya |
| Menghitung jumlah produk di cube | Distinct count pada produk\_id, bukan produk\_key, karena satu produk bisa punya beberapa key |

