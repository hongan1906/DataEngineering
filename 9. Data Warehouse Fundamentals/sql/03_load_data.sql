-- Tasks 9-12: load the CSVs (client-side \copy, so it works with psql from any machine).
-- Run from the repo root:  psql -d FinalProject -f sql/03_load_data.sql
-- Load order matters: dimensions before facts (foreign keys).

\copy DimDate    FROM 'data/DimDate.csv'    WITH (FORMAT csv, HEADER true)
\copy DimTruck   FROM 'data/DimTruck.csv'   WITH (FORMAT csv, HEADER true)
\copy DimStation FROM 'data/DimStation.csv' WITH (FORMAT csv, HEADER true)
\copy FactTrips  FROM 'data/FactTrips.csv'  WITH (FORMAT csv, HEADER true)

-- Screenshots 9-12: first 5 rows of each table
SELECT * FROM DimDate    ORDER BY dateid    LIMIT 5;
SELECT * FROM DimTruck   ORDER BY truckid   LIMIT 5;
SELECT * FROM DimStation ORDER BY stationid LIMIT 5;
SELECT * FROM FactTrips  ORDER BY tripid    LIMIT 5;

-- Row counts (quick sanity check)
SELECT 'DimDate' AS table_name, COUNT(*) AS row_count FROM DimDate
UNION ALL SELECT 'DimTruck',   COUNT(*) FROM DimTruck
UNION ALL SELECT 'DimStation', COUNT(*) FROM DimStation
UNION ALL SELECT 'FactTrips',  COUNT(*) FROM FactTrips;
