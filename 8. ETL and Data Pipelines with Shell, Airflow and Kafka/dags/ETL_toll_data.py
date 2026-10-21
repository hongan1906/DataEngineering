# ETL_toll_data.py
# Apache Airflow final assignment: consolidate toll plaza data from
# CSV, TSV and fixed-width files into one transformed CSV in the staging area.

# ---------------------------------------------------------------------------
# Imports
# ---------------------------------------------------------------------------
import os
from datetime import timedelta

import pendulum
from airflow import DAG
from airflow.operators.bash import BashOperator

# Base directory used in the lab. Can be overridden with an env var when
# running outside the IBM lab (e.g. with the docker-compose in this repo).
BASE_DIR = os.environ.get("TOLL_BASE_DIR", "/home/project/airflow/dags/finalassignment")
STAGING = f"{BASE_DIR}/staging"

# ---------------------------------------------------------------------------
# Task 1.1: DAG arguments
# ---------------------------------------------------------------------------
default_args = {
    "owner": "Your Name",                      # <-- put your name
    "start_date": pendulum.today("UTC"),       # today
    "email": ["your_email@example.com"],       # <-- put your email
    "email_on_failure": True,
    "email_on_retry": True,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

# ---------------------------------------------------------------------------
# Task 1.2: DAG definition
# ---------------------------------------------------------------------------
dag = DAG(
    dag_id="ETL_toll_data",
    default_args=default_args,
    description="Apache Airflow Final Assignment",
    schedule=timedelta(days=1),                # daily once
    catchup=False,
)

# ---------------------------------------------------------------------------
# Task 2.1: unzip_data
# ---------------------------------------------------------------------------
unzip_data = BashOperator(
    task_id="unzip_data",
    bash_command=f"tar -xzf {BASE_DIR}/tolldata.tgz -C {STAGING}",
    dag=dag,
)

# ---------------------------------------------------------------------------
# Task 2.2: extract_data_from_csv
# Rowid, Timestamp, Anonymized Vehicle number, Vehicle type -> fields 1-4
# ---------------------------------------------------------------------------
extract_data_from_csv = BashOperator(
    task_id="extract_data_from_csv",
    bash_command=f"cut -d',' -f1-4 {STAGING}/vehicle-data.csv > {STAGING}/csv_data.csv",
    dag=dag,
)

# ---------------------------------------------------------------------------
# Task 2.3: extract_data_from_tsv
# Number of axles, Tollplaza id, Tollplaza code -> fields 5-7.
# The TSV has Windows line endings, so strip \r and convert tabs to commas.
# ---------------------------------------------------------------------------
extract_data_from_tsv = BashOperator(
    task_id="extract_data_from_tsv",
    bash_command=(
        f"cut -f5-7 {STAGING}/tollplaza-data.tsv | tr '\\t' ',' | tr -d '\\r' "
        f"> {STAGING}/tsv_data.csv"
    ),
    dag=dag,
)

# ---------------------------------------------------------------------------
# Task 2.4: extract_data_from_fixed_width
# Type of Payment code = chars 59-61, Vehicle Code = chars 63-67
# ---------------------------------------------------------------------------
extract_data_from_fixed_width = BashOperator(
    task_id="extract_data_from_fixed_width",
    bash_command=(
        f"cut -c59-67 {STAGING}/payment-data.txt | tr ' ' ',' "
        f"> {STAGING}/fixed_width_data.csv"
    ),
    dag=dag,
)

# ---------------------------------------------------------------------------
# Task 2.5: consolidate_data
# Rowid, Timestamp, Anonymized Vehicle number, Vehicle type, Number of axles,
# Tollplaza id, Tollplaza code, Type of Payment code, Vehicle Code
# ---------------------------------------------------------------------------
consolidate_data = BashOperator(
    task_id="consolidate_data",
    bash_command=(
        f"paste -d',' {STAGING}/csv_data.csv {STAGING}/tsv_data.csv "
        f"{STAGING}/fixed_width_data.csv > {STAGING}/extracted_data.csv"
    ),
    dag=dag,
)

# ---------------------------------------------------------------------------
# Task 2.6: transform_data
# Upper-case only the vehicle_type field (4th column) using tr.
# ---------------------------------------------------------------------------
transform_data = BashOperator(
    task_id="transform_data",
    bash_command=(
        f"paste -d',' "
        f"<(cut -d',' -f1-3 {STAGING}/extracted_data.csv) "
        f"<(cut -d',' -f4 {STAGING}/extracted_data.csv | tr '[:lower:]' '[:upper:]') "
        f"<(cut -d',' -f5- {STAGING}/extracted_data.csv) "
        f"> {STAGING}/transformed_data.csv"
    ),
    dag=dag,
)

# ---------------------------------------------------------------------------
# Task 2.7: task pipeline
# ---------------------------------------------------------------------------
unzip_data >> extract_data_from_csv >> extract_data_from_tsv >> extract_data_from_fixed_width >> consolidate_data >> transform_data
