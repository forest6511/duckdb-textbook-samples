-- 支払い種別マスタとの結合（コード→名称のルックアップ）
SELECT p.name AS payment, count(*) AS trips
FROM 'data/yellow_tripdata_sample.parquet' t
JOIN 'data/payment_types.csv' p USING (payment_type)
GROUP BY p.name
ORDER BY trips DESC;
