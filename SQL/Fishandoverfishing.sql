
-- Create our project database
CREATE DATABASE IF NOT EXISTS global_fisheries_db;


USE global_fisheries_db;

SELECT 'stg_aquaculture' AS table_name,
       COUNT(*) AS total_records
FROM stg_aquaculture

UNION ALL

SELECT 'stg_capture_vs_aquaculture',
       COUNT(*)
FROM stg_capture_vs_aquaculture

UNION ALL

SELECT 'stg_capture_fishery',
       COUNT(*)
FROM stg_capture_fishery

UNION ALL

SELECT 'stg_consumption',
       COUNT(*)
FROM stg_consumption

UNION ALL

SELECT 'stg_sustainability',
       COUNT(*)
FROM stg_sustainability

UNION ALL

SELECT 'stg_fishery_sector',
       COUNT(*)
FROM stg_fishery_sector

UNION ALL

SELECT 'stg_fish_type_production',
       COUNT(*)
FROM stg_fish_type_production;



USE global_fisheries_db;

-- Check capture vs aquaculture
SELECT
    COUNT(*) AS imported_records,
    MIN(Year) AS first_year,
    MAX(Year) AS last_year,
    SUM(`Aquaculture production (metric tons)` IS NULL)
        AS missing_aquaculture,
    SUM(`Capture fisheries production (metric tons)` IS NULL)
        AS missing_capture
FROM stg_capture_vs_aquaculture;


-- Check fish type production
SELECT
    COUNT(*) AS imported_records,
    MIN(Year) AS first_year,
    MAX(Year) AS last_year,
    SUM(pelagic_fish_tonnes IS NULL) AS missing_pelagic,
    SUM(crustaceans_tonnes IS NULL) AS missing_crustaceans,
    SUM(cephalopods_tonnes IS NULL) AS missing_cephalopods,
    SUM(demersal_fish_tonnes IS NULL) AS missing_demersal,
    SUM(freshwater_fish_tonnes IS NULL) AS missing_freshwater
FROM stg_fish_type_production;


SELECT
    COUNT(*) AS total_records,
    SUM(pelagic_fish_tonnes IS NULL) AS missing_pelagic,
    SUM(crustaceans_tonnes IS NULL) AS missing_crustaceans,
    SUM(cephalopods_tonnes IS NULL) AS missing_cephalopods,
    SUM(demersal_fish_tonnes IS NULL) AS missing_demersal,
    SUM(freshwater_fish_tonnes IS NULL) AS missing_freshwater,
    SUM(molluscs_other_tonnes IS NULL) AS missing_molluscs,
    SUM(marine_fish_other_tonnes IS NULL) AS missing_marine
FROM stg_fish_type_production;

SELECT
    Year,
    COUNT(*) AS records_per_year
FROM stg_fish_type_production
GROUP BY Year
ORDER BY Year;


USE global_fisheries_db;

SHOW CREATE TABLE stg_fish_type_production;

USE global_fisheries_db;

SHOW CREATE TABLE stg_fish_type_production;

SHOW CREATE TABLE stg_capture_vs_aquaculture;

SELECT
    COUNT(*) AS total_records,
    SUM(pelagic_fish_tonnes = 0) AS zero_pelagic,
    SUM(crustaceans_tonnes = 0) AS zero_crustaceans,
    SUM(cephalopods_tonnes = 0) AS zero_cephalopods,
    SUM(demersal_fish_tonnes = 0) AS zero_demersal,
    SUM(freshwater_fish_tonnes = 0) AS zero_freshwater,
    SUM(molluscs_other_tonnes = 0) AS zero_molluscs,
    SUM(marine_fish_other_tonnes = 0) AS zero_marine
FROM stg_fish_type_production;

SELECT COUNT(*) AS total_records
FROM stg_fish_type_production_v2;

USE global_fisheries_db;

SELECT COUNT(*) AS total_records
FROM stg_fish_type_production_v2;

