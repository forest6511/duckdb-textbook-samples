# 第9章 PostgreSQL・クラウドDWH との使い分けと連携

「DuckDB で足りるのか、いつ PostgreSQL やクラウドDWH に移るのか」という **判断軸** を扱う章です。OLAP（分析）と OLTP（日々の取引）の違い、単一ノード・単一ライターという乗り換えの境目を本文で解説します。

## このディレクトリのサンプルについて

連携先（PostgreSQL / MotherDuck）は外部サービスを必要とするため、ここに置く SQL は **そのまま実行できるサンプルではなく、構文サンプル**です。構文の正しさは DuckDB 公式ドキュメントで確認しています。

- `examples/attach_postgres.sql` — `ATTACH` で PostgreSQL に接続する構文（稼働中の PostgreSQL サーバが必要）
- `examples/attach_motherduck.sql` — `ATTACH 'md:'` で MotherDuck に接続する構文（MotherDuck アカウントが必要）

## 補足

- BigQuery / Snowflake への接続手順は、コミュニティ拡張でバージョンが安定しないため本書では扱いません。乗り換えの「判断軸」だけを本文で解説しています
- SQLite は本書の対象外です（DuckDB は「分析版の SQLite」という思想的ルーツに名前が出る程度です）
