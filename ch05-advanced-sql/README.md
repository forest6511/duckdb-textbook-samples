# ch05 一歩進んだSQL（CTE・ウィンドウ関数・PIVOT）

`data/` に NYC タクシー風 Parquet（30 日分）と支払い種別マスタ
`payment_types.csv` を置いています。本章はウィンドウ関数（移動平均・前日比・
順位）を扱うため、曜日に応じて件数が変動するデータにしています（週末を多め）。
`regenerate.py` で決定論的に再生成でき、何度実行しても同じ結果になります。

```bash
cd ch05-advanced-sql
duckdb < examples/cte.sql       # CTE で段階分解
duckdb < examples/window.sql    # row_number/rank/lag/移動平均
duckdb < examples/qualify.sql   # QUALIFY で各週の最繁日
duckdb < examples/pivot.sql     # PIVOT で支払方法 × 週の件数
```

データを再生成する場合:

```bash
python regenerate.py
```
