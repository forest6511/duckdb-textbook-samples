-- 第5章 CTE（WITH 句）: 集計を段階分解する
WITH per_payment AS (
  SELECT payment_type, count(*) AS trips, round(avg(fare_amount), 2) AS avg_fare
  FROM 'data/yellow_tripdata_sample.parquet'
  GROUP BY payment_type
)
SELECT payment_type, trips, avg_fare
FROM per_payment
WHERE trips > 3000
ORDER BY payment_type;
