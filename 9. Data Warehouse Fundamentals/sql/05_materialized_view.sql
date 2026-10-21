-- Task 16: materialized view with the max waste per city / station / truck type
DROP MATERIALIZED VIEW IF EXISTS max_waste_stats;

CREATE MATERIALIZED VIEW max_waste_stats AS
SELECT s.city,
       f.stationid,
       t.trucktype,
       MAX(f.wastecollected) AS max_waste_collected
FROM FactTrips f
JOIN DimStation s ON f.stationid = s.stationid
JOIN DimTruck t   ON f.truckid = t.truckid
GROUP BY s.city, f.stationid, t.trucktype;

-- Check it
SELECT * FROM max_waste_stats ORDER BY city, stationid, trucktype;

-- After new data is loaded:
-- REFRESH MATERIALIZED VIEW max_waste_stats;
