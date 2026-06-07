# 第8章 拡張エコシステム

DuckDB の機能を必要なときだけ足せる「拡張」を扱う章です。JSON の操作、全文検索（FTS）、ベクトル類似検索（VSS）、外部ファイルアクセス（httpfs）を、それぞれ最小の例で確認します。

## 実行方法

```bash
cd ch08-extensions/examples

duckdb < list_extensions.sql      # 拡張の状態を一覧表示
duckdb < json_query.sql           # JSON の操作（インメモリで実行可）
duckdb < vss.sql                  # ベクトル類似検索（インメモリで実行可）
duckdb articles.db < fts.sql      # 全文検索（永続データベースが必要）
duckdb < httpfs.sql               # httpfs のロードのみ（リモート取得はコメント）
```

## 各ファイルの内容

- `examples/list_extensions.sql` — `duckdb_extensions()` で、どの拡張が組み込み済みか・要インストールかを一覧表示します
- `examples/json_query.sql` — `->` / `->>` 演算子や `json_extract_string()` で JSON を操作します
- `examples/vss.sql` — `FLOAT[N]` 列に対し `array_distance()` / `array_cosine_distance()` でベクトル間の距離を求めます
- `examples/fts.sql` — `create_fts_index` で全文検索インデックスを作り、`match_bm25()` でスコア順に検索します
- `examples/httpfs.sql` — httpfs 拡張をロードします。S3 / HTTP 取得の構文はコメントで示します

## 注意

- **fts は永続データベースが必要**です。`duckdb`（インメモリ）+ `<` で実行するとテーブルが見つからないエラーになります。`duckdb articles.db < fts.sql` のようにファイルを指定してください
- **httpfs のリモート取得**（HTTP / S3）は、ネットワークと S3 資格情報に依存するため、出力を再現できません。`httpfs.sql` では構文をコメントで示し、ロードのみ実行します
- **vss の HNSW インデックスの永続化**は実験的機能です。`vss.sql` では距離計算（`array_distance()` など）のみ実行します
- JSON サポートはビルトインで、追加インストールは不要です
