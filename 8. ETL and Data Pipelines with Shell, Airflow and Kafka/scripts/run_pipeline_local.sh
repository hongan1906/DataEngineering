#!/usr/bin/env bash
# Runs the exact same bash commands as the Airflow DAG, in the same order,
# without Airflow. Useful for testing the logic on any Linux/macOS/WSL machine.
#
# Usage:
#   bash scripts/run_pipeline_local.sh [BASE_DIR]
# BASE_DIR must contain tolldata.tgz; outputs go to BASE_DIR/staging.
set -euo pipefail

BASE_DIR="${1:-./data/local_run}"
STAGING="$BASE_DIR/staging"
mkdir -p "$STAGING"

echo "[1/6] unzip_data"
tar -xzf "$BASE_DIR/tolldata.tgz" -C "$STAGING"

echo "[2/6] extract_data_from_csv"
cut -d',' -f1-4 "$STAGING/vehicle-data.csv" > "$STAGING/csv_data.csv"

echo "[3/6] extract_data_from_tsv"
cut -f5-7 "$STAGING/tollplaza-data.tsv" | tr '\t' ',' | tr -d '\r' > "$STAGING/tsv_data.csv"

echo "[4/6] extract_data_from_fixed_width"
cut -c59-67 "$STAGING/payment-data.txt" | tr ' ' ',' > "$STAGING/fixed_width_data.csv"

echo "[5/6] consolidate_data"
paste -d',' "$STAGING/csv_data.csv" "$STAGING/tsv_data.csv" "$STAGING/fixed_width_data.csv" \
  > "$STAGING/extracted_data.csv"

echo "[6/6] transform_data"
paste -d',' \
  <(cut -d',' -f1-3 "$STAGING/extracted_data.csv") \
  <(cut -d',' -f4 "$STAGING/extracted_data.csv" | tr '[:lower:]' '[:upper:]') \
  <(cut -d',' -f5- "$STAGING/extracted_data.csv") \
  > "$STAGING/transformed_data.csv"

echo
echo "Done. First 5 rows of $STAGING/transformed_data.csv:"
head -n 5 "$STAGING/transformed_data.csv"
