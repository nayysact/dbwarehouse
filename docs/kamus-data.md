**Kamus Data Warehouse Produksi Adventure Works**

1. **Ringkasan tabel**

| Tabel | Jenis | Satu baris berisi  |
| :---- | :---- | :---- |
| dim\_tanggal | Dimensi | Satu hari  |
| dim\_produk | Dimensi | Satu versi produk |
| dim\_alasan\_scrap | Dimensi | Satu alasan scrap  |
| dim\_lokasi | Dimensi | Satu lokasi kerja |
| fact\_produksi | Fakta | Satu work order |
| fact\_produksi\_tahap | Fakta | Satu tahap kerja pada satu work order |

   Setiap dimensi punya baris \-1 "Tidak diketahui" untuk data kosong, dan dim\_alasan\_scrap punya baris tambahan 0 "Tidak ada scrap". 

2. **dim\_tanggal**  
   dim\_tanggal adalah tabel kalender. Setiap baris mewakili satu hari, dari 1 Januari 2010 sampai 31 Desember 2015, ditambah satu baris \-1 untuk tanggal yang tidak diketahui. Totalnya 2192 baris. 

| Kolom | Tipe | Arti  | Contoh | Catatan  |
| :---- | :---- | :---- | :---- | :---- |
| Tanggal\_key (PK) | INT | Nomor pengenal tanggal, ditulis tahun-bulan-tanggal | 20130315 | Dibuat YYYYMMDD, bukan nomor urut, supaya langsung terbaca sebagai tanggal dan urutannya sama dengan urutan waktu. \-1 berarti tanggal tidak diketahui. |
| tanggal | DATE | Tanggalnya | 2013-03-15 | Baris \-1 memakai 1900-01-01. Kolom ini wajib terisi, dan tanggal itu jauh di luar data kami (2010 sampai 2015), jadi jelas bukan tanggal asli. |
| tahun | INT | Tahun | 2013 | Untuk analisis per tahun, pakai kolom ini. |
| semester | INT | Setengah tahun. 1 \= Januari sampai Juni, 2 \= Juli sampai Desember | 1 |  |
| kuartal | INT | Tiga bulanan, 1 sampai 4 | 1 |  |
| bulan | INT | Nomor bulan, 1 sampai 12 | 3 |  |
| nama\_bulan | VARCHAR (15) | Nama bulan | Maret | Bahasa Indonesia. |
| minggu\_dalam\_tahun | INT | Nomor minggu menurut standar ISO 8601 | 11 | 1 Januari bisa masuk minggu 52 atau 53 tahun sebelumnya. |
| tanggal\_dalam\_bulan | INT | Tanggal di dalam bulan, 1 sampai 31 | 15 |  |
| hari\_dalam\_minggu | INT | Nomor hari. Senin \= 1 sampai Minggu \= 7 | 5 | Minggu dimulai dari Senin karena itu aturan ISO 8601, sama dengan minggu\_dalam\_tahun. |
| nama\_hari | VARCHAR(15) | Nama hari | Jumat | Bahasa Indonesia. |
| is\_akhir\_pekan | BOOLEAN | Benar kalau Sabtu atau Minggu | false |  |

   Baris \-1: kolom angka bernilai 0, kolom teks bernilai "Tidak diketahui", is\_akhir\_pekan bernilai false.

3. **dim\_produk**  
   Satu produk bisa punya lebih dari satu baris. Biaya standar dan harga jual bisa berubah dari waktu ke waktu, dan setiap perubahan dicatat sebagai baris baru. Nama, warna, subkategori, dan kategori kalau berubah langsung diganti di semua baris produk itu.

