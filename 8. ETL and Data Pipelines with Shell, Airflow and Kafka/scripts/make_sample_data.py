"""
Generate a small sample of the toll data in the same layout as the course's
tolldata.tgz, so the pipeline can be tested without the IBM lab environment.

Produces (in the output dir):
    vehicle-data.csv      comma separated, no header, Unix line endings
    tollplaza-data.tsv    tab separated, no header, Windows (\r\n) line endings
    payment-data.txt      fixed width, no header
    fileformats.txt       column description
    tolldata.tgz          all of the above, tar+gzip (same as the course download)

Usage:
    python scripts/make_sample_data.py data/sample
"""
import random
import sys
import tarfile
from datetime import datetime, timedelta
from pathlib import Path

VEHICLE_TYPES = {"car": 2, "truck": 4, "van": 2, "tempo": 3}

FILEFORMATS = """vehicle-data.csv:
vehicle-data.csv is a comma-separated values file.
It has the below 6 fields

Rowid  - This uniquely identifies each row. This is consistent across all the three files.
Timestamp - What time did the vehicle pass through the toll gate.
Anonymized Vehicle number - Anonymized registration number of the vehicle
Vehicle type - Type of the vehicle
Number of axles - Number of axles of the vehicle
Vehicle code - Category of the vehicle as per the toll plaza.

tollplaza-data.tsv:
tollplaza-data.tsv is a tab-separated values file.
It has the below 7 fields

Rowid  - This uniquely identifies each row. This is consistent across all the three files.
Timestamp - What time did the vehicle pass through the toll gate.
Anonymized Vehicle number - Anonymized registration number of the vehicle
Vehicle type - Type of the vehicle
Number of axles - Number of axles of the vehicle
Tollplaza id - Id of the toll plaza
Tollplaza code - Tollplaza's code.

payment-data.txt:
payment-data.txt is a fixed width file. Each field occupies a fixed number of characters.
It has the below 7 fields

Rowid  - This uniquely identifies each row. This is consistent across all the three files.
Timestamp - What time did the vehicle pass through the toll gate.
Anonymized Vehicle number - Anonymized registration number of the vehicle
Tollplaza id - Id of the toll plaza
Tollplaza code - Tollplaza's code.
Type of Payment code - Code to identify the type of payment. Values are PTE, PTP
Vehicle Code - Category of the vehicle as per the toll plaza.
"""


def main(out_dir: str, n_rows: int = 20, seed: int = 42) -> None:
    random.seed(seed)
    out = Path(out_dir)
    out.mkdir(parents=True, exist_ok=True)

    ts = datetime(2021, 8, 19, 21, 54, 38)
    csv_lines, tsv_lines, fw_lines = [], [], []
    for rowid in range(1, n_rows + 1):
        ts += timedelta(seconds=random.randint(5, 90))
        stamp = ts.strftime("%a %b %d %H:%M:%S %Y")          # 24 chars
        vnum = random.randint(100000, 999999)
        vtype = random.choice(list(VEHICLE_TYPES))
        axles = VEHICLE_TYPES[vtype]
        vcode = f"VC{random.randint(100, 999)}"
        plaza_id = random.randint(1000, 9999)
        plaza_code = f"PC{random.randint(0, 0xFFFFFFF):07X}"
        pay = random.choice(["PTE", "PTP"])

        csv_lines.append(f"{rowid},{stamp},{vnum},{vtype},{axles},{vcode}\n")
        tsv_lines.append(f"{rowid}\t{stamp}\t{vnum}\t{vtype}\t{axles}\t{plaza_id}\t{plaza_code}\r\n")
        # Fixed width layout (1-based columns):
        #   1-6 rowid | 8-31 timestamp | 34-39 vehicle no | 42-45 plaza id |
        #   47-55 plaza code | 59-61 payment code | 63-67 vehicle code
        fw_lines.append(
            f"{rowid:>6} {stamp}  {vnum:>6}  {plaza_id:>4} {plaza_code:<9}   {pay} {vcode}\n"
        )

    (out / "vehicle-data.csv").write_text("".join(csv_lines), newline="")
    (out / "tollplaza-data.tsv").write_text("".join(tsv_lines), newline="")
    (out / "payment-data.txt").write_text("".join(fw_lines), newline="")
    (out / "fileformats.txt").write_text(FILEFORMATS)

    with tarfile.open(out / "tolldata.tgz", "w:gz") as tar:
        for name in ["fileformats.txt", "payment-data.txt", "tollplaza-data.tsv", "vehicle-data.csv"]:
            tar.add(out / name, arcname=name)
    print(f"Wrote sample data ({n_rows} rows) to {out.resolve()}")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "data/sample")
