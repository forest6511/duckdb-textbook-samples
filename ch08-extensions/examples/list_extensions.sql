-- 第8章 利用可能な拡張の確認
-- 実行: duckdb < examples/list_extensions.sql

SELECT extension_name, loaded, installed
FROM duckdb_extensions()
WHERE extension_name IN ('httpfs', 'json', 'fts', 'vss');
