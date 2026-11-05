#!/usr/bin/env bash
# Runs Module 2 inside the local MongoDB container (it ships with mongosh and the tools)
set -euo pipefail
cd "$(dirname "$0")"
source ../.env
mkdir -p outputs
docker exec -w /work -e MONGO_PASSWORD="$MONGO_PASSWORD" -e DATA_DIR=/data/import \
  softcart-mongo bash commands.sh | tee outputs/module2_output.txt
