"""Module 5 · Part 2 — Airflow DAG `process_web_log`.

Daily pipeline over the web server access log:
    extract_data   -> pull the IP address (first field) of every request
    transform_data -> drop all requests from 198.46.149.143
    load_data      -> archive the result into weblog.tar for the big data platform
"""
import os
from datetime import timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago

# Lab path; override with the AIRFLOW_DATA_DIR environment variable
DATA_DIR = os.getenv("AIRFLOW_DATA_DIR", "/home/project/airflow/dags/capstone")

# Task 1 — DAG arguments
default_args = {
    "owner": "An Truong",
    "start_date": days_ago(0),
    "email": ["an.truong@example.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

# Task 2 — DAG definition
dag = DAG(
    dag_id="process_web_log",
    default_args=default_args,
    description="Daily extract, filter and archive of web server log IP addresses",
    schedule_interval=timedelta(days=1),
    catchup=False,
)

# Task 3 — extract: the IP address is the first space-separated field
extract_data = BashOperator(
    task_id="extract_data",
    bash_command=f"cut -d' ' -f1 {DATA_DIR}/accesslog.txt > {DATA_DIR}/extracted_data.txt",
    dag=dag,
)

# Task 4 — transform: remove every line that is exactly 198.46.149.143
#   -v invert match, -x whole line, -F fixed string (dots are not regex wildcards)
#   `|| true` because grep exits 1 when nothing is left, which is not an error here
transform_data = BashOperator(
    task_id="transform_data",
    bash_command=(
        f"grep -vxF '198.46.149.143' {DATA_DIR}/extracted_data.txt "
        f"> {DATA_DIR}/transformed_data.txt || true"
    ),
    dag=dag,
)

# Task 5 — load: archive the transformed file
load_data = BashOperator(
    task_id="load_data",
    bash_command=f"tar -cvf {DATA_DIR}/weblog.tar -C {DATA_DIR} transformed_data.txt",
    dag=dag,
)

# Task 6 — pipeline
extract_data >> transform_data >> load_data
