"""DuckDB と Polars の相互運用（.pl() と Polars DataFrame の直接クエリ）。

Polars を DuckDB から直接クエリするには pyarrow が必要。
"""
import duckdb
import polars as pl

# DuckDB の結果を Polars DataFrame として受け取る
df = duckdb.sql("""
    SELECT payment_type, count(*) AS trips
    FROM 'data/yellow_tripdata_sample.parquet'
    GROUP BY payment_type ORDER BY payment_type
""").pl()
print(df)

# Polars DataFrame（変数名 trips）を DuckDB SQL から直接参照
trips = pl.read_parquet("data/yellow_tripdata_sample.parquet")
out = duckdb.sql("""
    SELECT payment_type, round(avg(trip_distance), 2) AS avg_dist
    FROM trips
    GROUP BY payment_type ORDER BY payment_type
""").pl()
print(out)
