# Exercise 1 — Star schema design (Tasks 1–4)

Grain: **one row in the fact table = one waste-collection trip**.
Measure: waste collected (tons). Everything else is context and goes into a dimension.

## Task 1 — MyDimDate (`1-MyDimDate.jpg`)
```
dateid
date
year
quarter
quartername
month
monthname
day
weekday
weekdayname
```

## Task 2 — MyDimWaste (`2-MyDimWaste.jpg`)
```
wasteid
wastetype
```

## Task 3 — MyDimZone (`3-MyDimZone.jpg`)
```
zoneid
collectionzone
city
```

## Task 4 — MyFactTrips (`4-MyFactTrips.jpg`)
```
tripid
dateid
wasteid
zoneid
wastecollected
```

## Diagram

```
                 MyDimDate
                     |
   MyDimWaste --- MyFactTrips --- MyDimZone
```

## Why this design
- Integer surrogate keys (`dateid`, `wasteid`, `zoneid`) keep the fact table narrow and joins fast.
- `MyDimDate` pre-computes year/quarter/month/weekday so reports group by attributes instead of
  calling date functions on every row.
- Zone and city stay in one denormalized table (star, not snowflake) — fewer joins for BI queries.
