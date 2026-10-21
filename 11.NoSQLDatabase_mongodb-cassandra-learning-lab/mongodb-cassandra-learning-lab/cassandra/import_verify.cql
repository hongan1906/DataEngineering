-- Run in cqlsh after schema.cql. Adjust path if different.
-- Task 7: import exported MongoDB CSV into Cassandra
COPY entertainment.movies ("_id", title, year, rating, director)
FROM '/home/project/partial_data.csv'
WITH HEADER = TRUE;

-- Count should be 100 for this exercise's dataset.
SELECT COUNT(*) FROM entertainment.movies;
SELECT * FROM entertainment.movies LIMIT 5;
