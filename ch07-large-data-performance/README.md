# 第7章 大規模データとパフォーマンス

DuckDB CLI 1.5.3 で検証。

## 実行方法

```bash
cd data
duckdb < ../examples/tuning.sql
duckdb < ../examples/explain.sql
```

## 内容

- `examples/tuning.sql` ― `memory_limit` / `threads` / `temp_directory` / `preserve_insertion_order` の確認と変更
- `examples/explain.sql` ― `EXPLAIN` / `EXPLAIN ANALYZE` で実行計画を読む

## データ

- `data/yellow_tripdata_sample.parquet` ― NYC タクシー乗車記録のサンプル（8,560 行 / 6 列。ch03-06 と同じファイル）

## 注意

- `current_setting('memory_limit')` / `threads` の出力は実行環境（RAM・コア数）で変わります
- `EXPLAIN ANALYZE` の `Total Time` や各オペレータの秒数は実行環境で変わります。本書では絶対値ではなく、相対的な重さとカーディナリティのずれの読み方を扱います
- `EXPLAIN` の `PARQUET_SCAN` に `Projections`（列のプルーニング）と `Filters`（述語プッシュダウン）が現れることを確認できます
