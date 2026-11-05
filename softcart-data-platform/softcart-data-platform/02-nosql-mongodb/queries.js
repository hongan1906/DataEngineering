// Module 2 · Tasks 2-7 — run with:  mongosh -u root -p <password> --file queries.js
// Each print() label makes the output easy to copy into the submission log.

print("\n== Task 2: list all databases ==");
printjson(db.adminCommand({ listDatabases: 1 }).databases.map(d => d.name));

db = db.getSiblingDB("catalog");

print("\n== Task 3: list collections in catalog ==");
printjson(db.getCollectionNames());

print("\n== Task 4: create an index on 'type' ==");
printjson(db.electronics.createIndex({ type: 1 }));

print("\n== Task 5: number of laptops ==");
print(db.electronics.countDocuments({ type: "laptop" }));

print("\n== Task 6: smart phones with a 6-inch screen ==");
// note: the field name contains a space, so it must be quoted
print(db.electronics.countDocuments({ type: "smart phone", "screen size": 6 }));

print("\n== Task 7: average screen size of smart phones ==");
printjson(
  db.electronics.aggregate([
    { $match: { type: "smart phone" } },
    { $group: { _id: "$type", avg_screen_size: { $avg: "$screen size" } } }
  ]).toArray()
);
