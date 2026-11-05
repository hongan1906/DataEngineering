#!/usr/bin/env bash
# Module 2 · all tasks. Inside the IBM lab, set MONGO_HOST/MONGO_PASSWORD
# to the values in the MongoDB connection panel.
set -euo pipefail

MONGO_HOST="${MONGO_HOST:-localhost}"
MONGO_USER="${MONGO_USER:-root}"
: "${MONGO_PASSWORD:?Set MONGO_PASSWORD}"
DATA_DIR="${DATA_DIR:-.}"
AUTH=(--host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASSWORD" --authenticationDatabase admin)

echo "== Task 1: import catalog.json into catalog.electronics =="
mongoimport "${AUTH[@]}" --db catalog --collection electronics --drop \
  --file "$DATA_DIR/catalog.json"

echo "== Tasks 2-7: queries =="
mongosh --quiet --host "$MONGO_HOST" -u "$MONGO_USER" -p "$MONGO_PASSWORD" \
  --authenticationDatabase admin --file queries.js

echo "== Task 8: export _id, type, model to electronics.csv =="
mongoexport "${AUTH[@]}" --db catalog --collection electronics \
  --type=csv --fields _id,type,model --out electronics.csv
head -5 electronics.csv
