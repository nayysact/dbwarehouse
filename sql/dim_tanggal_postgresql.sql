-- =====================================================================
--  dim_tanggal  standar kelas Data Warehouse  |  versi 1.0  |  PostgreSQL
--  Disediakan oleh sponsor. JANGAN mengubah struktur atau isi tabel ini.
--  Butuh atribut lain (misalnya hari libur)? Buat tabel tambahan yang
--  terhubung lewat tanggal_key.
--
--  Cara pakai : jalankan di database DW kelompok (bukan database sumber),
--               SEBELUM membuat tabel fakta.
--  Rentang    : 2010-01-01 s.d. 2015-12-31, ditambah baris -1.
-- =====================================================================

-- Tabel ini gagal dihapus jika sudah dirujuk tabel fakta. Itu disengaja,
-- supaya tidak terhapus tanpa sengaja.
DROP TABLE IF EXISTS dim_tanggal;

CREATE TABLE dim_tanggal (
    tanggal_key          INTEGER      PRIMARY KEY,  -- format YYYYMMDD, -1 = tidak diketahui
    tanggal              DATE         NOT NULL UNIQUE,
    tahun                INTEGER      NOT NULL,
    semester             INTEGER      NOT NULL,     -- 1 = Jan-Jun, 2 = Jul-Des
    kuartal              INTEGER      NOT NULL,     -- 1 s.d. 4
    bulan                INTEGER      NOT NULL,     -- 1 s.d. 12
    nama_bulan           VARCHAR(15)  NOT NULL,     -- Januari ... Desember
    minggu_dalam_tahun   INTEGER      NOT NULL,     -- minggu ISO 8601, 1 s.d. 53
    tanggal_dalam_bulan  INTEGER      NOT NULL,     -- 1 s.d. 31
    hari_dalam_minggu    INTEGER      NOT NULL,     -- Senin = 1 ... Minggu = 7
    nama_hari            VARCHAR(15)  NOT NULL,     -- Senin ... Minggu
    is_akhir_pekan       BOOLEAN      NOT NULL      -- true untuk Sabtu dan Minggu
);

-- Satu baris per hari
INSERT INTO dim_tanggal
SELECT
    TO_CHAR(g.d, 'YYYYMMDD')::INTEGER,
    g.d::DATE,
    EXTRACT(YEAR    FROM g.d)::INTEGER,
    CASE WHEN EXTRACT(MONTH FROM g.d) <= 6 THEN 1 ELSE 2 END,
    EXTRACT(QUARTER FROM g.d)::INTEGER,
    EXTRACT(MONTH   FROM g.d)::INTEGER,
    (ARRAY['Januari','Februari','Maret','April','Mei','Juni','Juli',
           'Agustus','September','Oktober','November','Desember'])[EXTRACT(MONTH FROM g.d)::INTEGER],
    EXTRACT(WEEK    FROM g.d)::INTEGER,   -- WEEK di PostgreSQL = minggu ISO
    EXTRACT(DAY     FROM g.d)::INTEGER,
    EXTRACT(ISODOW  FROM g.d)::INTEGER,   -- ISODOW: Senin = 1
    (ARRAY['Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu'])[EXTRACT(ISODOW FROM g.d)::INTEGER],
    EXTRACT(ISODOW  FROM g.d) IN (6, 7)
FROM generate_series(DATE '2010-01-01', DATE '2015-12-31', INTERVAL '1 day') AS g(d);

-- Baris "Tidak diketahui" untuk fakta yang tanggalnya kosong
INSERT INTO dim_tanggal VALUES
    (-1, DATE '1900-01-01', 0, 0, 0, 0, 'Tidak diketahui', 0, 0, 0, 'Tidak diketahui', FALSE);

COMMENT ON TABLE dim_tanggal IS 'Dimensi tanggal standar kelas DW, versi 1.0';

-- ---------------------------------------------------------------------
--  Pemeriksaan (hasil yang diharapkan ada di komentar)
-- ---------------------------------------------------------------------
-- 1. Jumlah baris: 2191 hari + 1 baris tidak diketahui = 2192
SELECT COUNT(*) AS jumlah_baris FROM dim_tanggal;

-- 2. Rentang tanggal: 2010-01-01 s.d. 2015-12-31
SELECT MIN(tanggal) AS awal, MAX(tanggal) AS akhir FROM dim_tanggal WHERE tanggal_key > 0;

-- 3. Contoh: 2013-03-15 adalah Jumat, kuartal 1, minggu ISO 11
SELECT * FROM dim_tanggal WHERE tanggal_key = 20130315;

-- 4. Perhatikan: 1 Januari bisa masuk minggu ISO 52/53 tahun sebelumnya
SELECT tanggal, nama_hari, minggu_dalam_tahun FROM dim_tanggal
WHERE tanggal IN (DATE '2010-01-01', DATE '2011-01-01', DATE '2012-01-01');
