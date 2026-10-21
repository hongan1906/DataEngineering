"""DAG integrity tests. Run with:  pytest -q   (needs apache-airflow installed)"""
from pathlib import Path

import pytest

airflow = pytest.importorskip("airflow")
from airflow.models import DagBag  # noqa: E402

DAGS_DIR = Path(__file__).resolve().parents[1] / "dags"

EXPECTED_ORDER = [
    "unzip_data",
    "extract_data_from_csv",
    "extract_data_from_tsv",
    "extract_data_from_fixed_width",
    "consolidate_data",
    "transform_data",
]


@pytest.fixture(scope="module")
def dag():
    bag = DagBag(dag_folder=str(DAGS_DIR), include_examples=False)
    assert bag.import_errors == {}, bag.import_errors
    return bag.get_dag("ETL_toll_data")


def test_dag_loaded(dag):
    assert dag is not None
    assert dag.description == "Apache Airflow Final Assignment"


def test_default_args(dag):
    args = dag.default_args
    assert args["email_on_failure"] is True
    assert args["email_on_retry"] is True
    assert args["retries"] == 1
    assert args["retry_delay"].total_seconds() == 300


def test_all_tasks_are_bash(dag):
    assert {t.task_type for t in dag.tasks} == {"BashOperator"}


def test_pipeline_order(dag):
    assert set(dag.task_ids) == set(EXPECTED_ORDER)
    for upstream, downstream in zip(EXPECTED_ORDER, EXPECTED_ORDER[1:]):
        assert dag.get_task(upstream).downstream_task_ids == {downstream}
