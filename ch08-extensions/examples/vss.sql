-- 第8章 ベクトル類似検索（vss）。array_distance はインメモリで動作
-- 実行: duckdb < examples/vss.sql
--   HNSW インデックスの永続化は実験的なため、ここでは距離計算のみ

INSTALL vss; LOAD vss;

CREATE TABLE docs (id INTEGER, embedding FLOAT[3]);
INSERT INTO docs VALUES
    (1, [1.0, 2.0, 3.0]),
    (2, [9.0, 8.0, 7.0]),
    (3, [1.1, 2.1, 2.9]);

-- 基準ベクトルとの距離が近い順に上位 2 件を取り出す
SELECT id,
       round(array_distance(embedding, [1.0, 2.0, 3.0]::FLOAT[3]), 3) AS dist
FROM docs
ORDER BY dist
LIMIT 2;
