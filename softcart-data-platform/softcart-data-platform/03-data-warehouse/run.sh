#!/usr/bin/env bash
# Runs Module 3 against the local Docker PostgreSQL and saves outputs.
set -euo pipefail
cd "$(dirname "$0")"
source ../.env
mkdir -p outputs
P="docker exec -i softcart-postgres psql -U postgres -v ON_ERROR_STOP=1"

# Part 1: create the designed schema in a database called "staging"
$P -c "DROP DATABASE IF EXISTS staging" -c "CREATE DATABASE staging"
$P -d staging < design/softcart_schema.sql | tee outputs/part1_schema.txt
$P -d staging -c '\dt' | tee -a outputs/part1_schema.txt

# Part 2: reporting database "Test1"
$P -c 'DROP DATABASE IF EXISTS "Test1"' -c 'CREATE DATABASE "Test1"'
$P -d Test1 < reporting/01_create_tables.sql
docker exec -i -w /data softcart-postgres psql -U postgres -d Test1 -v ON_ERROR_STOP=1 < reporting/02_load_data.sql   | tee outputs/part2_load.txt
$P -d Test1 < reporting/03_reporting_queries.sql            | tee outputs/part2_queries.txt