| Kolom | Tipe | Arti  | Contoh | Catatan  |
| :---- | :---- | :---- | :---- | :---- |
| produk\_key | INT | Nomor pengenal di DW, dibuat otomatis, satu per versi produk | 1 | \-1 \= tidak diketahui. |
| produk\_id | INT | Kode produk di database sumber | 680 | Sama untuk semua versi produk yang sama. |
| nama\_produk | VARCHAR(50) | Nama produk | HL Road Frame \- Black, 58 |  |
| nomor\_produk | VARCHAR(25) | Nomor produk | FR-R92B-58 | Tidak pernah diubah. |
| warna | VARCHAR(15) | Warna produk | Black | Kalau kosong diisi "Tidak ada". |
| subkategori | VARCHAR(50) | Subkategori produk | Road Frames | Kalau kosong diisi "Tanpa kategori". |
| kategori | VARCHAR(50) | Kategori produk | Components | Kalau kosong diisi "Tanpa kategori". |
| biaya\_standar | NUMERIC(12,4) | Biaya standar produk pada masa berlaku versi ini | 1059.3100 | Kalau produk tidak punya riwayat biaya, dipakai biaya di data produk. |
| harga\_jual | NUMERIC(12,4) | Harga jual pada masa berlaku versi ini | 1431.5000 | Kalau produk tidak punya riwayat harga, dipakai harga di data produk. |
| berlaku\_mulai | DATE | Tanggal versi ini mulai berlaku | 2008-04-30 | Kalau tidak ada riwayat, dipakai tanggal mulai dijual. |
| berlaku\_sampai | DATE | Tanggal versi ini selesai berlaku | 9999-12-31 | 9999-12-31 artinya masih berlaku. |
| is\_current | BOOLEAN | Benar kalau ini versi yang berlaku sekarang | true | Satu produk hanya punya satu versi yang bernilai true. |

4. **dim\_alasan\_scrap**  
   Daftar alasan sebuah produk dibuang (scrap). Kalau nama alasan berubah, langsung diganti. 

| Kolom | Tipe | Arti  | Contoh | Catatan  |
| :---- | :---- | :---- | :---- | :---- |
| alasan\_scrap\_key | INT | Nomor pengenal di DW, dibuat otomatis | 1 | \-1 \= tidak diketahui, 0 \= tidak ada scrap. |
| alasan\_scrap\_id | INT | Kode alasan di database sumber | 1 |  |
| nama\_alasan | VARCHAR(50) | Nama alasan scrap | Brake assembly not as ordered | Baris 0 berisi "Tidak ada scrap", dipakai untuk work order yang tidak mengalami scrap (sekitar 99% work order). |

5. **dim\_lokasi**  
   Daftar lokasi kerja di pabrik. Kalau datanya berubah, langsung diganti. 

| Kolom | Tipe | Arti  | Contoh | Catatan  |
| :---- | :---- | :---- | :---- | :---- |
| lokasi\_key | INT | Nomor pengenal di DW, dibuat otomatis | 1 | \-1 \= tidak diketahui. |
| lokasi\_id | INT | Kode lokasi di database sumber | 10 |  |
| nama\_lokasi | VARCHAR(50) | Nama lokasi kerja | Frame Forming |  |
| tarif\_biaya | NUMERIC(12,4) | Tarif biaya lokasi | 22.5000 | Kalau kosong diisi 0\. |
| ketersediaan | NUMERIC(9,2) | Jumlah jam lokasi tersedia | 96.00 | Kalau kosong diisi 0\. |

6. **fact\_produksi**  
   Grain: satu baris per work order. Sumber utama: production.workorder.