SHOW TABLES LIKE 'stg_fish_type_production_v2';

USE global_fisheries_db;

SHOW CREATE TABLE stg_fish_type_production_v2;

USE global_fisheries_db;

SELECT
    COUNT(*) AS total_records,
    SUM(
        freshwater_fish_tonnes IS NULL
        OR TRIM(freshwater_fish_tonnes) = ''
    ) AS blank_freshwater,
    SUM(
        pelagic_fish_tonnes IS NULL
        OR TRIM(pelagic_fish_tonnes) = ''
    ) AS blank_pelagic
FROM stg_fish_type_production_raw;

USE global_fisheries_db;

SHOW CREATE TABLE stg_fish_type_production_raw;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'global_fisheries_db'
AND TABLE_NAME = 'stg_fish_type_production_raw'
ORDER BY ORDINAL_POSITION;

SELECT COUNT(*) AS total_records
FROM stg_fish_type_production_text;


USE global_fisheries_db;

-- Find all versions of our fish production table
SELECT
    TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'global_fisheries_db'
  AND TABLE_NAME LIKE 'stg_fish_type_production%'
ORDER BY TABLE_NAME;

-- Get the record count of every matching table
SET SESSION group_concat_max_len = 10000;

SELECT GROUP_CONCAT(
    CONCAT(
        'SELECT ',
        QUOTE(TABLE_NAME),
        ' AS table_name, COUNT(*) AS total_records FROM `',
        TABLE_NAME,
        '`'
    )
    SEPARATOR ' UNION ALL '
)
INTO @count_sql
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'global_fisheries_db'
  AND TABLE_NAME LIKE 'stg_fish_type_production%'
  AND TABLE_TYPE = 'BASE TABLE';

SET @count_sql = IFNULL(
    @count_sql,
    'SELECT "No matching tables found" AS message'
);

PREPARE count_stmt FROM @count_sql;
EXECUTE count_stmt;
DEALLOCATE PREPARE count_stmt;

USE global_fisheries_db;

SELECT
    COUNT(*) AS total_records,
    SUM(freshwater_fish_tonnes IS NULL) AS missing_freshwater,
    SUM(pelagic_fish_tonnes IS NULL) AS missing_pelagic
FROM stg_fish_type_production_fixed;

DESCRIBE stg_capture_vs_aquaculture;

SELECT COUNT(*) AS total_records
FROM stg_capture_vs_aquaculture;

DESCRIBE stg_capture_vs_aquaculture;

USE global_fisheries_db;

SELECT 'Aquaculture' AS dataset, COUNT(*) AS total_records
FROM stg_aquaculture

UNION ALL

SELECT 'Capture vs Aquaculture', COUNT(*)
FROM stg_capture_vs_aquaculture_fixed

UNION ALL

SELECT 'Capture Fisheries', COUNT(*)
FROM stg_capture_fishery

UNION ALL

SELECT 'Fish Consumption', COUNT(*)
FROM stg_consumption

UNION ALL

SELECT 'Sustainability', COUNT(*)
FROM stg_sustainability

UNION ALL

SELECT 'Fishery Sector', COUNT(*)
FROM stg_fishery_sector

UNION ALL

SELECT 'Fish Type Production', COUNT(*)
FROM stg_fish_type_production_fixed;


SELECT
    Entity,
    Code,
    Year,
    `Aquaculture production (metric tons)` AS production
FROM stg_aquaculture
WHERE Year = 2018
ORDER BY production DESC
LIMIT 15;


SELECT
    COUNT(*) AS total_entities,
    SUM(Code IS NOT NULL) AS entities_with_country_code,
    SUM(Code IS NULL) AS entities_without_country_code
FROM stg_aquaculture
WHERE Year = 2018;

SELECT
    COUNT(*) AS total_entities,
    SUM(Code IS NULL) AS null_codes,
    SUM(TRIM(Code) = '') AS blank_codes,
    SUM(TRIM(Code) <> '') AS nonblank_codes
