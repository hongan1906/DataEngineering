# ETL Toll Data — Apache Airflow Pipeline

Final assignment for the IBM course *ETL and Data Pipelines with Shell, Airflow and Kafka* (Airflow part).

**Scenario:** each national highway is run by a different toll operator, each with its own IT setup and file format. This pipeline collects traffic data from a **CSV**, a **TSV** and a **fixed-width** file, consolidates it into one CSV, transforms it, and loads it into a staging area — orchestrated as an Apache Airflow DAG built only with `BashOperator`.

## Pipeline

```
unzip_data ─► extract_data_from_csv ─► extract_data_from_tsv ─► extract_data_from_fixed_width ─► consolidate_data ─► transform_data
```

| Task | What it does | Output |
|---|---|---|
| `unzip_data` | `tar -xzf tolldata.tgz` into `staging/` | raw files |
| `extract_data_from_csv` | Rowid, Timestamp, Anonymized Vehicle number, Vehicle type from `vehicle-data.csv` (`cut -d, -f1-4`) | `csv_data.csv` |
| `extract_data_from_tsv` | Number of axles, Tollplaza id, Tollplaza code from `tollplaza-data.tsv` (`cut -f5-7`, tabs → commas, strip `\r`) | `tsv_data.csv` |
| `extract_data_from_fixed_width` | Type of Payment code, Vehicle Code from `payment-data.txt` (chars 59–67) | `fixed_width_data.csv` |
| `consolidate_data` | `paste -d,` the three files side by side | `extracted_data.csv` |
| `transform_data` | Upper-case the `Vehicle type` column with `tr` | `transformed_data.csv` |

Final column order:
`Rowid, Timestamp, Anonymized Vehicle number, Vehicle type, Number of axles, Tollplaza id, Tollplaza code, Type of Payment code, Vehicle Code`

Example output row:
```
1,Thu Aug 19 21:56:04 2021,216739,CAR,2,5506,PC7D62772,PTE,VC859
```

## Repository layout

```
etl-toll-data-airflow/
├── dags/
│   └── ETL_toll_data.py          # the DAG (Exercise 1 + 2)
├── scripts/
│   ├── make_sample_data.py       # builds a sample tolldata.tgz in the course's format
│   └── run_pipeline_local.sh     # same bash commands as the DAG, no Airflow needed
├── tests/
│   └── test_dag.py               # DAG integrity tests (pytest)
├── screenshots/                  # put the assignment screenshots here
├── data/                         # local data (git-ignored except sample/)
├── docker-compose.yml            # run Airflow locally
└── requirements.txt
```

## Data source

The course dataset:
```bash
curl -o tolldata.tgz "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Final%20Assignment/tolldata.tgz"
```
If you can't download it, `python scripts/make_sample_data.py data/sample` generates a 20-row sample with the same layout (including the TSV's Windows line endings).

## How to run

### Option A — IBM Skills Network lab (for the graded screenshots)
```bash
sudo mkdir -p /home/project/airflow/dags/finalassignment/staging
sudo chmod -R 777 /home/project/airflow/dags/finalassignment
sudo curl "<dataset url above>" -o /home/project/airflow/dags/finalassignment/tolldata.tgz

cp dags/ETL_toll_data.py /home/project/airflow/dags/       # "submit" the DAG
airflow dags list | grep ETL_toll_data                     # submit_dag.jpg
airflow dags list-import-errors                            # if it's missing
airflow dags unpause ETL_toll_data                         # unpause_trigger_dag.jpg
airflow dags trigger ETL_toll_data
airflow tasks list ETL_toll_data                           # dag_tasks.jpg
airflow dags list-runs -d ETL_toll_data                    # dag_runs.jpg
```

### Option B — locally with Docker
```bash
mkdir -p data/docker_run/staging && chmod -R 777 data/docker_run
python scripts/make_sample_data.py data/sample
cp data/sample/tolldata.tgz data/docker_run/
docker compose up
```
Open http://localhost:8080 (user `admin`, password in the container log). The DAG reads `TOLL_BASE_DIR`, so the same file works in the lab and in Docker.

### Option C — no Airflow at all
```bash
python scripts/make_sample_data.py data/sample
mkdir -p data/local_run && cp data/sample/tolldata.tgz data/local_run/
bash scripts/run_pipeline_local.sh data/local_run
```

### Tests
```bash
pip install -r requirements.txt   # Airflow 2.10.x needs Python 3.9–3.12
pytest -q
```

## Notes
- Built for **Airflow 2.4+** (uses `schedule=`). On an older Airflow, change it to `schedule_interval=timedelta(days=1)`.
- `start_date` is "today" (as the assignment asks) via `pendulum.today("UTC")`; trigger the DAG manually to run it right away.
- Replace `owner` and `email` in `default_args` with your own details.
- `transform_data` upper-cases **only** the vehicle type column (`tr` on that column, then `paste` back) instead of the whole line, so timestamps stay intact.

## Screenshots
See [`screenshots/README.md`](screenshots/README.md) for the full checklist.
