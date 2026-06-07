-- 第5章 QUALIFY: 各週で最も忙しい日（top 1 per week）
WITH daily AS (
  SELECT tpep_pickup_datetime::DATE AS day,
         week(tpep_pickup_datetime) AS wk,
         count(*) AS trips
  FROM 'data/yellow_tripdata_sample.parquet'
  GROUP BY 1, 2
)
SELECT wk, day, trips
FROM daily
QUALIFY row_number() OVER (PARTITION BY wk ORDER BY trips DESC, day) = 1
ORDER BY wk;
