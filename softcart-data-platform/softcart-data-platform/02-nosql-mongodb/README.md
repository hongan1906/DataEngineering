# Module 2 — Product Catalog in MongoDB

**Scenario:** Products have different attributes: a laptop has RAM and a hard disk, a phone has a screen size. A fixed relational table would be mostly empty columns, so the catalog lives in a document database.

## Tasks and files

| Task | What | Where |
|------|------|-------|
| 1 | Import `catalog.json` → db `catalog`, collection `electronics` | [`commands.sh`](commands.sh) |
| 2–3 | List databases and collections | [`queries.js`](queries.js) |
| 4 | Index on `type` | [`queries.js`](queries.js) |
| 5–7 | Count laptops, count 6" phones, average phone screen size | [`queries.js`](queries.js) |
| 8 | Export `_id`, `type`, `model` to `electronics.csv` | [`commands.sh`](commands.sh) |

## Notes

- The field is literally called `"screen size"` (with a space), so it must be quoted in queries and referenced as `"$screen size"` in the aggregation.
- `countDocuments()` replaces the deprecated `count()`.
- The `type` index helps every query here because each one filters by product type first.

## Run it

```bash
./run.sh     # local Docker MongoDB, output saved to ./outputs
```

## Expected results

| Query | Result |
|-------|--------|
| Laptops | **389** |
| Smart phones with 6" screen | **8** |
| Average smart phone screen size | **6.0** |
