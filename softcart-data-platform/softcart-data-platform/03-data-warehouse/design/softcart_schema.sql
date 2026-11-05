-- Module 3 · Part 1 (Tasks 1-7): SoftCart star schema
-- Designed in the pgAdmin ERD tool; this is the SQL the tool generates.
-- Grain of the fact table: one row per order.

-- Reports needed: sales per year/quarter/month/day/weekday, per country, per category.

CREATE TABLE public."softcartDimDate" (
    dateid       INTEGER     NOT NULL PRIMARY KEY,   -- surrogate key, e.g. 20200115
    date         DATE        NOT NULL,
    year         INTEGER     NOT NULL,
    quarter      INTEGER     NOT NULL,
    quartername  VARCHAR(2)  NOT NULL,               -- Q1..Q4
    month        INTEGER     NOT NULL,
    monthname    VARCHAR(10) NOT NULL,
    day          INTEGER     NOT NULL,
    weekday      INTEGER     NOT NULL,
    weekdayname  VARCHAR(10) NOT NULL
);

CREATE TABLE public."softcartDimCategory" (
    categoryid   INTEGER     NOT NULL PRIMARY KEY,
    category     VARCHAR(50) NOT NULL
);

CREATE TABLE public."softcartDimItem" (
    itemid       INTEGER     NOT NULL PRIMARY KEY,
    item         VARCHAR(100) NOT NULL
);

CREATE TABLE public."softcartDimCountry" (
    countryid    INTEGER     NOT NULL PRIMARY KEY,
    country      VARCHAR(60) NOT NULL
);

CREATE TABLE public."softcartFactSales" (
    orderid      INTEGER       NOT NULL PRIMARY KEY,
    dateid       INTEGER       NOT NULL,
    categoryid   INTEGER       NOT NULL,
    itemid       INTEGER       NOT NULL,
    countryid    INTEGER       NOT NULL,
    price        NUMERIC(10,2) NOT NULL,

    -- Task 6: relationships (each dimension row relates to many fact rows)
    CONSTRAINT fk_sales_date     FOREIGN KEY (dateid)     REFERENCES public."softcartDimDate"(dateid),
    CONSTRAINT fk_sales_category FOREIGN KEY (categoryid) REFERENCES public."softcartDimCategory"(categoryid),
    CONSTRAINT fk_sales_item     FOREIGN KEY (itemid)     REFERENCES public."softcartDimItem"(itemid),
    CONSTRAINT fk_sales_country  FOREIGN KEY (countryid)  REFERENCES public."softcartDimCountry"(countryid)
);
