#!/usr/bin/env bash
# Runs Module 5 Part 1 locally: load staging MySQL + warehouse PostgreSQL, then sync.
set -euo pipefail
cd "$(dirname "$0")"
source ../.env
mkdir -p outputs

# Staging: MySQL `sales` database from sales.sql
docker exec -i softcart-mysql mysql -uroot -p"$MYSQL_PASSWORD" \
  -e "DROP DATABASE IF EXISTS sales; CREATE DATABASE sales;"
docker exec -i softcart-mysql mysql -uroot -p"$MYSQL_PASSWORD" sales < ../data/sales.sql

# Warehouse: PostgreSQL sales_data from sales.csv
docker exec -i -w /data softcart-postgres psql -U postgres -v ON_ERROR_STOP=1 \
  < etl/setup_postgres.sql | tee outputs/setup_postgres.txt

# Sync — run twice to show the job is idempotent (2nd run finds 0 new rows)
python etl/automation.py | tee outputs/etl_run1.txt
python etl/automation.py | tee outputs/etl_run2.txt
