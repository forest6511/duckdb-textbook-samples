# ch03 ファイルを直接クエリする

`data/` に小さな再現用サンプルを置いています。

- `yellow_tripdata_sample.parquet` — NYC タクシー風の決定論サンプル（10,000 行）
- `sales.csv` — 小さな CSV サンプル

## 実行

DuckDB CLI（v1.5 系）で:

```bash
cd ch03-query-files
duckdb -c "SELECT * FROM 'data/sales.csv';"
duckdb < examples/query_parquet.sql
```

サンプルデータは `regenerate.py` で再生成できます（DuckDB 本体のみで生成、外部ダウンロード不要）。
