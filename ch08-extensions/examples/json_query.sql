-- 第8章 JSON 型とフィールド抽出（インメモリで動作）
-- 実行: duckdb < examples/json_query.sql

CREATE TABLE ex (j JSON);
INSERT INTO ex VALUES
    ('{"family": "anatidae", "species": ["duck", "goose"]}');

-- ->> は文字列で、-> は JSON のまま返す。JSON のインデックスは 0 始まり
SELECT j ->> '$.family'                       AS family,
       json_extract_string(j, '$.species[0]') AS first_species
FROM ex;
