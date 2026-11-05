#!/usr/bin/env bash
# Downloads every dataset used in the capstone into ./data
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p data
B="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud"

declare -A FILES=(
  [oltpdata.csv]="$B/IBM-DB0321EN-SkillsNetwork/oltp/oltpdata.csv"
  [catalog.json]="$B/IBM-DB0321EN-SkillsNetwork/nosql/catalog.json"
  [DimDate.csv]="$B/IBM-DB0321EN-SkillsNetwork/datawarehousing/data/DimDate.csv"
  [DimCategory.csv]="$B/IBM-DB0321EN-SkillsNetwork/datawarehousing/DimCategory.csv"
  [DimCountry.csv]="$B/IBM-DB0321EN-SkillsNetwork/datawarehousing/DimCountry.csv"
  [FactSales.csv]="$B/IBM-DB0321EN-SkillsNetwork/datawarehousing/FactSales.csv"
  [ecommerce.csv]="$B/IBM-DB0321EN-SkillsNetwork/analytics/ecommerce.csv"
  [sales.sql]="$B/IBM-DB0321EN-SkillsNetwork/ETL/sales.sql"
  [sales.csv]="$B/sales-csv3mo8i5SHvta76u7DzUfhiw.csv"
  [accesslog.txt]="$B/IBM-DB0321EN-SkillsNetwork/ETL/accesslog.txt"
  [searchterms.csv]="$B/IBM-DB0321EN-SkillsNetwork/Bigdata%20and%20Spark/searchterms.csv"
  [model.tar.gz]="$B/IBM-DB0321EN-SkillsNetwork/Bigdata%20and%20Spark/model.tar.gz"
)

for name in "${!FILES[@]}"; do
  if [[ -f "data/$name" ]]; then
    echo "skip  $name (already downloaded)"
  else
    echo "fetch $name"
    curl -sSfL "${FILES[$name]}" -o "data/$name"
  fi
done

# The pretrained Spark model ships as a tarball
tar -xzf data/model.tar.gz -C data
echo "Done. Files are in ./data"
