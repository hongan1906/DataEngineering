-- Run in cqlsh. Educational single-node replication configuration.
-- Task 6: create and describe keyspace
CREATE KEYSPACE IF NOT EXISTS entertainment
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

DESCRIBE KEYSPACE entertainment;

-- Task 7: table schema; all columns TEXT as required in exercise
USE entertainment;
CREATE TABLE IF NOT EXISTS movies (
  "_id" text PRIMARY KEY,
  title text,
  year text,
  rating text,
  director text
);

DESCRIBE TABLE entertainment.movies;
