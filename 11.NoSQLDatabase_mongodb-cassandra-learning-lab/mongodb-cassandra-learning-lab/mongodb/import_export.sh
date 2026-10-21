#!/usr/bin/env bash
# Example commands. Run from a LINUX SHELL, not mongosh.
# Ensure movies.json exists in the current directory.
# Enter a password interactively when prompted where supported.

# Configure connection (do not hardcode passwords or commit credentials):
MONGO_HOST="${MONGO_HOST:-localhost}"
MONGO_PORT="${MONGO_PORT:-27017}"
MONGO_USER="${MONGO_USER:-root}"
MONGO_AUTH_DB="${MONGO_AUTH_DB:-admin}"

# Example course sample download (alternatively use the course's download button):
# curl -O https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-DB0151EN-edX/labs/FinalProject/movies.json

# Pass credentials securely for your installed tool versions, e.g. via prompt.
# Run the following separately, substituting --password YOUR_SECRET only if your
# version requires an explicit argument. Do not capture credentials in screenshots.

# Import newline-delimited JSON movie documents; omit --jsonArray.
mongoimport --host "$MONGO_HOST" --port "$MONGO_PORT" \
  --username "$MONGO_USER" --authenticationDatabase "$MONGO_AUTH_DB" \
  --db entertainment --collection movies --file movies.json

# Export only the fields required by the exercise.
mongoexport --host "$MONGO_HOST" --port "$MONGO_PORT" \
  --username "$MONGO_USER" --authenticationDatabase "$MONGO_AUTH_DB" \
  --db entertainment --collection movies --type csv \
  --fields _id,title,year,rating,Director --out partial_data.csv

# Quick Linux-side check after export:
# head -n 5 partial_data.csv
# wc -l partial_data.csv