| Kolom | Tipe | Arti  | Contoh | Catatan  |
| :---- | :---- | :---- | :---- | :---- |
| workorder\_id | INT | Nomor work order | 13 | Tidak ada dua baris dengan nomor yang sama. |
| produk\_key | INT | Produk yang dibuat | 1 | Mengarah ke dim\_produk. Kalau tidak ketemu, diisi \-1. |
| tanggal\_mulai\_key | INT | Tanggal mulai | 20110603 | Mengarah ke dim\_tanggal. Kalau kosong, diisi \-1. |
| tanggal\_selesai\_key | INT | Tanggal selesai | 20110619 | Mengarah ke dim\_tanggal. Kalau kosong, diisi \-1. |
| tanggal\_jatuh\_tempo\_key | INT | Tanggal batas penyelesaian | 20110614 | Mengarah ke dim\_tanggal. Kalau kosong, diisi \-1. |
| alasan\_scrap\_key | INT | Alasan scrap | 0 | Mengarah ke dim\_alasan\_scrap. Kalau tidak ada scrap, diisi 0\. |
| orderqty | INT | Jumlah yang diproduksi | 4 | Kalau kosong diisi 0\. |
| stockedqty | INT | Jumlah yang masuk stok | 4 | Kalau kosong diisi 0\. |
| scrappedqty | INT | Jumlah yang di-scrap | 0 | Kalau kosong diisi 0\. |
| lama\_produksi\_hari | INT | Berapa hari dari mulai sampai selesai | 16 | Dikosongkan kalau tanggal selesai kosong. |
| hari\_terlambat | INT | Berapa hari selesai setelah tanggal batas | 5 | Tidak pernah negatif. Dikosongkan kalau tanggal selesai kosong. |

7. **fact\_produksi\_tahap**  
   Grain: satu baris per tahap kerja per work order. Sumber utama: production.workorderrouting.

| Kolom | Tipe | Arti  | Contoh | Catatan  |
| :---- | :---- | :---- | :---- | :---- |
| workorder\_id | INT | Nomor work order | 13 | Bersama operation\_sequence menjadi pengenal baris. Mengarah ke fact\_produksi. |
| operation\_sequence | INT | Urutan tahap dalam work order | 1 |  |
| produk\_key | INT | Produk yang dibuat | 1 | Mengarah ke dim\_produk. Kalau tidak ketemu, diisi \-1. |
| lokasi\_key | INT | Lokasi tempat tahap dikerjakan | 1 | Mengarah ke dim\_lokasi. Kalau tidak ketemu, diisi \-1. |
| tanggal\_jadwal\_mulai\_key | INT | Tanggal mulai menurut jadwal | 20110603 | Mengarah ke dim\_tanggal. Kalau kosong, diisi \-1. |
| tanggal\_jadwal\_selesai\_key | INT | Tanggal selesai menurut jadwal | 20110614 | Mengarah ke dim\_tanggal. Kalau kosong, diisi \-1. |
| tanggal\_aktual\_mulai\_key | INT | Tanggal mulai sebenarnya | 20110603 | Mengarah ke dim\_tanggal. Kalau kosong, diisi \-1. |
| tanggal\_aktual\_selesai\_key | INT | Tanggal selesai sebenarnya | 20110619 | Mengarah ke dim\_tanggal. Kalau kosong, diisi \-1. |
| jam\_sumber\_daya\_aktual | NUMERIC(9,4) | Jam kerja yang terpakai | 4.1000 | Kalau kosong diisi 0\. |
| biaya\_rencana | NUMERIC(12,4) | Biaya menurut rencana | 92.2500 | Kalau kosong diisi 0\. |
| biaya\_aktual | NUMERIC(12,4) | Biaya sebenarnya | 92.2500 | Kalau kosong diisi 0\. |
| selisih\_biaya | NUMERIC(12,4) | Biaya aktual dikurangi biaya rencana | 0.0000 | Positif berarti lebih mahal dari rencana. Dikosongkan kalau salah satu biaya kosong. |
| durasi\_aktual\_hari | INT | Berapa hari dari mulai sampai selesai sebenarnya | 16 | Dikosongkan kalau salah satu tanggal aktual kosong. |
| selisih\_jadwal\_hari | INT | Tanggal selesai sebenarnya dikurangi tanggal selesai jadwal, dalam hari | 5 | Positif berarti terlambat. Dikosongkan kalau salah satu tanggal kosong. |

   

