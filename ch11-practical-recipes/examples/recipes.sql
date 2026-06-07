-- 第11章 実務レシピ集。data/ をカレントに duckdb < examples/recipes.sql で実行。
-- 各レシピは本書の本文と1対1対応。

-- レシピ1: 重複排除（QUALIFY + row_number、最新だけ残す）
.print --- recipe 1: dedup ---
FROM 'data/trips.parquet'
SELECT trip_id, pickup_at, fare_amount
QUALIFY row_number() OVER
    (PARTITION BY trip_id ORDER BY pickup_at DESC) = 1
ORDER BY trip_id
LIMIT 5;

-- 重複排除の前後で件数が変わることの確認
.print --- recipe 1: row counts before/after ---
SELECT
    count(*) AS raw_rows,
    count(DISTINCT trip_id) AS unique_trips
FROM 'data/trips.parquet';

-- レシピ2: トップN per group（日付ごと運賃トップ3）
.print --- recipe 2: top 3 fares per day ---
FROM 'data/trips.parquet'
SELECT pickup_date, trip_id, fare_amount,
    row_number() OVER (PARTITION BY pickup_date
                       ORDER BY fare_amount DESC) AS rnk
QUALIFY rnk <= 3
ORDER BY pickup_date, rnk
LIMIT 6;

-- レシピ3: 欠損値処理（NULL を 0 と平均で埋める）
.print --- recipe 3: fill missing ---
SELECT
    trip_id,
    passenger_count,
    coalesce(passenger_count, 0) AS pc_zero,
    coalesce(passenger_count,
        (SELECT round(avg(passenger_count), 2)
         FROM 'data/trips.parquet')) AS pc_mean
FROM 'data/trips.parquet'
WHERE passenger_count IS NULL
ORDER BY trip_id
LIMIT 5;

-- レシピ4: 時系列リサンプル（日次 KPI）
.print --- recipe 4: daily KPI ---
FROM 'data/trips.parquet'
SELECT
    date_trunc('day', pickup_at) AS day,
    count(*) AS trips,
    round(sum(fare_amount), 2) AS revenue,
    round(avg(fare_amount), 2) AS avg_fare
GROUP BY ALL
ORDER BY day;

-- レシピ5: 分布の把握（運賃の四分位を一括）
.print --- recipe 5: quartiles ---
WITH stats AS (
    SELECT percentile_disc([0.25, 0.5, 0.75])
             WITHIN GROUP (ORDER BY fare_amount) AS p
    FROM 'data/trips.parquet'
)
SELECT p[1] AS q1, p[2] AS median, p[3] AS q3 FROM stats;

-- レシピ6: 複数ファイル一括（日付別 parquet を横断集計）
.print --- recipe 6: multi-file glob ---
SELECT
    pickup_date,
    count(*) AS trips
FROM read_parquet('data/logs/**/*.parquet', hive_partitioning = true)
GROUP BY ALL
ORDER BY pickup_date;

-- レシピ7: カテゴリ別ピボット集計（支払方法を列に）
.print --- recipe 7: pivot by payment_type ---
PIVOT 'data/trips.parquet'
ON payment_type
USING count(*) AS trips
GROUP BY pickup_date
ORDER BY pickup_date;
