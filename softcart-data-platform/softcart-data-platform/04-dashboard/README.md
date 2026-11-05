# Module 4 — Sales Dashboard

**Scenario:** The warehouse is live; management now wants a dashboard of the key business metrics.

The graded lab is done in **IBM Cognos Analytics** or **Google Looker Studio** (I used ___ — fill in). Data: `ecommerce.csv` (68,003 sales lines, year 2020, categories Electronics / Ebooks / Music).

## Dashboard

![Dashboard](../docs/screenshots/module4_dashboard.png)

| Task | Chart | Business question |
|------|-------|-------------------|
| 1–3 | Import CSV, preview first 10 rows, create data source | Is the data loaded correctly? |
| 4 | **Line** — total sales by month, 2020 | Is there seasonality? |
| 5 | **Pie** — total sales by category | Which category drives revenue? |
| 6 | **Bar** — quarterly sales of mobile phones | How does our key product trend through the year? |

**Why these chart types:** a line for change over time, a pie only because there are just three categories (more would need a bar), a bar for comparing four discrete quarters.

## Reproduce without a BI tool

```bash
python make_charts.py --data ../data/ecommerce.csv --out outputs
```

This builds the same three charts with pandas + matplotlib.
