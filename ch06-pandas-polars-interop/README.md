# ch06 Pandas・Polars との相互運用

`data/` に ch05 と同じ NYC タクシー風 Parquet（30 日分）と支払い種別マスタ
`payment_types.csv` を置いています。本章は Python から DuckDB を呼び、
Pandas / Polars と相互にデータを受け渡します。

依存（リポジトリ root の `requirements.txt`）:

- `duckdb>=1.5`
- `pandas>=2.0`
- `polars>=1.0`
- `pyarrow`（Polars 連携・`pd.read_parquet` に必要）

```bash
cd ch06-pandas-polars-interop
python examples/to_pandas.py       # DuckDB の結果を .df() で Pandas に
python examples/sql_on_pandas.py   # Pandas DataFrame を SQL で直接クエリ
python examples/polars_interop.py  # .pl() と Polars DataFrame の直接クエリ
```
