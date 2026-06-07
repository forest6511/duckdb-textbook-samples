"""DuckDB の結果を Pandas DataFrame として受け取る（.df()）。"""
import duckdb

df = duckdb.sql("""
    SELECT payment_type, count(*) AS trips,
           round(avg(fare_amount), 2) AS avg_fare
    FROM 'data/yellow_tripdata_sample.parquet'
    GROUP BY payment_type ORDER BY payment_type
""").df()

print(type(df).__name__)
print(df)
