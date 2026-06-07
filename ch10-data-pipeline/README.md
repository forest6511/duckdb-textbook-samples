# 第10章 軽量データパイプラインを組む

ここまで学んだ道具を組み合わせて、軽量な ETL（extract → transform → load）を組む章です。ファイルを直接クエリして読み（extract）、CTAS で整形し（transform）、`COPY` で書き出す（load）という流れを、SQL 版と Python 版の両方で示します。

## サンプルデータ

- `data/trips.parquet` — NYC タクシー風 Parquet（第7章と同じ入力ファイル）

## 実行方法

```bash
cd ch10-data-pipeline

duckdb pipeline.db < examples/pipeline.sql   # SQL でパイプラインを実行
python examples/pipeline.py                  # 同じ流れを Python で実行
```

どちらも `CREATE OR REPLACE TABLE` を使っているため冪等で、何度流しても同じ結果になります。成果物は `output/daily_fare.parquet` に書き出されます。

## 各ファイルの内容

- `examples/pipeline.sql` — ファイル直クエリ → CTAS（`CREATE TABLE AS SELECT`）で整形 → `COPY ... TO` で Parquet / CSV に書き出すまでを SQL だけで組みます。`PARTITION_BY` での分割書き出しも示します
- `examples/pipeline.py` — 同じ流れを `duckdb.connect('pipeline.db')` で永続データベースに対して実行します

## 注意

- `duckdb.connect()` に引数を渡さない（インメモリの）場合、テーブルは接続を閉じると消えます。永続化したいときはファイル名を渡します
- 実行時に生成される `pipeline.db` と `output/` は `.gitignore` 済みです。`regenerate` 不要で、上記コマンドを流せば再生成されます
