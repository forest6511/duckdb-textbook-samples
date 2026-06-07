# 第5章 一歩進んだSQL（CTE・ウィンドウ関数・PIVOT）

集計の一歩先へ進む章です。共通テーブル式（CTE）でクエリを段階的に分解し、ウィンドウ関数で移動平均・前日比・順位を求め、`QUALIFY` と `PIVOT` で実務的な集計を書きます。

## サンプルデータ

- `data/yellow_tripdata_sample.parquet` — NYC タクシー風 Parquet（30 日分）。ウィンドウ関数（移動平均・前日比・順位）が意味を持つよう、曜日に応じて件数が変動するデータにしています（週末を多めに）
- `data/payment_types.csv` — 支払い種別マスタ（PIVOT で使用）

`regenerate.py` で決定論的に再生成でき、何度実行しても同じ結果になります。

## 実行方法

```bash
cd ch05-advanced-sql

duckdb < examples/cte.sql       # CTE でクエリを段階分解
duckdb < examples/window.sql    # row_number / rank / lag / 移動平均
duckdb < examples/qualify.sql   # QUALIFY で各週の最も繁忙な日を抽出
duckdb < examples/pivot.sql     # PIVOT で支払方法 × 週の件数を横持ちに
```

データを再生成する場合:

```bash
python regenerate.py
```

## 各ファイルの内容

- `examples/cte.sql` — `WITH` 句で中間結果に名前を付け、ネストしたサブクエリを読みやすく分解します
- `examples/window.sql` — `OVER` 句で `row_number()` / `rank()` / `dense_rank()` の同点時の違い、`lag()` での前日比、移動平均を求めます
- `examples/qualify.sql` — ウィンドウ関数の結果で行を絞り込む `QUALIFY` を使い、CTE で書くより簡潔に「各週の最繁日」を取り出します
- `examples/pivot.sql` — `PIVOT` で行持ちのデータを列持ちに変換します（列名は「値_集計名」の形で自動生成されます）
