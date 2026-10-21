# MongoDB & Apache Cassandra — NoSQL Database Lab

A hands-on learning project based on IBM Skills Network exercises. This repository demonstrates basic NoSQL database administration, data import/export, aggregation, CQL data modeling, secondary indexing, and verification.

> **Scope:** Educational lab using a sample movie dataset (100 movie records imported in the lab). Commands are reproducible templates; results reported below reflect observed lab output or exercise expectations, not independent reruns.

## Project workflow

```text
movies.json
    │
    ▼
MongoDB: entertainment.movies
    │  Aggregation / counting queries
    │  mongoexport (selected fields)
    ▼
partial_data.csv
    │
    ▼
Cassandra: entertainment.movies
       CQL import / counts / rating index / filtering
```

## What I learned

### MongoDB
- Connecting to a MongoDB server using `mongosh` and understanding the difference between a **database**, **collection**, and **document**.
- Importing JSON documents into a collection using `mongoimport` and validating the import.
- Filtering with query operators such as `$gt` and counting documents with `countDocuments()`.
- Building aggregation pipelines using `$match`, `$group`, `$sum`, `$avg`, `$sort`, and `$limit`.
- Exporting a subset of document fields to CSV using `mongoexport`.
- Distinguishing between shell commands (`curl`, `mongoimport`, `mongoexport`) and JavaScript statements run inside `mongosh`.

### Apache Cassandra
- Connecting with `cqlsh` and understanding **keyspaces**, **tables**, and **partition/primary keys**.
- Creating a keyspace with a replication strategy and a table whose five columns use the `text` type.
- Understanding why `_id` needs quoting in CQL and using it as the primary key for this exercise.
- Loading CSV data with `COPY ... FROM` and verifying the imported row count.
- Creating a secondary index on `rating` and using it to filter movies with `WHERE rating = 'G'`.
- Recognizing that Cassandra data models and indexes should generally be designed around query patterns; a secondary index is a lab demonstration, not automatically the best solution for large production datasets.

## Results and evidence

| Task | Database | Operation | Result |
| --- | --- | --- | --- |
| 1 | MongoDB | Import `movies.json` into `entertainment.movies` | **100 documents imported, 0 failed** (confirmed in lab screenshot) |
| 2 | MongoDB | Release year with highest movie count | Query included; execute to record actual top year |
| 3 | MongoDB | Movies released after 1999 | **99** (exercise expected result) |
| 4 | MongoDB | Average votes for movies released in 2007 | **192.5** (exercise expected result) |
| 5 | MongoDB | Export five fields as `partial_data.csv` | Procedure included; output file is not bundled |
| 6 | Cassandra | Create `entertainment` keyspace | Created in lab |
| 7 | Cassandra | Import CSV into `entertainment.movies` | **100 rows imported, 0 skipped** (confirmed in lab screenshot) |
| 8 | Cassandra | Count imported rows | Expected **100**; rerun query to verify |
| 9 | Cassandra | Create index on `rating` | Command included; verify with `DESCRIBE TABLE` |
| 10 | Cassandra | Count G-rated movies | Query included; actual count not provided |

Avoid reporting exercise-provided expected values as personally verified until you have run the queries and captured the results.

## Repository layout

```text
.
├── README.md
├── .gitignore
├── .env.example
├── mongodb/
│   ├── import_export.sh
│   └── queries.js
├── cassandra/
│   ├── schema.cql
│   ├── import_verify.cql
│   └── queries.cql
└── screenshots/
    └── README.md
```

## Prerequisites

- MongoDB server and MongoDB Database Tools (`mongosh`, `mongoimport`, `mongoexport`)
- Cassandra server and `cqlsh`
- Sample movie dataset provided by the course
- A Linux shell for download/import/export commands

## How to reproduce

1. Obtain `movies.json` from the IBM course lab and place it in your project folder. The dataset and exported CSV are not bundled with this repository.
2. Set connection variables in your shell, based on `.env.example` (do **not** commit secrets). Use an interactive password prompt when possible.
3. Run the MongoDB commands in `mongodb/import_export.sh` **one at a time**, adjusting the host/user settings to your environment.
4. Run the MongoDB queries in `mongosh` after selecting the `entertainment` database (`use entertainment`).
5. In `cqlsh`, run `cassandra/schema.cql`, then `cassandra/import_verify.cql` (edit the CSV path), then `cassandra/queries.cql`.
6. Save redacted screenshots in `screenshots/` and update the result table above with your actual outputs.

**Note:** The example MongoDB host IP displayed in the hosted lab was ephemeral, so scripts use configurable host values rather than a fixed IP. The Cassandra lab used a managed `cqlsh` session. Your connection settings may differ.

## Key differences observed

| Dimension | MongoDB | Cassandra |
| --- | --- | --- |
| Model | Document database (BSON/JSON-like documents) | Wide-column distributed database (tables and partition keys) |
| Query language | MongoDB queries and aggregation pipeline | Cassandra Query Language (CQL) |
| Lab data flow | Import JSON, run aggregations, export CSV | Define schema first, import CSV, query by indexed value |
| Lab indexing | Not explored in this exercise | Secondary index created on `rating` |
| Design focus | Flexible documents and aggregation | Query-driven partition-key-oriented modeling |

## Security and limitations

- **Never commit passwords**, authentication URIs, `.env`, or full terminal screenshots containing credentials. Redact both current and older credentials.
- The `movies.json` and `partial_data.csv` files are omitted: this package contains the workflow and commands, not the course dataset.
- A single-node `SimpleStrategy` replication factor of 1 is suitable **only for this learning environment**.
- `COUNT(*)` in Cassandra can be expensive on large tables; it is used here because the dataset is small.
- Cassandra secondary indexes can be inefficient for low-cardinality fields like ratings at scale. Production designs should consider the query pattern and partition key first.

## Next steps

- Add sanitized screenshots showing each query and its result.
- Experiment with MongoDB indexes and `explain()`.
- Try query-driven Cassandra modeling, e.g. a table partitioned by rating, and benchmark the query tradeoffs.
- Document the exact MongoDB year with most releases and Cassandra count of G-rated movies from verified terminal output.

## Attribution

Educational exercise inspired by **IBM Skills Network** MongoDB and Cassandra database labs. This repository documents the learner's commands, interpretation, and workflow; it is not an official IBM repository.
