# 第6章 Pandas・Polars との相互運用

Python から DuckDB を呼び、Pandas / Polars と双方向にデータを受け渡す章です。「Pandas から抜けられない」「メモリに乗り切らない」という悩みに、「DuckDB で絞ってから Pandas へ渡す」という答えを示します。

## サンプルデータ

- `data/yellow_tripdata_sample.parquet` — 第5章と同じ NYC タクシー風 Parquet（30 日分）
- `data/payment_types.csv` — 支払い種別マスタ

## 依存ライブラリ

この章は Python を使うため、リポジトリ root の `requirements.txt` を仮想環境に入れてください。

```bash
# リポジトリ root で
python -m venv .venv
.venv/bin/pip install -r requirements.txt
```

主な依存（本書の検証バージョン）:

- `duckdb>=1.5`（1.5.3）
- `pandas>=2.0`（3.0.3）
- `polars>=1.0`（1.41.2）
- `pyarrow`（24.0.0、Polars 連携と `pd.read_parquet` に必要）

## 実行方法

```bash
cd ch06-pandas-polars-interop

python examples/to_pandas.py       # DuckDB の結果を .df() で Pandas DataFrame に
python examples/sql_on_pandas.py   # Pandas DataFrame を SQL で直接クエリ
python examples/polars_interop.py  # .pl() で Polars に・Polars DataFrame を直接クエリ
```

## 各ファイルの内容

- `examples/to_pandas.py` — DuckDB で集計した結果を `.df()` で Pandas DataFrame に変換します
- `examples/sql_on_pandas.py` — メモリ上の Pandas DataFrame を、変数名そのままで SQL の `FROM` に書いてクエリします（replacement scan）
- `examples/polars_interop.py` — `.pl()` で Polars DataFrame に変換し、Polars DataFrame を SQL で直接クエリします。Arrow を介したゼロコピーの受け渡しも示します
