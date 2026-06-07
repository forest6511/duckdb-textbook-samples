"""第11章 実務レシピ集のサンプルデータを決定論的に生成する。

レシピ章なので、現場頻出のパターン（重複排除・欠損処理・トップN・
時系列リサンプル・複数ファイル一括）が意味を持つように、あえて
- 重複行を数件
- NULL（欠損）を数件
- 日付ごとに件数・運賃が変動
させた NYC タクシー風データを作る。乱数は使わず、index から
決定論的に値を導くので、何度実行しても同じ Parquet になる。
"""

import duckdb

con = duckdb.connect()

# 5 日分（2024-01-01〜05）、日ごとに件数を変えて変動を作る。
# 1 日目=20 件、2 日目=24 件 ... と日ごとに増やす。
# fare は曜日的な変動を index から決める。passenger_count に NULL を混ぜる。
con.execute("""
CREATE TABLE trips AS
WITH days AS (
    SELECT UNNEST([
        DATE '2024-01-01', DATE '2024-01-02', DATE '2024-01-03',
        DATE '2024-01-04', DATE '2024-01-05'
    ]) AS pickup_date,
    UNNEST([20, 24, 28, 22, 30]) AS n
),
expanded AS (
    SELECT
        pickup_date,
        gs.generate_series AS i
    FROM days, generate_series(1, n) AS gs
)
SELECT
    -- trip_id: 日付ごとに連番。あとで重複を足すのでここは一意。
    row_number() OVER (ORDER BY pickup_date, i) AS trip_id,
    pickup_date,
    -- pickup_at: 同じ日でも時刻をずらす（時系列リサンプルの題材）
    pickup_date::TIMESTAMP + (i * INTERVAL 37 MINUTE) AS pickup_at,
    -- passenger_count: 5 件に 1 件を NULL（欠損）にする
    CASE WHEN i % 5 = 0 THEN NULL ELSE 1 + (i % 4) END AS passenger_count,
    -- payment_type: 1（カード）/ 2（現金）を交互に
    CASE WHEN i % 2 = 0 THEN 1 ELSE 2 END AS payment_type,
    -- fare_amount: index と日付から決定論的に。トップN が意味を持つよう散らす
    round(8.0 + ((i * 7 + day(pickup_date) * 3) % 40), 2) AS fare_amount,
    round(1.0 + ((i * 3) % 12) * 0.5, 2) AS trip_distance
FROM expanded
ORDER BY pickup_date, i;
""")

# 重複行を意図的に 3 件足す（重複排除レシピの題材）。
# trip_id 1, 2, 3 をもう一度（pickup_at を少し後ろにずらした「再送」想定）
con.execute("""
INSERT INTO trips
SELECT trip_id, pickup_date,
       pickup_at + INTERVAL 1 SECOND,
       passenger_count, payment_type, fare_amount, trip_distance
FROM trips WHERE trip_id IN (1, 2, 3);
""")

con.execute("""
COPY trips TO 'data/trips.parquet' (FORMAT parquet);
""")

# 複数ファイル一括レシピ用に、日付ごとに分割した parquet も書き出す。
con.execute("""
COPY trips TO 'data/logs' (FORMAT parquet, PARTITION_BY (pickup_date));
""")

# Hive パーティションだと logs/pickup_date=2024-01-01/ のように
# サブディレクトリに入る。レシピでは glob で横断する。
total = con.execute("SELECT count(*) FROM trips").fetchone()[0]
nulls = con.execute(
    "SELECT count(*) FROM trips WHERE passenger_count IS NULL"
).fetchone()[0]
print(f"rows={total} (incl. 3 dup), null passenger_count={nulls}")
con.close()
