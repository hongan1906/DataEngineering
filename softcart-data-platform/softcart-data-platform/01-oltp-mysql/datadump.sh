#!/usr/bin/env bash
# Module 1 · Task 6: export every row of sales.sales_data to sales_data.sql
#
# Usage:  MYSQL_PASSWORD=... ./datadump.sh
# In the IBM lab, replace the host/password with the values shown in the
# MySQL connection panel.

set -euo pipefail

MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3306}"
MYSQL_USER="${MYSQL_USER:-root}"
: "${MYSQL_PASSWORD:?Set MYSQL_PASSWORD before running}"

OUTPUT_FILE="sales_data.sql"

mysqldump \
  --host="$MYSQL_HOST" --port="$MYSQL_PORT" \
  --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" \
  --no-tablespaces \
  sales sales_data > "$OUTPUT_FILE"

echo "Exported sales.sales_data to $OUTPUT_FILE ($(wc -l < "$OUTPUT_FILE") lines)"
