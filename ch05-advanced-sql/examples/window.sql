-- 第5章 ウィンドウ関数: 順位付け・前日比・移動平均

-- 日別件数の順位（row_number / rank / dense_rank の違い）
WITH daily AS (
  SELECT tpep_pickup_datetime::DATE AS day, count(*) AS trips
  FROM 'data/yellow_tripdata_sample.parquet'
  GROUP BY day
)
SELECT day, trips,
  row_number() OVER (ORDER BY trips DESC) AS rn,
  rank()       OVER (ORDER BY trips DESC) AS rnk,
  dense_rank() OVER (ORDER BY trips DESC) AS drnk
FROM daily
ORDER BY trips DESC, day
LIMIT 8;

-- 前日比（lag）
WITH daily AS (
  SELECT tpep_pickup_datetime::DATE AS day, count(*) AS trips
  FROM 'data/yellow_tripdata_sample.parquet'
  GROUP BY day
)
SELECT day, trips,
  lag(trips) OVER (ORDER BY day) AS prev_day,
  trips - lag(trips) OVER (ORDER BY day) AS diff
FROM daily
ORDER BY day
LIMIT 8;

-- 7日移動平均（ROWS BETWEEN 6 PRECEDING AND CURRENT ROW）
WITH daily AS (
  SELECT tpep_pickup_datetime::DATE AS day, count(*) AS trips
  FROM 'data/yellow_tripdata_sample.parquet'
  GROUP BY day
)
SELECT day, trips,
  round(avg(trips) OVER (
    ORDER BY day ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
  ), 1) AS ma7
FROM daily
ORDER BY day
LIMIT 10;