FROM stg_aquaculture
WHERE Year = 2018;


SELECT
    Entity,
    Code,
    `Aquaculture production (metric tons)` AS production
FROM stg_aquaculture
WHERE Year = 2018
  AND Code IS NOT NULL
  AND TRIM(Code) <> ''
ORDER BY production DESC
LIMIT 10;



WITH country_production AS (
    SELECT
        Entity,
        Code,
        `Aquaculture production (metric tons)` AS production
    FROM stg_aquaculture
    WHERE Year = 2018
      AND Code IS NOT NULL
      AND TRIM(Code) <> ''
)
SELECT
    Entity,
    Code,
    production,
    ROUND(
        production * 100.0 / SUM(production) OVER (),
        2
    ) AS production_share_pct
FROM country_production
ORDER BY production DESC
LIMIT 10;


WITH ranked_countries AS (
    SELECT
        Year,
        Entity,
        Code,
        `Aquaculture production (metric tons)` AS production,
        RANK() OVER (
            PARTITION BY Year
            ORDER BY `Aquaculture production (metric tons)` DESC
        ) AS country_rank
    FROM stg_aquaculture
    WHERE Code IS NOT NULL
      AND TRIM(Code) <> ''
)
SELECT
    Year,
    country_rank,
    Entity,
    production
FROM ranked_countries
WHERE country_rank <= 5
ORDER BY Year, country_rank;


WITH ranked_countries AS (
    SELECT
        Year,
        Entity,
        Code,
        `Aquaculture production (metric tons)` AS production,
        RANK() OVER (
            PARTITION BY Year
            ORDER BY `Aquaculture production (metric tons)` DESC
        ) AS country_rank
    FROM stg_aquaculture
    WHERE Code IS NOT NULL
      AND TRIM(Code) <> ''
)
SELECT
    Year,
    country_rank,
    Entity,
    production
FROM ranked_countries
WHERE country_rank <= 5
ORDER BY Year, country_rank;

SELECT
    MIN(CASE WHEN Year = 1960 THEN
        `Aquaculture production (metric tons)` END) AS production_1960,

    MAX(CASE WHEN Year = 2018 THEN
        `Aquaculture production (metric tons)` END) AS production_2018
FROM stg_aquaculture
WHERE Entity = 'India';

SELECT
    1960 AS start_year,
    2018 AS end_year,

    MAX(CASE WHEN Year = 1960
        THEN `Aquaculture production (metric tons)` END)
        AS production_1960,

    MAX(CASE WHEN Year = 2018
        THEN `Aquaculture production (metric tons)` END)
        AS production_2018,

    ROUND(
        (
            MAX(CASE WHEN Year = 2018
                THEN `Aquaculture production (metric tons)` END)
            -
            MAX(CASE WHEN Year = 1960
                THEN `Aquaculture production (metric tons)` END)
        ) * 100.0
        /
        MAX(CASE WHEN Year = 1960
            THEN `Aquaculture production (metric tons)` END),
        2
    ) AS growth_percentage

FROM stg_aquaculture
WHERE Entity = 'India';


SELECT
    Year,
    SUM(Aquaculture_production_metric_tons) AS aquaculture,
    SUM(Capture_fisheries_production_metric_tons) AS capture_fisheries
FROM stg_capture_vs_aquaculture_fixed
WHERE Code IS NOT NULL
  AND TRIM(Code) <> ''
GROUP BY Year
ORDER BY Year;


SELECT
    Entity,
    Code,
    Year,
    Aquaculture_production_metric_tons,
    Capture_fisheries_production_metric_tons
FROM stg_capture_vs_aquaculture_fixed
WHERE Year IN (2015, 2016, 2018)
ORDER BY Year,
    Aquaculture_production_metric_tons DESC
LIMIT 30;


