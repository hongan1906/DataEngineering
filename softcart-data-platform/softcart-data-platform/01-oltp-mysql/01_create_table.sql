-- Module 1 · Task 1-2: create the OLTP database and table
-- Column names must match the sample data in the lab exactly.

CREATE DATABASE IF NOT EXISTS sales;
USE sales;

CREATE TABLE IF NOT EXISTS sales_data (
    product_id  INT      NOT NULL,
    customer_id INT      NOT NULL,
    price       INT      NOT NULL,
    quantity    INT      NOT NULL,
    timestamp   DATETIME NOT NULL
);

DESCRIBE sales_data;
