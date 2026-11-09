**Dokumen Desain Cube**

1. Desain Cube Table Fact Produksi

| Elemen | Produksi | Asal di DW |
| :---- | :---- | :---- |
| Nama Cube | Produksi | fact\_produksi |
| Dimensi Waktu | Tahun \> Kuartal \> Bulan \> Tanggal | Dim\_tanggal lewat tanggal\_mulai\_key |
| Dimensi Produk | Kategori \> Subkategori \> Produk | Dim\_produk lewat produk\_key |
| Dimensi alasan scrap | Alasan Scrap (satu lvl) | Dim\_alasan\_scrap lewat tanggal\_jatuh\_tempo\_key |
| Degenerate Dimension | Work Order | workorder\_id |
| Measure | Jumlah Diproduksi (sum), Jumlah Masuk Stok (sum), Jumlah Scrap (sum), Jumlah Work Order (distinct count), Total Lama Produksi (sum), Jumlah WO Selesai (count lama\_produksi\_hari), Total Hari Terlambat (sum) | Dari table fakta (orderqty, stockedqty, scrappedqty, workorder\_id, lama\_produksi\_hari, hari\_terlambat) |
| Calculated Member | Persentase Scrap % \= Jumlah Scrap / Jumlah Diproduksi; Persentase Masuk Stok % \= Jumlah Masuk Stok / Jumlah Diproduksi; Rata-rata Lama Produksi \= Total Lama Produksi / Jumlah WO Selesai | Dihitung di cube |

2. Desain Cube Table Fact Produksi Tahap

| Elemen | Produksi Tahap | Asal di DW |
| :---- | :---- | :---- |
| Nama Cube | Produksi Tahap | pact\_produksi\_tahap |
| Dimensi Jadwal Mulai | Tahun \> Kuartal \> Bulan \> Tanggal | Dim\_tanggal lewat tanggal\_jadwal\_mulai\_key |
| Dimensi Jadwal Selesai | Tahun \> Kuartal \> Bulan \> Tanggal | Dim\_tanggal lewat tanggal\_jadwal\_selesai\_key |
| Dimensi Aktual Mulai | Tahun \> Kuartal \> Bulan \> Tanggal | Dim\_tanggal lewat tanggal\_aktual\_mulai\_key |
| DImensi Aktual Selesai | Tahun \> Kuartal \> Bulan \> Tanggal | Dim\_tanggal lewat tanggal\_aktual\_selesai\_key |
| Dimensi Produk | Kategori \> Subkategori \> Produk | Dim\_produk lewat produk\_key |
| Dimensi Lokasi | Lokasi (satu level) | Dim\_lokasi lewat lokasi\_key |
| Degenerate dimension | Work Order, Urutan Operasi | Workorder\_id, operation\_sequence |
| Measure  | Jam Sumber Daya Aktual (sum), Biaya Rencana (sum), Biaya Aktual (sum), Selisih Biaya (sum), Durasi Aktual (sum), Selisih Jadwal (sum), Jumlah Operasi (count), Jumlah Operasi Selesai (count) | Dari tabel fakta (jam\_sumber\_daya\_aktual, biaya\_rencana, biaya\_aktual, selisih\_biaya, durasi\_aktual\_hari, selisih\_jadwal\_hari, operation\_sequence) |
| Calculated Member | Persentase Selisih Biaya % \= Selisih Biaya / Biaya Rencana;  Rata-rata Durasi Aktual \= Durasi Aktual / Jumlah Operasi | Dihitung di cube |

