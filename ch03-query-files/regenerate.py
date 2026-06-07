"""ch03 のサンプルデータを決定論的に再生成する。"""
import duckdb

con = duckdb.connect()
con.execute("""
COPY (
  SELECT
    (i % 4) + 1                             AS VendorID,
    TIMESTAMP '2024-01-01 00:00:00'
      + (i * INTERVAL 7 MINUTE)             AS tpep_pickup_datetime,
    1 + (i % 5)                             AS passenger_count,
    round(0.5 + (i % 97) * 0.13, 2)         AS trip_distance,
    round(4.0 + (i % 53) * 0.55, 2)         AS fare_amount,
    CASE WHEN i % 3 = 0 THEN 1 ELSE 2 END   AS payment_type
  FROM range(10000) t(i)
) TO 'data/yellow_tripdata_sample.parquet' (FORMAT parquet);
""")
con.execute("""
COPY (
  SELECT * FROM (VALUES
    ('Tokyo', 2024, 980), ('Osaka', 2024, 760),
    ('Tokyo', 2025, 1020), ('Osaka', 2025, 815)
  ) v(city, year, sales)
) TO 'data/sales.csv' (HEADER, DELIMITER ',');
""")
print("regenerated")
