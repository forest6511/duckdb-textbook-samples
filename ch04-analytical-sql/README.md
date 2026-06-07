# 第4章 分析SQL実践（集計・結合・サブクエリ）

データ分析でいちばんよく使う SQL を実践する章です。`GROUP BY` での集計、マスタとの `JOIN`、サブクエリを、NYC タクシーのサンプルデータで動かします。`GROUP BY ALL` や `FILTER` といった、DuckDB ならではの書きやすい構文も扱います。

## サンプルデータ

- `data/yellow_tripdata_sample.parquet` — 第3章と同じ NYC タクシー風 Parquet（10,000 行）
- `data/payment_types.csv` — 支払い種別のマスタ。`JOIN` の右側に使います（種別名は本書サンプル独自の定義です）

## 実行方法

```bash
cd ch04-analytical-sql

duckdb < examples/aggregate.sql   # 集計・GROUP BY ALL・FILTER
duckdb < examples/join.sql        # 支払い種別マスタとの JOIN
duckdb < examples/subquery.sql    # スカラ・派生テーブルサブクエリ
```

## 各ファイルの内容

- `examples/aggregate.sql` — `count()` / `avg()` などの集計関数、`GROUP BY ALL`、`FILTER` 句、`WHERE` と `HAVING` の使い分けを示します
- `examples/join.sql` — `payment_type` を支払い種別マスタと `JOIN USING` で結合し、コードを人が読める名称に置き換えます
- `examples/subquery.sql` — スカラサブクエリ（全体平均との比較）と派生テーブル（サブクエリを `FROM` に置く）の 2 つの形を扱います
