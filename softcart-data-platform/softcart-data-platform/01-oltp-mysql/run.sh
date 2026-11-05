#!/usr/bin/env bash
# Runs all of Module 1 against the local Docker MySQL and saves outputs.
set -euo pipefail
cd "$(dirname "$0")"
source ../.env
mkdir -p outputs
M="docker exec -i softcart-mysql mysql --local-infile=1 -uroot -p$MYSQL_PASSWORD -t"

$M < 01_create_table.sql | tee outputs/01_create_table.txt
$M < 02_load_data.sql    | tee outputs/02_load_data.txt
$M < 03_admin_tasks.sql  | tee outputs/03_admin_tasks.txt
# datadump.sh needs the mysqldump client; inside Docker we run it in the container
docker cp datadump.sh softcart-mysql:/tmp/datadump.sh
docker exec -w /tmp -e MYSQL_PASSWORD="$MYSQL_PASSWORD" softcart-mysql bash /tmp/datadump.sh | tee outputs/04_datadump.txt
docker cp softcart-mysql:/tmp/sales_data.sql ./sales_data.sql
