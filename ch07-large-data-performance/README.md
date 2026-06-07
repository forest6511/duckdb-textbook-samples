# 第7章 大規模データとパフォーマンス

DuckDB が大きなデータをどう扱い、なぜ速いのかを確認する章です。メモリやスレッドの設定を見て・変え、`EXPLAIN` と `EXPLAIN ANALYZE` で実行計画を読みます。

## サンプルデータ

- `data/yellow_tripdata_sample.parquet` — NYC タクシーの乗車記録サンプル（8,560 行・6 列。第3章から第6章と同じファイル）

## 実行方法

```bash
cd ch07-large-data-performance/data

duckdb < ../examples/tuning.sql    # メモリ・スレッド・一時ディレクトリの設定
duckdb < ../examples/explain.sql   # 実行計画を読む
```

## 各ファイルの内容

- `examples/tuning.sql` — `memory_limit` / `threads` / `temp_directory` / `preserve_insertion_order` の現在値を確認し、変更します
- `examples/explain.sql` — `EXPLAIN` で計画の形を、`EXPLAIN ANALYZE` で各オペレータの実測を読みます

## 注意

出力の一部は実行環境によって変わります。本書でもその旨を明記しています。

- `memory_limit` / `threads` の既定値は、マシンの RAM とコア数で変わります（既定はそれぞれ RAM の 80%、コア数）
- `EXPLAIN ANALYZE` の `Total Time` や各オペレータの秒数は、実行ごとに変わります。本書では秒の絶対値ではなく、相対的な重さと、推定カーディナリティと実測のずれの読み方を扱います
- `EXPLAIN` の `PARQUET_SCAN` に `Projections`（列のプルーニング）と `Filters`（述語プッシュダウン）が現れます。DuckDB が必要な列・必要な行だけを読んでいることを確認できます
