-- Parquet を直接クエリする
SELECT VendorID, trip_distance, fare_amount
FROM 'data/yellow_tripdata_sample.parquet'
LIMIT 3;

-- スキーマを確認する
DESCRIBE SELECT * FROM 'data/yellow_tripdata_sample.parquet';

-- 件数と平均運賃を集計する
SELECT count(*) AS trips, round(avg(fare_amount), 2) AS avg_fare
FROM 'data/yellow_tripdata_sample.parquet';

-- ファイルメタデータ（行数・行グループ数）を見る
SELECT num_rows, num_row_groups
FROM parquet_file_metadata('data/yellow_tripdata_sample.parquet');
