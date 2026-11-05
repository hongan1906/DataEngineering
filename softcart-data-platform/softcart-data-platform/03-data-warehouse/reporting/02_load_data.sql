-- Module 3 · Part 2 · Tasks 1-4: load the CSVs and preview each table.
-- \copy runs client-side: run psql from the folder that holds the CSV files.
-- (In the lab you can also use pgAdmin: right-click table > Import/Export Data.)

\copy public."DimDate"     FROM 'DimDate.csv'     WITH (FORMAT csv, HEADER true)
\copy public."DimCategory" FROM 'DimCategory.csv' WITH (FORMAT csv, HEADER true)
\copy public."DimCountry"  FROM 'DimCountry.csv'  WITH (FORMAT csv, HEADER true)
\copy public."FactSales"   FROM 'FactSales.csv'   WITH (FORMAT csv, HEADER true)

-- Task 1
SELECT * FROM public."DimDate"     LIMIT 5;
-- Task 2
SELECT * FROM public."DimCategory" LIMIT 5;
-- Task 3
SELECT * FROM public."DimCountry"  LIMIT 5;
-- Task 4
SELECT * FROM public."FactSales"   LIMIT 5;
