-- Exercise 2 (Tasks 5-8): initial design, database "Project"
-- Run while connected to the Project database.
-- Dimension tables first, because the fact table references them.

-- Task 5
CREATE TABLE MyDimDate (
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

-- Task 6
CREATE TABLE MyDimWaste (
    wasteid   INTEGER PRIMARY KEY,
    wastetype VARCHAR(20) NOT NULL
);

-- Task 7
CREATE TABLE MyDimZone (
    zoneid         INTEGER PRIMARY KEY,
    collectionzone VARCHAR(20) NOT NULL,
    city           VARCHAR(50) NOT NULL
);

-- Task 8
CREATE TABLE MyFactTrips (
    tripid         INTEGER PRIMARY KEY,
    dateid         INTEGER NOT NULL REFERENCES MyDimDate(dateid),
    wasteid        INTEGER NOT NULL REFERENCES MyDimWaste(wasteid),
    zoneid         INTEGER NOT NULL REFERENCES MyDimZone(zoneid),
    wastecollected DECIMAL(10,2) NOT NULL
);
