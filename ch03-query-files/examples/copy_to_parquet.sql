-- CSV を読んで Parquet に固める（パイプラインの基本形）
COPY (
  SELECT city, year, sales FROM 'data/sales.csv'
) TO 'data/sales.parquet' (FORMAT parquet, COMPRESSION zstd);
