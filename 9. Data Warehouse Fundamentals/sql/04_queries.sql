-- Task 13: GROUPING SETS — total waste by station, and by truck type
SELECT f.stationid,
       t.trucktype,
       SUM(f.wastecollected) AS total_waste_collected
FROM FactTrips f
JOIN DimTruck t ON f.truckid = t.truckid
GROUP BY GROUPING SETS (f.stationid, t.trucktype)
ORDER BY f.stationid, t.trucktype;

-- Task 14: ROLLUP — year > city > station, with subtotals and grand total
SELECT d.year,
       s.city,
       f.stationid,
       SUM(f.wastecollected) AS total_waste_collected
FROM FactTrips f
JOIN DimDate d    ON f.dateid = d.dateid
JOIN DimStation s ON f.stationid = s.stationid
GROUP BY ROLLUP (d.year, s.city, f.stationid)
ORDER BY d.year, s.city, f.stationid;

-- Task 15: CUBE — every combination of year, city, station
SELECT d.year,
       s.city,
       f.stationid,
       ROUND(AVG(f.wastecollected), 2) AS average_waste_collected
FROM FactTrips f
JOIN DimDate d    ON f.dateid = d.dateid
JOIN DimStation s ON f.stationid = s.stationid
GROUP BY CUBE (d.year, s.city, f.stationid)
ORDER BY d.year, s.city, f.stationid;
