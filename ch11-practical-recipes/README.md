# 第11章 実務レシピ集 — そのまま使える分析パターン

これまで学んだ道具を組み合わせて、現場でよく出くわす 7 つの分析パターンを解くまとめの章です。重複排除・トップN・欠損値処理・時系列リサンプル・分布の把握・複数ファイル横断・ピボットを、1 つのサンプルデータで通して実演します。

## サンプルデータ

現場らしさを出すため、NYC タクシー風データに **重複行 3 件** と **欠損値（NULL）** を意図的に混ぜています。乱数は使わず、件数も値も毎回同じになります。

```bash
cd ch11-practical-recipes
python regenerate.py
# => rows=127（うち重複 3 件）、passenger_count の NULL=23 件
```

生成物:

- `data/trips.parquet` — 127 行（trip_id 1 / 2 / 3 が重複、`passenger_count` の一部が NULL）
- `data/logs/pickup_date=YYYY-MM-DD/data_0.parquet` — 日付ごとに分割した Parquet（複数ファイル横断レシピで使用）

## 実行方法

```bash
cd ch11-practical-recipes
duckdb < examples/recipes.sql
```

## レシピ一覧（本書の節に対応）

- **11-1 重複排除** — `QUALIFY` + `row_number()` で、キーごとに最新の 1 行だけ残す
- **11-2 トップN per group** — 11-1 と同じ型で、残す条件を `<= 3` に変えるだけ
- **11-3 欠損値処理** — `coalesce()` で NULL を 0 や平均に置き換える
- **11-4 時系列リサンプル** — `date_trunc()` + `GROUP BY ALL` で日次・時間別に集計する
- **11-5 分布の把握** — `percentile_disc([...]) WITHIN GROUP` で四分位を一度に求める
- **11-6 複数ファイル横断** — glob `**` + `hive_partitioning` で分割ファイルをまとめて読む
- **11-7 カテゴリ別ピボット** — `PIVOT` で支払方法別の件数を横持ちにする

すべて DuckDB 1.5.3 で実機実行し、本書掲載の出力ボックスと一致することを確認済みです。

## 注意

- `data/trips.parquet` と `data/logs/` は `regenerate.py` で再生成できます
- 重複排除（11-1）とトップN（11-2）が同じ型のクエリで書けることが、この章のポイントです。残す条件を `= 1` にするか `<= 3` にするかの違いだけです
