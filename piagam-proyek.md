**Piagam Proyek Data Warehouse**

Kelompok	: 8  
Proses bisnis	: Produksi  
Sponsor	: Mohamad Irwan Afandi, ST, M.Sc.

1. Latar belakang  
   Masalah apa yang dihadapi manajemen Adventure Works?  
   Adventure Works memproduksi ribuan work order setiap tahun, tetapi data produksi (jumlah produksi, scrap, dan lama produksi) tersimpan di database operasional dan belum bisa dianalisis dengan mudah. Manajemen kesulitan melihat produk dan penyebab scrap yang paling banyak membuang unit, serta tren produksi dari waktu ke waktu. Data warehouse dan dashboard dibangun agar informasi ini bisa dilihat cepat dan konsisten.  
     
2. Tujuan dan pertanyaan bisnis  
   Minimal 5 pertanyaan yang harus bisa dijawab dashboard.

| Pertanyaan bisnis  | Fakta (ukuran)  | Dimensi (sudut pandang)  |
| :---- | :---- | :---- |
| Berapa total unit yang diproduksi dan yang masuk stok tiap bulan, dan bulan mana yang tertinggi?  | Jumlah diproduksi, jumlah masuk stok  | Tanggal (bulan)  |
| Produk mana yang menghasilkan scrap paling banyak?  | Jumlah scrap  | Produk  |
| Alasan scrap apa yang paling banyak menyebabkan unit terbuang?  | Jumlah scrap, jumlah diproduksi  | Alasan Scrap  |
| Kategori produk apa yang rata-rata lama produksinya paling lama?  | Lama produksi (hari)  | Produk (kategori)  |
| Bagaimana tren persentase scrap tiap kuartal?  | Jumlah scrap, jumlah diproduksi  | Tanggal (kuartal)  |
| Alasan scrap apa yang paling dominan pada tiap produk per tahun?  | Jumlah scrap  | Alasan Scrap, Produk, Tanggal (tahun)  |

   

   

3. Ruang lingkup  
   **Masuk lingkup:**  
   A. Proses bisnis: Produksi (work order) pada database AdventureWorks.  
   B. Rentang tahun data: sesuai data work order yang tersedia di database sumber (isi setelah profiling data, misalnya 2011-2014).  
   C. Tabel sumber: production.workorder, production.scrapreason, production.product, production.productsubcategory, production.productcategory.  
   D. Ukuran yang dianalisis: jumlah diproduksi, jumlah masuk stok, jumlah scrap, dan lama produksi (hari).  
   E.  Dimensi: tanggal (bulan, kuartal, tahun), produk (termasuk kategori), dan alasan scrap.  
   F. Keluaran: data warehouse (dw\_kelompok\_8), proses ETL dengan Pentaho, kubus OLAP dengan Mondrian, dan dashboard yang menjawab 6 pertanyaan bisnis.

   **Di luar lingkup**:  
    A. Data di luar tabel produksi yang sudah ditetapkan, seperti data pelanggan, vendor, dan keuangan.  
    B. Analisis biaya produksi, profit, dan harga pokok.  
    C. Analisis efisiensi lokasi kerja (work center/workorderrouting) dan kinerja karyawan.  
    D. Analisis prediktif (peramalan produksi dan prediksi scrap).  
    E. Pemuatan data real-time; ETL berjalan secara batch.  
    F. Penerapan di lingkungan produksi, pengaturan hak akses pengguna, dan pemeliharaan setelah proyek selesai.  
    G. Perubahan atau perbaikan data di database sumber; data hanya dibaca dan nilai kosong ditangani di sisi ETL.

4. Tim dan peran :   
   A. Riska Febriana Rahmawati \| 23082010136 \| Data Modeler \|  
   B. Jamila Farhana \| 23082010155 \| Dashboard Developer \|

C. Andina Kanaya Azzahra \| 23082010158 \| ETL Developer \|  
	D. Khonsa' Abidah \| 23082010160 \| OLAP Developer \|

5. Lingkungan teknis  
   A. Sumber: PostgreSQL (adventureworks)   
   B. Target: PostgreSQL/MySQL (dw\_kelompok\_8)  
   C. ETL: Pentaho Data Integration CE    
   D. OLAP: Mondrian     
   E. Dashboard: (chart library)

6. Risiko awal

| Risiko | Dampak | Rencana Penanganan |
| ----- | ----- | ----- |
| Kolom scrapreasonid bernilai NULL pada 71.862 dari 72.591 work order (±99%), karena hanya 729 work order yang mengalami scrap | Relasi ke dimensi alasan scrap gagal, dan baris tanpa scrap bisa hilang atau salah dihitung dalam analisis | Buat baris default “Tidak ada scrap” di dim\_scrap\_reason, dan tangani NULL di sisi ETL tanpa mengubah database sumber |
| Kesalahan perhitungan jumlah produksi, unit masuk stok, dan scrap. | Angka pada dashboard tidak sesuai dengan data sumber dan dapat menghasilkan kesimpulan yang keliru. | Memvalidasi rumus perhitungan dan membandingkan hasil ETL dengan query pada database sumber Adventure Works. |
| Data dari beberapa tabel produksi tidak terhubung dengan benar. | Terjadi penghitungan ganda sehingga total produksi dan scrap menjadi lebih besar dari nilai sebenarnya. | Memeriksa relasi antartabel, menggunakan kunci yang tepat, dan memvalidasi hasil JOIN sebelum proses ETL. |

   

7. Kriteria sukses  
    1. Data produksi berhasil diekstrak dan dimuat ke data warehouse melalui proses ETL.  
    2. Hasil perhitungan jumlah produksi dan scrap pada data warehouse sesuai dengan hasil query validasi pada database sumber, berdasarkan definisi metrik yang telah disepakati.  
    3. Dashboard dapat menjawab seluruh pertanyaan bisnis yang tercantum dalam piagam proyek.  
    4. Pengguna dapat menganalisis tren produksi dan persentase scrap berdasarkan periode waktu serta membandingkan scrap berdasarkan produk dan alasan scrap.  
    5. Perhitungan rata-rata lama produksi hanya menggunakan data yang memenuhi aturan perhitungan yang telah ditetapkan.

     
   \\

