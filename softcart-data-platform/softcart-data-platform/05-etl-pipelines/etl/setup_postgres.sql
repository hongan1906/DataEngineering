-- Module 5 · Part 1 · Step 9: production warehouse table in PostgreSQL.
-- sales.csv has price and timestamp; the MySQL staging table does not, so
-- both columns get defaults for rows that arrive through the ETL job.
-- (The lab text spells the column "timeestamp" — a typo; "timestamp" is used here.)

DROP TABLE IF EXISTS sales_data;

CREATE TABLE sales_data (
    rowid       INTEGER   NOT NULL PRIMARY KEY,
    product_id  INTEGER   NOT NULL,
    customer_id INTEGER   NOT NULL,
    price       DECIMAL   NOT NULL DEFAULT 0.0,
    quantity    INTEGER   NOT NULL,
    timestamp   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Run psql from the folder containing sales.csv (pgAdmin: upload to /var/lib/pgadmin/)
\copy sales_data (rowid, product_id, customer_id, price, quantity, timestamp) FROM 'sales.csv' WITH (FORMAT csv, HEADER true)

SELECT COUNT(*) AS rows_loaded, MAX(rowid) AS last_rowid FROM sales_data;
