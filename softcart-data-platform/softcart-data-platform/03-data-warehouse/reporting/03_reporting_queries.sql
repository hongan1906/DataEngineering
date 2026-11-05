-- Module 3 · Part 2 · Tasks 5-8: OLAP reporting queries.
-- trim() removes the padding that character(50) adds to text values.

-- Task 5 — GROUPING SETS: totals by (country, category), by country, by category, and overall
SELECT
    trim(co.country)  AS country,
    trim(ca.category) AS category,
    SUM(f.amount)     AS totalsales
FROM public."FactSales"   f
JOIN public."DimCountry"  co ON co.countryid  = f.countryid
JOIN public."DimCategory" ca ON ca.categoryid = f.categoryid
GROUP BY GROUPING SETS (
    (co.country, ca.category),
    (co.country),
    (ca.category),
    ()
)
ORDER BY country, category;

-- Task 6 — ROLLUP: year > country hierarchy with subtotals per year and a grand total
SELECT
    d.year,
    trim(co.country) AS country,
    SUM(f.amount)    AS totalsales
FROM public."FactSales"  f
JOIN public."DimDate"    d  ON d.dateid     = f.dateid
JOIN public."DimCountry" co ON co.countryid = f.countryid
GROUP BY ROLLUP (d.year, co.country)
ORDER BY d.year, country;

-- Task 7 — CUBE: average sales for every combination of year and country
SELECT
    d.year,
    trim(co.country)          AS country,
    ROUND(AVG(f.amount), 2)   AS average_sales
FROM public."FactSales"  f
JOIN public."DimDate"    d  ON d.dateid     = f.dateid
JOIN public."DimCountry" co ON co.countryid = f.countryid
GROUP BY CUBE (d.year, co.country)
ORDER BY d.year, country;

-- Task 8 — MQT (Materialized Query Table). PostgreSQL calls this a MATERIALIZED VIEW.
DROP MATERIALIZED VIEW IF EXISTS total_sales_per_country;

CREATE MATERIALIZED VIEW total_sales_per_country AS
SELECT
    trim(co.country) AS country,
    SUM(f.amount)    AS total_sales
FROM public."FactSales"  f
JOIN public."DimCountry" co ON co.countryid = f.countryid
GROUP BY co.country
WITH DATA;

-- Refresh after each new load:  REFRESH MATERIALIZED VIEW total_sales_per_country;
SELECT * FROM total_sales_per_country ORDER BY total_sales DESC LIMIT 10;
