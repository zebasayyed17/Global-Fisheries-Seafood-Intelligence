USE global_fisheries_db;

SELECT
    Year,
    SUM(`Aquaculture production (metric tons)`) AS total_aquaculture
FROM stg_aquaculture
GROUP BY Year
ORDER BY Year;