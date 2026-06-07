"""ch05 のサンプルデータを決定論的に再生成する。

ch03/ch04 と同じスキーマの NYC タクシー風 Parquet を生成する。
ただし本章はウィンドウ関数（移動平均・lag・順位）を扱うため、
曜日に応じた件数の変動を決定論的に持たせる（週末は件数が増える）。
乱数は使わず、行番号 i から計算するため何度実行しても同じ結果になる。
"""
import duckdb

con = duckdb.connect()

# 30 日分・曜日で件数が変わる時系列を作る。
# 各日の件数 = base + 曜日係数（土日を多めに）。i から決定論的に算出。
con.execute("""
COPY (
  WITH days AS (
    SELECT
      DATE '2024-01-01' + d::INTEGER AS day,
      -- 0=月 .. 6=日。土(5)・日(6)を多め、週中を少なめに。
      CASE (d::INTEGER + 0) % 7
        WHEN 5 THEN 360   -- 土
        WHEN 6 THEN 400   -- 日
        WHEN 4 THEN 300   -- 金
        ELSE 240          -- 月〜木
      END AS trips
    FROM range(30) t(d)
  ),
  expanded AS (
    SELECT day, generate_series AS n
    FROM days, generate_series(1, trips)
  )
  SELECT
    ((row_number() OVER ()) % 4) + 1                       AS VendorID,
    day + ((n % 1440) * INTERVAL 1 MINUTE)                 AS tpep_pickup_datetime,
    1 + (n % 5)                                            AS passenger_count,
    round(0.5 + (n % 97) * 0.13, 2)                        AS trip_distance,
    round(4.0 + (n % 53) * 0.55, 2)::DECIMAL(23,2)         AS fare_amount,
    CASE WHEN n % 3 = 0 THEN 1 ELSE 2 END                 AS payment_type
  FROM expanded
) TO 'data/yellow_tripdata_sample.parquet' (FORMAT parquet);
""")

# payment_type の対応表（ch04 と同じ）
con.execute("""
COPY (
  SELECT * FROM (VALUES
    (1, 'Credit card'), (2, 'Cash'), (3, 'No charge'), (4, 'Dispute')
  ) v(payment_type, name)
) TO 'data/payment_types.csv' (HEADER, DELIMITER ',');
""")

print("regenerated")
