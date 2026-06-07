-- 支払い種別ごとの件数と平均運賃
SELECT payment_type, count(*) AS trips, round(avg(fare_amount), 2) AS avg_fare
FROM 'data/yellow_tripdata_sample.parquet'
GROUP BY payment_type
ORDER BY payment_type;

-- GROUP BY ALL（SELECT の非集計列を自動でグループ化）
SELECT payment_type, count(*) AS trips
FROM 'data/yellow_tripdata_sample.parquet'
GROUP BY ALL
ORDER BY payment_type;

-- FILTER による条件付き集計
SELECT
  count(*) AS total,
  count(*) FILTER (trip_distance > 5) AS long_trips,
  count(*) FILTER (payment_type = 1) AS card_trips
FROM 'data/yellow_tripdata_sample.parquet';

-- HAVING（集計後の絞り込み）
SELECT payment_type, count(*) AS trips
FROM 'data/yellow_tripdata_sample.parquet'
GROUP BY payment_type
HAVING count(*) > 5000;
