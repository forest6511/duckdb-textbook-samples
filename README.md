# duckdb-textbook-samples

「**DuckDBの教科書 — ローカルで完結する高速データ分析：SQLからParquet・Python連携まで**」（森川 陽介 著）のサンプルコード集です。

本書で使う SQL・Python コードと、その実行に必要なサンプルデータを、そのまま動かせる形で収録しています。本書の出力例（DuckDB CLI のボックス表示や Pandas / Polars の表示）は、すべてここに収録したコードを **DuckDB 1.5.3 で実機実行した結果**です。手元で同じ結果を再現できます。

> Kindle 版のリンクは出版後に追記します。

## 本書のねらいとこのリポジトリの位置づけ

本書は、Pandas でのデータ分析にメモリ溢れや遅さを感じ始めた方に向けて、DuckDB（インストール不要・サーバー不要の列指向データベース）で「データウェアハウスの速い集計だけを、ローカルで・無料で」手に入れる方法を解説します。このリポジトリは、その本文に登場するクエリとコードを章ごとに整理したものです。

本文を読みながら手を動かすときは、対応する章のディレクトリに移って実行してください。各ディレクトリの `README.md` に、何を実行し、どんな結果になるかを書いています。

## 構成

本書は全 11 章ですが、第 1 章（概念）と第 2 章（インストール）はコードを動かす章ではないため、サンプルは第 3 章以降を収録しています。

- [第3章 ファイルを直接クエリする](ch03-query-files/README.md) — CSV・Parquet・JSON を `FROM` に書くだけで読む
- [第4章 分析SQL実践](ch04-analytical-sql/README.md) — 集計・結合・サブクエリ
- [第5章 一歩進んだSQL](ch05-advanced-sql/README.md) — CTE・ウィンドウ関数・QUALIFY・PIVOT
- [第6章 Pandas・Polars との相互運用](ch06-pandas-polars-interop/README.md) — `.df()` / `.pl()` でデータフレームと往復する
- [第7章 大規模データとパフォーマンス](ch07-large-data-performance/README.md) — `memory_limit` / `threads` / `EXPLAIN`
- [第8章 拡張エコシステム](ch08-extensions/README.md) — JSON・全文検索・ベクトル類似検索・httpfs
- [第9章 PostgreSQL・クラウドDWH との使い分け](ch09-vs-postgres-dwh/README.md) — 判断軸と連携の構文サンプル
- [第10章 軽量データパイプラインを組む](ch10-data-pipeline/README.md) — ファイル直クエリ → CTAS → COPY の ETL
- [第11章 実務レシピ集](ch11-practical-recipes/README.md) — そのまま使える分析パターン 7 種

各章のディレクトリには、おおむね次が含まれます。

- `examples/` — 本文に対応する SQL / Python ファイル（単独で動作）
- `data/` — クエリ対象のサンプルデータ（再現性のため同梱、または `regenerate.py` で生成）
- `regenerate.py` — サンプルデータを決定論的に再生成するスクリプト（一部の章のみ）
- `README.md` — その章の実行方法・データの説明・注意点

## 動かし方

DuckDB CLI 1.5 系を推奨します（本書は **1.5.3** で検証）。インストールは [DuckDB 公式サイト](https://duckdb.org/docs/installation/) を参照してください。

```bash
git clone https://github.com/forest6511/duckdb-textbook-samples.git
cd duckdb-textbook-samples

cd ch03-query-files
duckdb < examples/query_parquet.sql
```

第 6 章（Pandas・Polars 連携）と一部のサンプルは Python を使います。その場合は仮想環境に依存ライブラリを入れてください。

```bash
python -m venv .venv
.venv/bin/pip install -r requirements.txt
```

`requirements.txt` の主な依存は次のとおりです（本書の検証バージョンを括弧で示します）。

- `duckdb>=1.5`（1.5.3）
- `pandas>=2.0`（3.0.3）
- `polars>=1.0`（1.41.2）
- `pyarrow`（24.0.0、Polars・Arrow 連携に必要）

## サンプルデータについて

本書の主役データは、ニューヨーク市のタクシー乗車記録を模した **決定論的なサンプル**です。乱数を使わず、件数や値が毎回同じになるように生成しているため、本文の出力例と一致します。実データ（数 GB）ではなく小さなサンプルにしているのは、外部ダウンロードなしで誰でもすぐ動かせるようにするためです。

`regenerate.py` を持つ章では、`python regenerate.py`（または `../.venv/bin/python regenerate.py`）でサンプルデータをいつでも再生成できます。生成物（`*.parquet` など）と実行時の成果物（`*.db` / `output/`）は、章によっては `.gitignore` 済みです。

## 出力の再現性について

本書の出力例は DuckDB 1.5.3 の実行結果です。ただし、次のものは実行環境によって変わります。本文でもその旨を明記しています。

- `memory_limit` / `threads` の既定値 — マシンの RAM・コア数で変わります（第7章）
- `EXPLAIN ANALYZE` の実行時間 — 実行ごとに変わります。本書は秒の絶対値ではなく、計画の読み方を扱います（第7章）
- 第9章の PostgreSQL / MotherDuck 連携 — 外部サービスが必要なため、構文サンプルのみで実行結果は載せていません

## ライセンス

このリポジトリのコードは MIT ライセンスです。サンプルデータは本書の学習用に生成・加工したものです。
