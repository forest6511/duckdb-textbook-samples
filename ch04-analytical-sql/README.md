# ch04 分析SQL実践（集計・結合・サブクエリ）

`data/` に Ch03 と同じ NYC タクシー風 Parquet（10,000 行）と、支払い種別マスタ
`payment_types.csv` を置いています。`payment_type` の名称は本書サンプル独自の定義です。

```bash
cd ch04-analytical-sql
duckdb < examples/aggregate.sql
duckdb < examples/join.sql
duckdb < examples/subquery.sql
```
