-- 第5章 PIVOT: 支払方法 × 週 の件数マトリクス
PIVOT (
  SELECT p.name AS payment, week(t.tpep_pickup_datetime) AS wk
  FROM 'data/yellow_tripdata_sample.parquet' t
  JOIN 'data/payment_types.csv' p USING (payment_type)
)
ON wk
USING count(*)
GROUP BY payment;
