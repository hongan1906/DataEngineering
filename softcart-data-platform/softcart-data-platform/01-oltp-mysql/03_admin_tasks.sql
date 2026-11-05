-- Module 1 · Task 4-5: index the timestamp column and list the indexes

USE sales;

-- Reports almost always filter by date, so index the timestamp
CREATE INDEX ts ON sales_data (timestamp);

SHOW INDEX FROM sales_data;
