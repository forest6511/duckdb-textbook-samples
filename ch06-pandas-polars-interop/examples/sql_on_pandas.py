"""Pandas DataFrame を DuckDB の SQL から変数名で直接クエリする。"""
import duckdb

# DuckDB で Parquet を読み、Pandas DataFrame として受け取る
trips = duckdb.sql("SELECT * FROM 'data/yellow_tripdata_sample.parquet'").df()
print("rows:", len(trips))

# その Pandas DataFrame（変数名 trips）を SQL から直接参照（事前登録は不要）
out = duckdb.sql("""
    SELECT payment_type, count(*) AS n
    FROM trips
    WHERE fare_amount > 20
    GROUP BY payment_type ORDER BY payment_type
""").df()
print(out)
