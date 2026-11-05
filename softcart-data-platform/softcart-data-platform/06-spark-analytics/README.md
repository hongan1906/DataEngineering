# Module 6 — Big Data Analytics with Spark

## Part A · Search-term analysis

**Scenario:** The web server records every search. Marketing wants to know what customers look for.

| Question | Answer |
|----------|--------|
| Size of the dataset | 10,000 rows × 4 columns (`day`, `month`, `year`, `searchterm`) |
| Data type of `searchterm` | string |
| "gaming laptop" searches | **499** |
| Top 5 terms | mobile 6 inch (2,312) · mobile 5g (2,301) · mobile latest (1,327) · laptop (935) · tablet wifi (896) |

**Insight:** mobile phones dominate search demand (the top three terms, about 59% of all searches), which is consistent with mobile being a lead product on the sales dashboard in Module 4.

## Part B · Sales forecast with a pretrained SparkML model

The data science team trained a `LinearRegressionModel` (feature: `year`, label: `sales`) and saved it with `model.write().save(...)`. As the data engineer I deploy it: load the saved model, build an input row in the exact shape it was trained on (a `features` vector), and score it.

- Practice lab: saving/loading a model ([IBM notebook](https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0321EN-SkillsNetwork/Bigdata%20and%20Spark/Practise_Lab_-_Model_saving_and_loading.ipynb))
- Graded lab: [`search_terms_analysis.py`](search_terms_analysis.py)

**Predicted sales for 2023:** ___ (fill in from your run)

## Run it

```bash
pip install pyspark
python search_terms_analysis.py --data ../data | tee outputs/module6_output.txt
```
