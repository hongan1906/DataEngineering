# Screenshot checklist

| # | File | What to capture |
|---|---|---|
| 1 | `dag_args.jpg` | `default_args` block in `ETL_toll_data.py` |
| 2 | `dag_definition.jpg` | the `DAG(...)` definition |
| 3 | `unzip_data.jpg` | `unzip_data` task code |
| 4 | `extract_data_from_csv.jpg` | `extract_data_from_csv` task code |
| 5 | `extract_data_from_tsv.jpg` | `extract_data_from_tsv` task code |
| 6 | `extract_data_from_fixed_width.jpg` | `extract_data_from_fixed_width` task code |
| 7 | `consolidate_data.jpg` | `consolidate_data` task code |
| 8 | `transform.jpg` | `transform_data` task code |
| 9 | `task_pipeline.jpg` | the `>>` pipeline line at the bottom of the DAG |
| 10 | `submit_dag.jpg` | `airflow dags list` showing `ETL_toll_data` (or Web UI list) |
| 11 | `unpause_trigger_dag.jpg` | DAG unpaused + triggered (CLI or UI toggle) |
| 12 | `dag_tasks.jpg` | `airflow tasks list ETL_toll_data` or Graph view |
| 13 | `dag_runs.jpg` | `airflow dags list-runs -d ETL_toll_data` or Grid view |

Screenshots 1–9 are of code and can be taken from this repo in any editor.
Screenshots 10–13 need a running Airflow (IBM lab, or `docker compose up`).
