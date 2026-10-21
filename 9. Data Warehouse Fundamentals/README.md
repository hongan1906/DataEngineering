# Solid Waste Data Warehouse (PostgreSQL)

Final project for IBM's **Data Warehouse Fundamentals** course (Coursera).
A waste management company in Brazil collects waste with hundreds of trucks across several cities.
This repo designs a star-schema data warehouse, loads the company's data, and answers reporting
questions with `GROUPING SETS`, `ROLLUP`, `CUBE` and a materialized view.

## Business questions
- Total waste collected per year / quarter / month per city
- Total waste collected per year per truck type
- Total waste collected per truck type per station per city

## Data model

Grain: **one fact row = one collection trip**.

```
              DimDate (dateid, date, year, quarter, quartername,
                  |            month, monthname, day, weekday, weekdayname)
                  |
DimTruck ---- FactTrips ---- DimStation
(truckid,     (tripid, dateid,    (stationid, city)
 trucktype)    stationid, truckid,
               wastecollected)
```

The first design (`MyDimDate`, `MyDimWaste`, `MyDimZone`, `MyFactTrips`) is documented in
[`design/star_schema_design.md`](design/star_schema_design.md). The company later changed the
data it could collect, so the final warehouse uses truck and station dimensions instead of
waste type and zone.

## Repo layout

| Path | Purpose | Course tasks |
|---|---|---|
| `design/star_schema_design.md` | Field lists for the first design | 1–4 |
| `sql/01_project_schema.sql` | Tables in database `Project` | 5–8 |
| `sql/02_finalproject_schema.sql` | Tables in database `FinalProject` | 9–12 (setup) |
| `sql/03_load_data.sql` | Load CSVs, show first 5 rows | 9–12 |
| `sql/04_queries.sql` | Grouping sets, rollup, cube | 13–15 |
| `sql/05_materialized_view.sql` | `max_waste_stats` view | 16 |
| `scripts/download_data.sh` | Fetch the 4 CSVs into `data/` | |
| `scripts/run_all.sh` | Build everything end to end | |
| `screenshots/` | Course screenshots (`1-MyDimDate.jpg` … `16-mv.jpg`) | |

## Run it

**Option A — local PostgreSQL**
```bash
./scripts/download_data.sh
export PGHOST=localhost PGUSER=postgres PGPASSWORD=postgres
./scripts/run_all.sh
```

**Option B — Docker**
```bash
docker compose up -d
./scripts/download_data.sh
docker compose exec -e PGUSER=postgres postgres ./scripts/run_all.sh
```

**Option C — pgAdmin (as in the course lab)**
1. Create databases `Project` and `FinalProject`.
2. Run `sql/01_project_schema.sql` in `Project`, and `sql/02_finalproject_schema.sql` in `FinalProject`.
3. Load each CSV with *Import/Export Data* (format csv, header on), in this order:
   DimDate → DimTruck → DimStation → FactTrips.
4. Run `sql/04_queries.sql` and `sql/05_materialized_view.sql`.

## Key concepts shown
- **Star schema**: one fact table with numeric measures, surrounded by denormalized dimensions.
- **Load order**: dimensions before facts, so foreign keys resolve.
- **GROUPING SETS**: only the groupings you list (by station, by truck type).
- **ROLLUP**: hierarchical subtotals, n+1 levels (year → city → station → grand total).
- **CUBE**: every combination, 2ⁿ groupings.
- **Materialized view**: stores an expensive aggregate; refreshed with `REFRESH MATERIALIZED VIEW`.

## Data source
CSV files provided by IBM Skills Network for the course (`scripts/download_data.sh`).
