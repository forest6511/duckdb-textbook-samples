-- 第8章 全文検索（fts）。永続データベースが必要
-- 実行: duckdb articles.db < examples/fts.sql
--   インメモリ（引数なしの duckdb）では create_fts_index が動かない

INSTALL fts; LOAD fts;

CREATE TABLE articles (id INTEGER, body VARCHAR);
INSERT INTO articles VALUES
    (1, 'DuckDB is a fast in-process analytical database'),
    (2, 'Pandas is a Python data analysis library'),
    (3, 'DuckDB can query Parquet files directly');

-- body 列に全文検索インデックスを作る
PRAGMA create_fts_index('articles', 'id', 'body');

-- BM25 スコア順に検索する
SELECT id, body
FROM (
    SELECT *, fts_main_articles.match_bm25(id, 'duckdb parquet') AS score
    FROM articles
) sq
WHERE score IS NOT NULL
ORDER BY score DESC;
