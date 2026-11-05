# Module 1 — OLTP Database (MySQL)

**Scenario:** SoftCart needs an operational (OLTP) database for its sales transactions. Thousands of small inserts per day, each one a single order line.

## Tasks and files

| Task | What | File |
|------|------|------|
| 1–2 | Create database `sales` and table `sales_data` | [`01_create_table.sql`](01_create_table.sql) |
| 3 | Load `oltpdata.csv`, list tables, count rows | [`02_load_data.sql`](02_load_data.sql) |
| 4–5 | Create index `ts` on `timestamp`, list indexes | [`03_admin_tasks.sql`](03_admin_tasks.sql) |
| 6 | Bash script that exports the table to `sales_data.sql` | [`datadump.sh`](datadump.sh) |

## Design decisions

- **Integer columns for IDs, price and quantity.** The source data only has whole numbers; integers are smaller and faster to compare.
- **`DATETIME` for the timestamp.** Most reports filter or group by time, so the `ts` index lets MySQL find a date range without scanning the whole table.
- **`mysqldump` for backups.** It writes plain SQL (`CREATE TABLE` + `INSERT`s), so the backup can be restored on any MySQL server and read by a human.

## Run it

```bash
./run.sh            # local Docker MySQL, outputs saved to ./outputs
```

In the IBM lab: start MySQL, open phpMyAdmin, import `oltpdata.csv` into `sales_data`, and run the SQL files in the MySQL terminal.

## Expected results

- `SELECT COUNT(*) FROM sales_data;` → **2605**
- `SHOW INDEX FROM sales_data;` → one row, `Key_name = ts`, `Column_name = timestamp`
