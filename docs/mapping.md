Target: **dim\_tanggal** (SCD: tipe 0\)  
Sumber utama: tidak ada (dibangkitkn skrip standar sponsor v1.0, 1 Jan 2010 s.d. 31 Des 2015\)

| Kolom Target | Tipe | Tabel.kolom sumber | Transformasi | Aturan NULL |
| ----- | ----- | :---: | ----- | ----- |
| tanggal\_key | INT | \- | skrip sponsor, format YYYYMMDD | \-1 (baris “Tidak diketahui”) |
| tanggal | DATE | \- | skrip sponsor | \- |
| tahun | INT | \- | skrip sponsor | \- |
| semester | INT | \- | skrip sponsor | \- |
| kuartal | INT | \- | skrip sponsor | \- |
| bulan | INT | \- | skrip sponsor | \- |
| nama\_bulan | VARCHAR(15) | \- | skrip sponsor, bahasa Indonesia | \- |
| minggu\_dalam\_tahun | INT | \- | skrip sponsor, ISO week | \- |
| tanggal\_dalam\_bulan | INT | \- | skrip sponsor | \- |
| hari\_dalam\_minggu | INT | \- | skrip sponsor, Senin \= 1 | \- |
| nama\_hari | VARCHAR(15) | \- | skrip sponsor, bahasa Indonesia | \- |
| is\_akhir\_pekan | BOOLEAN | \- | skrip sponsor | \- |

Target: **dim\_produk** (SCD: tipe 0, 1, dan 2\)  
Sumber utama: production.product

| Kolom Target | Tipe | Tabel.kolom sumber | Transformasi | Aturan NULL |
| ----- | ----- | ----- | ----- | ----- |
| produk\_key | INT | \- | surrogate key dari DW, satu per versi SCD tipe 2 | \-1 (baris “Tidak diketahui”) |
| produk\_id | INT | product.productid | langsung, natural key | \- |
| nama\_produk | VARCHAR(50) | product.name | langsung (tipe 1\) | \- |
| nomor\_produk | VARCHAR(25) | product.productnumber | langsung (tipe 0\)  | \- |
| warna | VARCHAR(15) | product.color | langsung (tipe 1\) | “Tidak ada” |
| subkategori | VARCHAR(50) | productsubcategory.name | LEFT JOIN lewat productsubcategoryid (tipe 1\) | “Tanpa kategori” |
| kategori | VARCHAR(50) | productcategory.name | LEFT JOIN lewat productcategoryid, diratakan ke dimensi (tipe 1\) | “Tanpa kategori” |
| biaya\_standar | NUMERIC(12,4) | productcosthistory.standardcost | sesuai periode berlaku (tipe 2\) | tanpa riwayat: product.standardcost |
| harga\_jual | NUMERIC(12,4) | productlistpricehistory.listprice | sesuai periode berlaku (tipe 2\) | tanpa riwayat: product.listprice |
| berlaku\_mulai | DATE | productcosthistory.startdate, productlistpricehistory.startdate  | dibentuk proses SCD tipe 2 | tanpa riwayat: product.sellstartdate |
| berlaku\_sampai | DATE | productcosthistory.enddate, productlistpricehistory.enddate | dibentuk proses SCD tipe 2  | 9999-12-31 |
| is\_current | BOOLEAN |  | true jika berlaku\_sampai \= 9999-12-31 | \- |

Target: **dim\_alasan\_scrap** (SCD: tipe 1\)  
Sumber utama: production.scrapreason

| Kolom Target | Tipe | Tabel.kolom sumber | Transformasi | Aturan NULL |
| ----- | ----- | ----- | ----- | ----- |
| alasan\_scrap\_key | INT  | \- | surrogate key dari DW  | \-1 (Tidak diketahui), 0 (Tidak ada scrap)  |
| alasan\_scrap\_id  | INT | screapreason.screapreasonid | langsung, natural key  | \- |
| nama\_alasan | VARCHAR (50) | scrapreason.name | langsung | “Tidak ada scrap” (baris key 0\)  |

Target: **dim\_lokasi**   (SCD: tipe 1\)  
Sumber utama: production.location

