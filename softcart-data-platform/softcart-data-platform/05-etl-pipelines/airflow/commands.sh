#!/usr/bin/env bash
# Module 5 · Part 2 · Tasks 7-9 — submit, unpause and monitor the DAG (IBM lab terminal)
set -euo pipefail

# Prepare: download the log to the folder the DAG reads from
mkdir -p /home/project/airflow/dags/capstone
wget -q -O /home/project/airflow/dags/capstone/accesslog.txt \
  https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/ETL/accesslog.txt

# Task 7 — submit: copy the DAG file into the dags folder, then check it is registered
cp process_web_log.py "$AIRFLOW_HOME/dags/"
airflow dags list | grep process_web_log
airflow dags list-import-errors

# Task 8 — unpause so the scheduler starts running it
airflow dags unpause process_web_log

# Task 9 — monitor (also: Airflow UI > DAGs > process_web_log > Grid)
airflow dags list-runs -d process_web_log