SELECT
    Year,
    COUNT(*) AS total_entities,
    COUNT(DISTINCT Code) AS unique_codes
FROM stg_capture_vs_aquaculture_fixed
WHERE Code IS NOT NULL
  AND TRIM(Code) <> ''
GROUP BY Year
ORDER BY Year;



SELECT
    Year,
    Aquaculture_production_metric_tons AS aquaculture,
    Capture_fisheries_production_metric_tons AS capture_fisheries
FROM stg_capture_vs_aquaculture_fixed
WHERE Entity = 'World'
ORDER BY Year;


SELECT
    Year,
    Aquaculture_production_metric_tons AS aquaculture,
    Capture_fisheries_production_metric_tons AS capture_fisheries,

    ROUND(
        Aquaculture_production_metric_tons * 100.0 /
        (
            Aquaculture_production_metric_tons +
            Capture_fisheries_production_metric_tons
        ), 2
    ) AS aquaculture_share_pct

FROM stg_capture_vs_aquaculture_fixed
WHERE Entity = 'World'
ORDER BY Year;

SELECT
    Year,
    COUNT(*) AS world_records
FROM stg_capture_vs_aquaculture_fixed
WHERE Entity = 'World'
GROUP BY Year
ORDER BY Year;

SELECT
    Entity,
    Code,
    Year,
    Aquaculture_production_metric_tons,
    Capture_fisheries_production_metric_tons
FROM stg_capture_vs_aquaculture_fixed
WHERE Year BETWEEN 2016 AND 2018
  AND (
      Entity = 'World'
      OR Code = 'OWID_WRL'
  );
  
  DESCRIBE stg_consumption;
  
  SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'global_fisheries_db'
  AND TABLE_NAME = 'stg_consumption';
  
SELECT
    Entity,
    Code,
    Year,
    `Fish, Seafood- Food supply quantity (kg/capita/year)` AS consumption_per_capita
FROM stg_consumption
WHERE Year = 2017
  AND Code IS NOT NULL
  AND TRIM(Code) <> ''
ORDER BY consumption_per_capita DESC
LIMIT 10;

SHOW CREATE TABLE stg_consumption;

SELECT
    Entity,
    Code,
    Year,
    `Fish, Seafood- Food supply quantity (kg/capita/yr) (FAO, 2020)`
        AS consumption_per_capita
FROM stg_consumption
WHERE Year = 2017
  AND Code IS NOT NULL
  AND TRIM(Code) <> ''
ORDER BY consumption_per_capita DESC
LIMIT 10;

SELECT
    Entity,
    Code,
    Year,
    `Fish, Seafood- Food supply quantity (kg/capita/yr) (FAO, 2020)`
        AS consumption_per_capita
FROM stg_consumption
WHERE Year = 2017
  AND Code IS NOT NULL
  AND TRIM(Code) <> ''
ORDER BY consumption_per_capita ASC
LIMIT 10;

SELECT
    Entity,
    Code,
    MIN(Year) AS first_year,
    MAX(Year) AS last_year,
    COUNT(*) AS records
FROM stg_consumption
WHERE Entity = 'World'
GROUP BY Entity, Code;

SELECT
    Year,
    `Fish, Seafood- Food supply quantity (kg/capita/yr) (FAO, 2020)`
        AS global_supply_per_capita
FROM stg_consumption
WHERE Entity = 'World'
ORDER BY Year;

DESCRIBE stg_sustainability;
DESCRIBE stg_sustainability;

SELECT *
FROM stg_sustainability
LIMIT 10;

ALTER TABLE stg_sustainability
RENAME COLUMN `ï»¿"Entity"` TO Entity;

DESCRIBE stg_sustainability;
SELECT
    Entity AS region,
    Year,
    ROUND(sustainable_stock_pct, 2) AS sustainable_percentage,
    ROUND(overexploited_stock_pct, 2) AS overexploited_percentage
