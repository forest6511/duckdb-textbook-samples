# 第11章 実務レシピ集 ― サンプル

本書で一貫して使う NYC タクシー風データに、現場らしさを出すため
**重複行3件** と **欠損値（NULL）** を混ぜたサンプルでレシピを実演する。

## サンプル生成（決定論的・乱数なし）

```bash
cd ch11-practical-recipes
../.venv/bin/python regenerate.py
# => rows=127 (incl. 3 dup), null passenger_count=23
```

生成物:

- `data/trips.parquet` … 127 行（うち trip_id 1/2/3 が重複、passenger_count に NULL）
- `data/logs/pickup_date=YYYY-MM-DD/data_0.parquet` … 日付別に分割（複数ファイル横断レシピ用）

## レシピ実行

```bash
cd ch11-practical-recipes
duckdb < examples/recipes.sql
```

## レシピ一覧（本書の節と対応）

- 11-1 重複排除 … `QUALIFY` + `row_number()`
- 11-2 トップN per group … 同じ型で `<= 3`
- 11-3 欠損値処理 … `coalesce()`（0 / 平均）
- 11-4 時系列リサンプル … `date_trunc()` + `GROUP BY ALL`
- 11-5 分布の把握 … `percentile_disc([...]) WITHIN GROUP`
- 11-6 複数ファイル横断 … glob `**` + `hive_partitioning`
- 11-7 カテゴリ別ピボット … `PIVOT`

すべて DuckDB 1.5.3 で実機実行し、本書掲載の出力ボックスと一致を確認済み。

## ランタイム成果物

`data/trips.parquet` と `data/logs/` は regenerate.py で再生成できる。
