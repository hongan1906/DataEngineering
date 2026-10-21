// Run inside mongosh after: use entertainment

// Task 1: verify the import
db.movies.countDocuments({});
db.movies.findOne();

// Task 2: top release year by number of movies
db.movies.aggregate([
  { $group: { _id: "$year", movie_count: { $sum: 1 } } },
  { $sort: { movie_count: -1 } },
  { $limit: 1 }
]);

// Task 3: movies released after 1999 (exercise expected 99)
db.movies.countDocuments({ year: { $gt: 1999 } });

// Task 4: average Votes for 2007 (exercise expected 192.5)
db.movies.aggregate([
  { $match: { year: 2007 } },
  { $group: { _id: "$year", average_votes: { $avg: "$Votes" } } }
]);