FROM stg_sustainability
ORDER BY Year, overexploited_stock_pct DESC;

SELECT
    Entity AS region,
    Year,
    ROUND(overexploited_stock_pct, 2) AS overexploited_percentage
FROM stg_sustainability
WHERE Year = 2017
ORDER BY overexploited_stock_pct DESC
LIMIT 10;

SELECT
    a.Entity AS region,
    ROUND(a.overexploited_stock_pct, 2) AS overexploited_2015,
    ROUND(b.overexploited_stock_pct, 2) AS overexploited_2017,
    ROUND(
        b.overexploited_stock_pct - a.overexploited_stock_pct,
        2
    ) AS change_percentage_points
FROM stg_sustainability a
JOIN stg_sustainability b
    ON a.Entity = b.Entity
WHERE a.Year = 2015
  AND b.Year = 2017
ORDER BY change_percentage_points DESC;

DESCRIBE stg_sustainability;

SELECT
    COUNT(*) AS regions_compared,
    COUNT(DISTINCT a.Entity) AS unique_regions
FROM stg_sustainability a
JOIN stg_sustainability b
    ON a.Entity = b.Entity
WHERE a.Year = 2015
  AND b.Year = 2017;
  
  CREATE OR REPLACE VIEW vw_fish_stock_regional_comparison AS
SELECT
    a.Entity AS region,
    ROUND(a.sustainable_stock_pct, 2) AS sustainable_2015,
    ROUND(b.sustainable_stock_pct, 2) AS sustainable_2017,
    ROUND(a.overexploited_stock_pct, 2) AS overexploited_2015,
    ROUND(b.overexploited_stock_pct, 2) AS overexploited_2017,
    ROUND(
        b.overexploited_stock_pct - a.overexploited_stock_pct,
        2
    ) AS overexploitation_change
FROM stg_sustainability a
JOIN stg_sustainability b
    ON a.Entity = b.Entity
WHERE a.Year = 2015
  AND b.Year = 2017;
  
  SELECT *
FROM vw_fish_stock_regional_comparison
ORDER BY overexploitation_change DESC;

CREATE OR REPLACE VIEW vw_global_fisheries_trend AS
SELECT
    Year,
    ROUND(Aquaculture_production_metric_tons, 2)
        AS aquaculture_production,
    ROUND(Capture_fisheries_production_metric_tons, 2)
        AS capture_production,
    ROUND(
        Aquaculture_production_metric_tons * 100.0 /
        (Aquaculture_production_metric_tons +
         Capture_fisheries_production_metric_tons),
        2
    ) AS aquaculture_share_pct,
    ROUND(
        Capture_fisheries_production_metric_tons * 100.0 /
        (Aquaculture_production_metric_tons +
         Capture_fisheries_production_metric_tons),
        2
    ) AS capture_share_pct
FROM stg_capture_vs_aquaculture_fixed
WHERE Entity = 'World';


SELECT *
FROM vw_global_fisheries_trend
ORDER BY Year;
CREATE OR REPLACE VIEW vw_country_aquaculture_2018 AS
SELECT
    Entity AS country,
    Code AS country_code,
    ROUND(
        `Aquaculture production (metric tons)`,
        2
    ) AS aquaculture_production_tonnes
FROM stg_aquaculture
WHERE Year = 2018
  AND Entity <> 'World'
  AND Code IS NOT NULL
  AND TRIM(Code) <> '';
  
  SELECT *
FROM vw_country_aquaculture_2018
ORDER BY aquaculture_production_tonnes DESC
LIMIT 10;

SELECT
    country,
    aquaculture_production_tonnes,
    ROUND(
        aquaculture_production_tonnes * 100.0 /
        SUM(aquaculture_production_tonnes) OVER (),
        2
    ) AS production_share_percentage
FROM vw_country_aquaculture_2018
ORDER BY aquaculture_production_tonnes DESC;

