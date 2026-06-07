-- 第7章 EXPLAIN / EXPLAIN ANALYZE で実行計画を読む
-- 実行: duckdb < examples/explain.sql （data/ ディレクトリで）

-- 実行計画（推定カーディナリティ）を表示する。クエリは走らない
EXPLAIN
SELECT payment_type, count(*) AS trips
FROM 'yellow_tripdata_sample.parquet'
WHERE fare_amount > 20
GROUP BY payment_type;

-- クエリを実行し、実カーディナリティと所要時間を表示する
EXPLAIN ANALYZE
SELECT payment_type, count(*)
FROM 'yellow_tripdata_sample.parquet'
WHERE fare_amount > 20
GROUP BY payment_type;
