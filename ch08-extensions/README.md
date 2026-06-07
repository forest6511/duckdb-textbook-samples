# 第8章 拡張エコシステム

DuckDB CLI 1.5.3 で検証。

## 実行方法

```bash
cd examples
duckdb < list_extensions.sql      # 拡張の状態確認
duckdb < json_query.sql           # JSON（インメモリ可）
duckdb < vss.sql                  # ベクトル類似検索（インメモリ可）
duckdb articles.db < fts.sql      # 全文検索（永続 DB が必要）
duckdb < httpfs.sql               # httpfs ロードのみ（リモート取得はコメントアウト）
```

## 注意

- **fts は永続データベースが必要**です。`duckdb`（インメモリ）+ `<` ではテーブルが見つからないエラーになります。`duckdb articles.db < fts.sql` のようにファイルを指定してください
- **httpfs のリモート取得**（HTTP/S3）は、ネットワークと S3 資格情報に依存するため出力を再現できません。`httpfs.sql` では構文をコメントで示し、ロードのみ実行します
- **vss の HNSW 永続化**は実験的機能です。`vss.sql` では距離計算（`array_distance`）のみ実行します
- JSON サポートはビルトインで、追加インストール不要です
