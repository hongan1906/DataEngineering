#!/usr/bin/env bash
# Build both databases and run every task end to end.
# Connection settings come from the standard PG* env vars (PGHOST, PGPORT, PGUSER, PGPASSWORD).
set -euo pipefail
cd "$(dirname "$0")/.."

[ -f data/FactTrips.csv ] || ./scripts/download_data.sh

PSQL="psql -v ON_ERROR_STOP=1 -X"

echo "== Exercise 2: database Project =="
$PSQL -d postgres -c "DROP DATABASE IF EXISTS \"Project\";" -c "CREATE DATABASE \"Project\";"
$PSQL -d Project -f sql/01_project_schema.sql

echo "== Exercise 3: database FinalProject =="
$PSQL -d postgres -c "DROP DATABASE IF EXISTS \"FinalProject\";" -c "CREATE DATABASE \"FinalProject\";"
$PSQL -d FinalProject -f sql/02_finalproject_schema.sql
$PSQL -d FinalProject -f sql/03_load_data.sql
$PSQL -d FinalProject -f sql/04_queries.sql
$PSQL -d FinalProject -f sql/05_materialized_view.sql

echo "== Done =="
