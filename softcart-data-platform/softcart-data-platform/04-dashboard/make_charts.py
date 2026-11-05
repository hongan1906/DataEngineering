"""Module 4 — reproduce the SoftCart dashboard charts in Python.

The graded lab builds these charts in IBM Cognos Analytics or Google Looker
Studio. This script rebuilds the same three charts from ecommerce.csv so the
dashboard can be reproduced without a BI licence.

Usage:  python make_charts.py --data ../data/ecommerce.csv --out outputs
"""
import argparse
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd

MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]


def main(data_path: Path, out_dir: Path) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    df = pd.read_csv(data_path)
    print(f"Loaded {len(df):,} rows. First 10 rows:\n{df.head(10)}\n")

    fig, axes = plt.subplots(1, 3, figsize=(18, 5))
    fig.suptitle("SoftCart sales dashboard — 2020", fontsize=16, fontweight="bold")

    # Task 4 — line chart: month-wise total sales for 2020
    monthly = df[df["year"] == 2020].groupby("month")["price"].sum().reindex(range(1, 13))
    ax = axes[0]
    ax.plot(MONTHS, monthly.values, marker="o")
    ax.set_title("Total sales by month")
    ax.set_ylabel("Sales")
    ax.grid(alpha=0.3)

    # Task 5 — pie chart: category-wise total sales
    by_category = df.groupby("category")["price"].sum().sort_values(ascending=False)
    axes[1].pie(by_category.values, labels=by_category.index, autopct="%1.1f%%", startangle=90)
    axes[1].set_title("Total sales by category")

    # Task 6 — bar chart: quarterly sales of mobile phones
    mobile = df[df["item"] == "Mobile"].groupby("quarter")["price"].sum()
    ax = axes[2]
    ax.bar([f"Q{q}" for q in mobile.index], mobile.values)
    ax.set_title("Quarterly sales — mobile phones")
    ax.set_ylabel("Sales")

    fig.tight_layout()
    path = out_dir / "dashboard.png"
    fig.savefig(path, dpi=150)
    print("Monthly sales:\n", monthly, "\n\nBy category:\n", by_category,
          "\n\nMobile by quarter:\n", mobile)
    print(f"\nSaved {path}")


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--data", type=Path, default=Path("../data/ecommerce.csv"))
    p.add_argument("--out", type=Path, default=Path("outputs"))
    a = p.parse_args()
    main(a.data, a.out)
