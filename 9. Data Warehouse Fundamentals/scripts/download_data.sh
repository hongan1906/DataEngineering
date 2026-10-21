#!/usr/bin/env bash
# Download the four course CSV files into data/
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p data
BASE="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0260EN-SkillsNetwork/labs/Final%20Assignment"
for f in DimDate DimTruck DimStation FactTrips; do
  echo "Downloading $f.csv"
  curl -fsSL "$BASE/$f.csv" -o "data/$f.csv"
done
wc -l data/*.csv
