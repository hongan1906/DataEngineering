-- Module 1 · Task 3: load oltpdata.csv and count the rows
-- In the IBM lab you import the CSV through phpMyAdmin (Import tab, format CSV).
-- Locally the same load is done with LOAD DATA (the file has no header row).

USE sales;

LOAD DATA LOCAL INFILE '/data/oltpdata.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(product_id, customer_id, price, quantity, timestamp);

SHOW TABLES;

SELECT COUNT(*) AS total_rows FROM sales_data;   -- expected: 2605
