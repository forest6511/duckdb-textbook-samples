-- スカラサブクエリ（平均運賃を超える乗車の件数）
SELECT count(*) AS above_avg
FROM 'data/yellow_tripdata_sample.parquet'
WHERE fare_amount > (
  SELECT avg(fare_amount) FROM 'data/yellow_tripdata_sample.parquet'
);

-- 派生テーブル（事業者ごとの件数を出してから最大を取る）
SELECT max(trips) AS busiest_vendor_trips
FROM (
  SELECT VendorID, count(*) AS trips
  FROM 'data/yellow_tripdata_sample.parquet'
  GROUP BY VendorID
) v;
