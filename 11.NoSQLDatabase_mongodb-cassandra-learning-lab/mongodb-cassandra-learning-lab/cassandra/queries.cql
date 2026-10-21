-- Run in cqlsh after importing CSV.

-- Task 8: count rows (100 expected for the sample dataset)
SELECT COUNT(*) FROM entertainment.movies;

-- Task 9: create and verify secondary index on rating
CREATE INDEX IF NOT EXISTS movies_rating_idx
ON entertainment.movies (rating);
DESCRIBE TABLE entertainment.movies;

-- Task 10: count G-rated movies
SELECT COUNT(*) FROM entertainment.movies WHERE rating = 'G';
