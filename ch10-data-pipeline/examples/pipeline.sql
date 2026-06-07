-- 第10章: 軽量データパイプライン（extract -> transform -> load）
-- 実行: duckdb pipeline.db < examples/pipeline.sql

-- ステージ1: 抽出 + クレンジング（CREATE OR REPLACE で冪等に）
CREATE OR REPLACE TABLE trips_clean AS
SELECT
    tpep_pickup_datetime::DATE AS pickup_date,
    passenger_count,
    payment_type,
    fare_amount
FROM 'data/trips.parquet'
WHERE fare_amount > 0
  AND passenger_count > 0;

-- ステージ2: 集計（日次・支払方法別の運賃合計）
CREATE OR REPLACE TABLE daily_fare AS
SELECT
    pickup_date,
    payment_type,
    count(*) AS trips,
    sum(fare_amount) AS total_fare
FROM trips_clean
GROUP BY ALL
ORDER BY pickup_date, payment_type;

-- ステージ3: 成果物を Parquet で書き出し
COPY daily_fare TO 'output/daily_fare.parquet' (FORMAT parquet);
