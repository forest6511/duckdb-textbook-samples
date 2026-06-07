# 第9章 PostgreSQL・クラウドDWH との使い分けと連携

この章は「DuckDB で足りるのか / いつクラウドDWHに移るのか」の **判断軸** が主眼です。

連携先（PostgreSQL / MotherDuck）は外部サービスを必要とするため、ここに置く SQL は
**実行可能サンプルではなく構文サンプル** です。構文の正しさは DuckDB 公式ドキュメントで
担保しています。

- `examples/attach_postgres.sql` — 稼働中の PostgreSQL サーバが必要
- `examples/attach_motherduck.sql` — MotherDuck アカウントが必要

BigQuery / Snowflake への接続手順は、コミュニティ拡張でバージョンが安定しないため
本書では扱いません（乗り換えの「判断軸」だけを本文で解説しています）。
