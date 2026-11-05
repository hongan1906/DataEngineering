"""Module 6 — Big data analytics with Spark.

Part A: analyse 10,000 search terms from the SoftCart web server.
Part B: load a pretrained SparkML sales forecasting model and predict 2023 sales.

Usage:  python search_terms_analysis.py --data ../data
(in the IBM lab, run the same cells in the provided Jupyter notebook)
"""
import argparse
from pathlib import Path

from pyspark.ml.feature import VectorAssembler
from pyspark.ml.regression import LinearRegressionModel
from pyspark.sql import SparkSession
from pyspark.sql import functions as F

parser = argparse.ArgumentParser()
parser.add_argument("--data", type=Path, default=Path("../data"))
args = parser.parse_args()

# Start session
spark = SparkSession.builder.appName("SoftCart search term analysis").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

# ---------------------------------------------------------------- Part A
# Load the csv into a spark dataframe
df = spark.read.csv(str(args.data / "searchterms.csv"), header=True, inferSchema=True)

# Print the number of rows and columns
print(f"Rows: {df.count()}, Columns: {len(df.columns)}")

# Print the top 5 rows
df.show(5)

# Find out the datatype of the column searchterm
print("searchterm datatype:", dict(df.dtypes)["searchterm"])

# How many times was the term `gaming laptop` searched?
gaming = df.filter(F.col("searchterm") == "gaming laptop").count()
print("'gaming laptop' searches:", gaming)

# Print the top 5 most frequently used search terms
(df.groupBy("searchterm")
   .count()
   .orderBy(F.desc("count"))
   .show(5, truncate=False))

# ---------------------------------------------------------------- Part B
# Load the sales forecast model (unpacked from model.tar.gz by scripts/download_data.sh)
model = LinearRegressionModel.load(str(args.data / "sales_prediction.model"))


def predict(year: int):
    """Wrap one year in a one-row DataFrame shaped like the model's training data."""
    assembler = VectorAssembler(inputCols=["year"], outputCol="features")
    one_row = spark.createDataFrame([[year, 0]], ["year", "sales"])
    features = assembler.transform(one_row).select("features", "sales")
    return model.transform(features).select("prediction")


# Using the sales forecast model, predict the sales for the year of 2023
predict(2023).show()

spark.stop()
