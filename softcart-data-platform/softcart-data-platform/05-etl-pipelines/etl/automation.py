"""Module 5 · Part 1 — incremental ETL from MySQL (staging) to PostgreSQL (warehouse).

Every run:
  1. Extract  — read the high-water mark: the last rowid already in the warehouse.
  2. Extract  — pull only MySQL rows with a higher rowid (the new ones).
  3. Load     — insert those rows into the warehouse in one transaction.

Because step 1 is recomputed every run, the job is safe to re-run: a second
run right after the first finds 0 new rows.

Connection details come from environment variables (see ../../.env.example);
in the IBM lab, export them from the values in the MySQL / PostgreSQL panels.
"""
import os

import mysql.connector
import psycopg2
from psycopg2.extras import execute_values

try:  # optional: read ../../.env when running locally
    from dotenv import load_dotenv
    load_dotenv(os.path.join(os.path.dirname(__file__), "..", "..", ".env"))
except ImportError:
    pass

# --- Connect to MySQL (staging) --------------------------------------------
mysql_conn = mysql.connector.connect(
    host=os.getenv("MYSQL_HOST", "localhost"),
    port=int(os.getenv("MYSQL_PORT", "3306")),
    user=os.getenv("MYSQL_USER", "root"),
    password=os.environ["MYSQL_PASSWORD"],
    database=os.getenv("MYSQL_DATABASE", "sales"),
)

# --- Connect to PostgreSQL (production warehouse) --------------------------
pg_conn = psycopg2.connect(
    host=os.getenv("POSTGRES_HOST", "localhost"),
    port=os.getenv("POSTGRES_PORT", "5432"),
    user=os.getenv("POSTGRES_USER", "postgres"),
    password=os.environ["POSTGRES_PASSWORD"],
    dbname=os.getenv("POSTGRES_DATABASE", "postgres"),
)


# Task 1 ---------------------------------------------------------------------
def get_last_rowid():
    """Return the highest rowid in the warehouse table (0 if it is empty)."""
    with pg_conn.cursor() as cur:
        cur.execute("SELECT COALESCE(MAX(rowid), 0) FROM sales_data;")
        return cur.fetchone()[0]


last_row_id = get_last_rowid()
print("Last row id on production datawarehouse = ", last_row_id)


# Task 2 ---------------------------------------------------------------------
def get_latest_records(rowid):
    """Return all MySQL rows with rowid greater than `rowid`, oldest first."""
    cur = mysql_conn.cursor()
    cur.execute(
        "SELECT rowid, product_id, customer_id, quantity "
        "FROM sales_data WHERE rowid > %s ORDER BY rowid;",
        (rowid,),
    )
    rows = cur.fetchall()
    cur.close()
    return rows


new_records = get_latest_records(last_row_id)
print("New rows on staging datawarehouse = ", len(new_records))


# Task 3 ---------------------------------------------------------------------
def insert_records(records):
    """Insert the records into the warehouse in a single transaction.

    price and timestamp are not in the staging table, so the warehouse
    column defaults fill them in.
    """
    if not records:
        return
    with pg_conn.cursor() as cur:
        execute_values(
            cur,
            "INSERT INTO sales_data (rowid, product_id, customer_id, quantity) VALUES %s",
            records,
            page_size=1000,
        )
    pg_conn.commit()  # all-or-nothing: a failure leaves the warehouse unchanged


insert_records(new_records)
print("New rows inserted into production datawarehouse = ", len(new_records))

# --- Disconnect --------------------------------------------------------------
mysql_conn.close()
pg_conn.close()
# End of program
