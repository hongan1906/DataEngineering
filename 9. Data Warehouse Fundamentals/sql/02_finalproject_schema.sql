-- Exercise 3: revised design, database "FinalProject"
-- Columns follow the order of the provided CSV files.

DROP MATERIALIZED VIEW IF EXISTS max_waste_stats;
DROP TABLE IF EXISTS FactTrips;
DROP TABLE IF EXISTS DimDate;
DROP TABLE IF EXISTS DimTruck;
DROP TABLE IF EXISTS DimStation;

CREATE TABLE DimDate (
    dateid      INTEGER PRIMARY KEY,
    date        DATE NOT NULL,
    year        INTEGER NOT NULL,
    quarter     INTEGER NOT NULL,
    quartername VARCHAR(2) NOT NULL,
    month       INTEGER NOT NULL,
    monthname   VARCHAR(10) NOT NULL,
    day         INTEGER NOT NULL,
    weekday     INTEGER NOT NULL,
    weekdayname VARCHAR(10) NOT NULL
);

CREATE TABLE DimTruck (
    truckid   INTEGER PRIMARY KEY,
    trucktype VARCHAR(20) NOT NULL
);

CREATE TABLE DimStation (
    stationid INTEGER PRIMARY KEY,
    city      VARCHAR(50) NOT NULL
);

CREATE TABLE FactTrips (
    tripid         INTEGER PRIMARY KEY,
    dateid         INTEGER NOT NULL REFERENCES DimDate(dateid),
    stationid      INTEGER NOT NULL REFERENCES DimStation(stationid),
    truckid        INTEGER NOT NULL REFERENCES DimTruck(truckid),
    wastecollected DECIMAL(10,2) NOT NULL
);
