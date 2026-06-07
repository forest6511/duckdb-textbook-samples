"""第10章: 同じパイプラインを Python で束ねる。
実行: python examples/pipeline.py
"""
import duckdb

con = duckdb.connect("pipeline.db")

con.execute("""
    CREATE OR REPLACE TABLE trips_clean AS
    SELECT
        tpep_pickup_datetime::DATE AS pickup_date,
        passenger_count,
        payment_type,
        fare_amount
    FROM 'data/trips.parquet'
    WHERE fare_amount > 0
      AND passenger_count > 0;
""")

con.execute("""
    CREATE OR REPLACE TABLE daily_fare AS
    SELECT
        pickup_date,
        payment_type,
        count(*) AS trips,
        sum(fare_amount) AS total_fare
    FROM trips_clean
    GROUP BY ALL
    ORDER BY pickup_date, payment_type;
""")

con.execute("""
    COPY daily_fare TO 'output/daily_fare.parquet' (FORMAT parquet);
""")

print(con.sql("SELECT count(*) AS rows FROM daily_fare"))
con.close()
