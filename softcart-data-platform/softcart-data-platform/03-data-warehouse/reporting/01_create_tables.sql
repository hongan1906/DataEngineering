-- Module 3 · Part 2 · Setup: tables provided by the senior engineer (CREATE-SCRIPT.sql).
-- Run against the database "Test1".

CREATE TABLE IF NOT EXISTS public."DimDate" (
    dateid      integer NOT NULL,
    date        date,
    Year        integer,
    Quarter     integer,
    QuarterName character(50),
    Month       integer,
    Monthname   character(50),
    Day         integer,
    Weekday     integer,
    WeekdayName character(50),
    CONSTRAINT "DimDate_pkey" PRIMARY KEY (dateid)
);

CREATE TABLE IF NOT EXISTS public."DimCategory" (
    categoryid integer NOT NULL,
    category   character(50),
    CONSTRAINT "DimCategory_pkey" PRIMARY KEY (categoryid)
);

CREATE TABLE IF NOT EXISTS public."DimCountry" (
    countryid integer NOT NULL,
    country   character(50),
    CONSTRAINT "DimCountry_pkey" PRIMARY KEY (countryid)
);

CREATE TABLE IF NOT EXISTS public."FactSales" (
    orderid    integer NOT NULL,
    dateid     integer,
    countryid  integer,
    categoryid integer,
    amount     integer,
    CONSTRAINT "FactSales_pkey" PRIMARY KEY (orderid)
);
