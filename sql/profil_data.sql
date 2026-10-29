-- =====================================================
-- PROFIL DATA SUMBER: PROSES PRODUKSI
-- Database: adventureworks 
-- =====================================================

-- 1. JUMLAH BARIS tabel sumber
SELECT 'production.workorder' AS tabel, COUNT(*) AS jumlah_baris FROM production.workorder
UNION ALL SELECT 'production.workorderrouting', COUNT(*) FROM production.workorderrouting
UNION ALL SELECT 'production.product', COUNT(*) FROM production.product
UNION ALL SELECT 'production.productsubcategory', COUNT(*) FROM production.productsubcategory
UNION ALL SELECT 'production.productcategory', COUNT(*) FROM production.productcategory
UNION ALL SELECT 'production.scrapreason', COUNT(*) FROM production.scrapreason
UNION ALL SELECT 'production.location', COUNT(*) FROM production.location;

-- 2. RENTANG TANGGAL work order
SELECT MIN(startdate) AS mulai_paling_awal,
       MAX(startdate) AS mulai_paling_akhir,
       MIN(enddate)   AS selesai_paling_awal,
       MAX(enddate)   AS selesai_paling_akhir,
       MIN(duedate)   AS jatuh_tempo_paling_awal,
       MAX(duedate)   AS jatuh_tempo_paling_akhir
FROM production.workorder;

-- 3. JUMLAH NULL di kolom penting workorder
SELECT COUNT(*)                                       AS total_baris,
       COUNT(*) FILTER (WHERE enddate IS NULL)        AS enddate_null,
       COUNT(*) FILTER (WHERE scrapreasonid IS NULL)  AS scrapreasonid_null,
       COUNT(*) FILTER (WHERE scrappedqty > 0)        AS work_order_ada_scrap
FROM production.workorder;

-- 4. JUMLAH NULL di kolom penting workorderrouting
SELECT COUNT(*)                                            AS total_baris,
       COUNT(*) FILTER (WHERE actualstartdate IS NULL)     AS actualstartdate_null,
       COUNT(*) FILTER (WHERE actualenddate IS NULL)       AS actualenddate_null,
       COUNT(*) FILTER (WHERE actualresourcehrs IS NULL)   AS actualresourcehrs_null
FROM production.workorderrouting;

-- 5. CALON JUMLAH BARIS FAKTA (grain: 1 baris = 1 work order)
SELECT COUNT(*) AS calon_baris_fakta FROM production.workorder;