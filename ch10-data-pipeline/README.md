# 第10章 軽量データパイプラインを組む

NYC タクシー風 Parquet を入力に、extract -> transform -> load の軽量ETLを組む例。

- `examples/pipeline.sql` — `duckdb pipeline.db < examples/pipeline.sql`
- `examples/pipeline.py` — `python examples/pipeline.py`

どちらも CREATE OR REPLACE TABLE で冪等（何度流しても同じ結果）。
成果物は `output/daily_fare.parquet`。