CREATE OR REPLACE VIEW vw_country_fish_consumption_2017 AS
SELECT
    Entity AS country,
    Code AS country_code,
    Year,
    ROUND(
        `Fish, Seafood- Food supply quantity (kg/capita/yr) (FAO, 2020)`,
        2
    ) AS fish_supply_kg_per_capita
FROM stg_consumption
WHERE Year = 2017
  AND Code IS NOT NULL
  AND TRIM(Code) <> '';
  
  
  SELECT *
FROM vw_country_fish_consumption_2017
ORDER BY fish_supply_kg_per_capita DESC
LIMIT 10;

CREATE OR REPLACE VIEW vw_aquaculture_vs_consumption AS
SELECT
    a.Entity AS country,
    a.Code AS country_code,
    ROUND(
        a.`Aquaculture production (metric tons)`,
        2
    ) AS aquaculture_production_tonnes,
    c.fish_supply_kg_per_capita
FROM stg_aquaculture a
JOIN vw_country_fish_consumption_2017 c
    ON a.Code = c.country_code
WHERE a.Year = 2017
  AND a.Entity <> 'World'
  AND a.Code IS NOT NULL
  AND TRIM(a.Code) <> '';
  
  
  SELECT *
FROM vw_aquaculture_vs_consumption
ORDER BY aquaculture_production_tonnes DESC
LIMIT 15;


CREATE OR REPLACE VIEW vw_aquaculture_country_contribution AS
SELECT
    country,
    country_code,
    aquaculture_production_tonnes,
    ROUND(
        aquaculture_production_tonnes * 100.0 /
        SUM(aquaculture_production_tonnes) OVER (),
        2
    ) AS production_share_pct
FROM vw_country_aquaculture_2018;