| Kolom Target | Tipe | Tabel.kolom sumber | Transformasi | Aturan NULL |
| ----- | ----- | ----- | ----- | ----- |
| lokasi\_key | INT  | \- | surrogate key dari DW  | \-1 (baris “Tidak Diketahui” |
| lokasi\_id | INT | location.locationid | langsung, natural key | \- |
| nama\_lokasi | VARCHAR (50) | location.name | langsung | “Tidak diketahui” |
| tarif\_biaya | NUMERIC (12,4) | location.costrate | langsung | 0 |
| ketersediaan | NUMERIC (9,2) | location.availability | langsung | 0 |

Target: **fact\_produksi** (grain: satu baris per work order, 72.591 baris)  
Sumber utama: production.workorder

| Kolom Target | Tipe | Tabel.kolom sumber | Transformasi | Aturan NULL |
| ----- | ----- | ----- | ----- | ----- |
| workorder\_id | INT | workorder.workorderid | langsung, degenerate dimension | \- |
| produk\_key | INT | workorder.productid | cari di dim\_produk: produk\_id sama dan startdate BETWEEN berlaku\_mulai AND berlaku\_sampai | \-1 |
| tanggal\_mulai\_key | INT | workorder.startdate | tanggal ke YYYYMMDD | \-1 |
| tanggal\_selesai\_key | INT | workorder.enddate | tanggal ke YYYYMMDD | \-1 |
| tanggal\_jatuh\_tempo\_key | INT | workorder.duedate | tanggal ke YYYYMMDD | \-1 |
| alasan\_scrap\_key | INT | workorder.scrapreasonid | cari di dim\_alasan\_scrap lewat alasan\_scrap\_id | 0 (Tidak ada scrap) |
| orderqty | INT | workorder.orderqty | langsung | 0 |
| stockedqty | INT | workorder.stockedqty | langsung | 0 |
| scrappedqty | INT | workorder.scrappedqty | langsung | 0 |
| lama\_produksi\_hari | INT | workorder.enddate, workorder.startdate | enddate dikurangi startdate (hari) | NULL jika enddate kosong |
| hari\_terlambat | INT | workorder.enddate, workorder.duedate | GREATEST(enddate \- duedate, 0\) (hari) | NULL jika enddate kosong |

Target: **fact\_produksi\_tahap**   (grain: satu baris per tahap kerja per work order, 67.131 baris)  
Sumber utama: production.workorderrouting

| Kolom Target | Tipe | Tabel.kolom sumber | Transformasi | Aturan NULL |
| ----- | ----- | ----- | ----- | ----- |
| workorder\_id | INT | workorderrouting.workorderid  | langsung, degenerate dimension  | \- |
| operatuon\_sequence | INT | workorderrouting.operationsequence | langsung, degenerate dimension | \- |
| produk\_key | INT | workorder.productid  | JOIN workorder lewat workorderid, cari di dim\_produk dengan startdate work order  | \-1 |
| lokasi\_key | INT | workorderrouting.locationid  | cari di dim\_lokasi lewat lokasi\_id  | \-1 |
| tanggal\_jadwal\_mulai\_key  | INT | workorderrouting.scheduledstartdate  | tanggal ke YYYYMMDD  | \-1 |
| tanggal\_jadwal\_selesai\_key  | INT | workorderrouting.scheduledenddate  | tanggal ke YYYYMMDD  | \-1 |
| tanggal\_aktual\_mulai\_key  | INT | workorderrouting.actualstartdate  | tanggal ke YYYYMMDD  | \-1 |
| tanggal\_aktual\_selesai\_key  | INT | workorderrouting.actualenddate  | tanggal ke YYYYMMDD  | \-1 |
| jam\_sumber\_daya\_aktual | NUMERIC (9,4)  | workorderrouting.actualresourcehrs  | langsung | 0 |
| biaya\_rencana | NUMERIC (12,4)  | workorderrouting.plannedcost  | langsung | 0 |
| biaya\_aktual  | NUMERIC (12,4)  | workorderrouting.actualcost  | langsung | 0 |
| selisih\_biaya | NUMERIC (12,4)  | workorderrouting.actualcost, plannedcost  | actualcost dikurangi plannedcost  | NULL jika salah satu kosong  |
| durasi\_aktual\_hari  | INT | workorderrouting.actualenddate, actualstartdate  | selisih tanggal aktual (hari)  | NULL jika salah satu kosong  |
| selisih\_jadwal\_hari  | INT | workorderrouting.actualenddate, scheduledenddate  | actualenddate dikurangi scheduledenddate (hari)  | NULL jika salah satu kosong |

**Urutan Load :**

1. Kosongkan semua tabel stg\_  
2. Ekstrak sumber ke stg\_workorder, stg\_workorderrouting, stg\_product, stg\_productsubcategory, stg\_productcategory, stg\_productcosthistory, stg\_productlistpricehistory, stg\_scrapreason, stg\_location  
3. Bersihkan dan standarkan di staging (NULL jadi label, format tanggal)  
4. dim\_tanggal (dari skrip standar sponsor, termasuk baris \-1)  
5. dim\_alasan\_scrap (baris default \-1 dan 0 dibuat dulu)  
6. dim\_lokasi (baris default \-1 dibuat dulu)  
7. dim\_produk (SCD tipe 2, baris default \-1 dibuat dulu)  
8. fact\_produksi  
9. fact\_produksi\_tahap  
10. Rekonsiliasi dengan sumber: 72.591 baris fakta produksi, 67.131 baris fakta tahap, total orderqty dan scrappedqty sama