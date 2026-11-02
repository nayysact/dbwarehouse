\# Bus Matrix \- Proses Produksi

Kelompok: 8  
Proses bisnis: Produksi (fact\_produksi)  
Grain: satu baris per work order (production.workorder)

\#\# Baris tim (format sama dengan bus matrix kelas)

\| Proses bisnis \| Tanggal \| Produk \| Pelanggan \| Wilayah \| Promosi \| Mata Uang \| Metode Kirim \| Sales Person \| Reseller \| Vendor \| Karyawan \| Alasan Scrap \| Jenis Transaksi \| Alasan Penjualan \|  
\|---------------\|:-------:\|:------:\|:---------:\|:-------:\|:-------:\|:---------:\|:------------:\|:------------:\|:--------:\|:------:\|:--------:\|:------------:\|:---------------:\|:----------------:\|  
\| Produksi      \|    ✔    \|   ✔    \|           \|         \|         \|           \|              \|              \|          \|        \|          \|      ✔       \|                 \|                  \|

Keterangan: ✔ \= dimensi dipakai oleh proses bisnis tersebut.

\#\# Dimensi yang dipakai

\| Dimensi \| Tabel dimensi \| Conformed? \| Keterangan \|  
\|---------\|---------------\|:----------:\|------------\|  
\| Tanggal \| dim\_tanggal \| Ya \| Dipakai semua proses bisnis. dim\_tanggal disediakan sponsor, nama kolom dan surrogate key mengikuti kesepakatan kelas. \|  
\| Produk \| dim\_produk \| Ya \| Dipakai Penjualan Online, Penjualan Reseller, Pembelian, Produksi, dan Pergerakan Persediaan. Strukturnya mengikuti kesepakatan kelas. \|  
\| Alasan Scrap \| dim\_alasan\_scrap \| Tidak \| Hanya dipakai proses Produksi. Perlu satu baris default "Tidak ada scrap" karena 71.862 dari 72.591 work order (±99%) tidak punya alasan scrap (lihat sql/hasil\_profil\_data.txt). \|

\#\# Catatan

\- Dimensi Tanggal dipakai dengan lebih dari satu peran pada tabel fakta: tanggal mulai, tanggal selesai, dan tanggal jatuh tempo. Semuanya mengacu ke dim\_tanggal yang sama.  
\- Dimensi lain di matriks (Pelanggan, Wilayah, Promosi, dan seterusnya) tidak dipakai karena work order tidak memiliki atribut tersebut.  