SELECT
    country,
    aquaculture_production_tonnes,
    production_share_pct,
    ROUND(
        SUM(production_share_pct) OVER (
            ORDER BY aquaculture_production_tonnes DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_share_pct
FROM vw_aquaculture_country_contribution
ORDER BY aquaculture_production_tonnes DESC;



WITH country_totals AS (
    SELECT
        country,
        country_code,
        aquaculture_production_tonnes
    FROM vw_country_aquaculture_2018
),
ranked_countries AS (
    SELECT
        country,
        country_code,
        aquaculture_production_tonnes,

        SUM(aquaculture_production_tonnes) OVER ()
            AS total_production,

        SUM(aquaculture_production_tonnes) OVER (
            ORDER BY aquaculture_production_tonnes DESC, country
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_production

    FROM country_totals
)
SELECT
    country,
    aquaculture_production_tonnes,
    ROUND(
        aquaculture_production_tonnes * 100.0 /
        total_production, 4
    ) AS production_share_pct,

    ROUND(
        cumulative_production * 100.0 /
        total_production, 2
    ) AS cumulative_share_pct

FROM ranked_countries
ORDER BY aquaculture_production_tonnes DESC;



SHOW FULL TABLES
WHERE Table_type = 'VIEW';

DESCRIBE stg_fish_type_production_fixed;

DESCRIBE stg_fishery_sector;

DESCRIBE stg_fish_type_production_fixed;

DESCRIBE stg_fishery_sector;

CREATE OR REPLACE VIEW vw_fish_type_production AS
SELECT
    Entity AS country_or_region,
    Code AS country_code,
    Year,

    pelagic_fish_tonnes,
    crustaceans_tonnes,
    cephalopods_tonnes,
    demersal_fish_tonnes,
    freshwater_fish_tonnes,
    molluscs_other_tonnes,
    marine_fish_other_tonnes,

    (
        (pelagic_fish_tonnes IS NOT NULL) +
        (crustaceans_tonnes IS NOT NULL) +
        (cephalopods_tonnes IS NOT NULL) +
        (demersal_fish_tonnes IS NOT NULL) +
        (freshwater_fish_tonnes IS NOT NULL) +
        (molluscs_other_tonnes IS NOT NULL) +
        (marine_fish_other_tonnes IS NOT NULL)
    ) AS available_categories,

    CASE
        WHEN
            pelagic_fish_tonnes IS NULL
            AND crustaceans_tonnes IS NULL
            AND cephalopods_tonnes IS NULL
            AND demersal_fish_tonnes IS NULL
            AND freshwater_fish_tonnes IS NULL
            AND molluscs_other_tonnes IS NULL
            AND marine_fish_other_tonnes IS NULL
        THEN NULL
        ELSE
            COALESCE(pelagic_fish_tonnes, 0) +
            COALESCE(crustaceans_tonnes, 0) +
            COALESCE(cephalopods_tonnes, 0) +
            COALESCE(demersal_fish_tonnes, 0) +
            COALESCE(freshwater_fish_tonnes, 0) +
            COALESCE(molluscs_other_tonnes, 0) +
            COALESCE(marine_fish_other_tonnes, 0)
    END AS reported_type_subtotal_tonnes

FROM stg_fish_type_production_fixed;


SELECT *
FROM vw_fish_type_production
LIMIT 10;

SELECT *
FROM vw_global_fishery_sector
ORDER BY Year
LIMIT 10;

CREATE OR REPLACE VIEW vw_global_fishery_sector AS
SELECT
    Entity,
    Code,
    Year,

    `Artisanal (small-scale commercial)` AS artisanal,
    `Industrial (large-scale commercial)` AS industrial,
    Recreational AS recreational,
    Subsistence AS subsistence,
    Discards AS discards,

    (
        (`Artisanal (small-scale commercial)` IS NOT NULL) +
        (`Industrial (large-scale commercial)` IS NOT NULL) +
        (Recreational IS NOT NULL) +
        (Subsistence IS NOT NULL)
    ) AS available_sector_categories,

    CASE
        WHEN `Artisanal (small-scale commercial)` IS NULL
         AND `Industrial (large-scale commercial)` IS NULL
         AND Recreational IS NULL
         AND Subsistence IS NULL
        THEN NULL
        ELSE
            COALESCE(`Artisanal (small-scale commercial)`, 0) +
            COALESCE(`Industrial (large-scale commercial)`, 0) +
            COALESCE(Recreational, 0) +
            COALESCE(Subsistence, 0)
    END AS reported_sector_subtotal

FROM stg_fishery_sector;

SHOW FULL TABLES LIKE 'vw_global_fishery_sector';

SELECT *
FROM vw_global_fishery_sector
ORDER BY Year
LIMIT 10;


CREATE OR REPLACE VIEW vw_fishery_sector_share AS
SELECT
    Entity,
    Code,
    Year,

    artisanal,
    industrial,
    recreational,
    subsistence,
    discards,

    reported_sector_subtotal,

    ROUND(
        artisanal * 100.0 /
        NULLIF(reported_sector_subtotal, 0), 2
    ) AS artisanal_share_pct,

    ROUND(
        industrial * 100.0 /
        NULLIF(reported_sector_subtotal, 0), 2
    ) AS industrial_share_pct,

    ROUND(
        recreational * 100.0 /
        NULLIF(reported_sector_subtotal, 0), 2
    ) AS recreational_share_pct,

    ROUND(
        subsistence * 100.0 /
        NULLIF(reported_sector_subtotal, 0), 2
    ) AS subsistence_share_pct

FROM vw_global_fishery_sector;

SELECT *
FROM vw_fishery_sector_share
ORDER BY Year;

SELECT
    'Fish Type Production' AS dataset,
    COUNT(*) AS total_records,
    MIN(Year) AS first_year,
    MAX(Year) AS last_year
FROM vw_fish_type_production

UNION ALL

SELECT
    'Fishing Sector Share',
    COUNT(*),
    MIN(Year),
    MAX(Year)
FROM vw_fishery_sector_share;