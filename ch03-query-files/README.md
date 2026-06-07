# 第3章 ファイルを直接クエリする

CSV・Parquet・JSON を、いったんテーブルに読み込まずに `FROM` へ直接書いてクエリする章です。「ロードしてから集計する」という手順を踏まずに、ファイルをそのままデータベースのテーブルのように扱えることを体験します。

## サンプルデータ

- `data/yellow_tripdata_sample.parquet` — NYC タクシーの乗車記録を模した決定論サンプル（10,000 行・6 列）
- `data/sales.csv` — CSV 直接クエリ用の小さなサンプル（4 行）

どちらも `regenerate.py` で再生成できます（DuckDB 本体だけで生成し、外部ダウンロードは不要です）。

## 実行方法

DuckDB CLI 1.5 系で実行します。

```bash
cd ch03-query-files

duckdb < examples/query_csv.sql        # CSV を直接クエリ・read_csv で型指定
duckdb < examples/query_parquet.sql    # Parquet を直接クエリ・スキーマ確認
duckdb < examples/copy_to_parquet.sql  # クエリ結果を COPY で Parquet 化
```

データを再生成する場合:

```bash
python regenerate.py
```

## 各ファイルの内容

- `examples/query_csv.sql` — `FROM 'sales.csv'` で CSV を直接読みます。CSV sniffer による型の自動推測と、`read_csv()` での明示的な型指定を示します
- `examples/query_parquet.sql` — Parquet を直接読み、`FROM (DESCRIBE SELECT * FROM 'file')` でスキーマを一覧表示します。件数・平均運賃の集計と、`parquet_file_metadata()` でのメタデータ確認も行います
- `examples/copy_to_parquet.sql` — `COPY ... TO ... (FORMAT parquet)` でクエリ結果を Parquet に書き出します

## 補足

- 本書本文の `DESCRIBE` の出力（クリーンな 6 列ボックス）は、`FROM (DESCRIBE ...)` の形で得ています。`DESCRIBE` を単独で実行すると、CLI のバージョンによっては色付きのサマリー表示になり、誌面に貼りにくいためです
- 出力に出てくる集計値（平均運賃など）は、このサンプルデータでの値です。別のデータで試せば当然変わります。注目すべきはクエリの形です
