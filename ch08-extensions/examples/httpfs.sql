-- 第8章 httpfs（HTTP / S3）。構文のみ。実行はネットワーク・資格情報に依存
-- 本書ではリモート取得の出力は実演しない（再現できないため）

INSTALL httpfs; LOAD httpfs;

-- HTTP(S) 上の Parquet を直接クエリ（読み取り専用）
-- SELECT count(*) FROM read_parquet('https://example.com/data/trips.parquet');

-- S3 の資格情報を登録（モダンな CREATE SECRET 構文）
-- CREATE SECRET (
--     TYPE S3, KEY_ID 'your-access-key', SECRET 'your-secret-key', REGION 'us-east-1'
-- );

-- 登録後は s3:// で直接読める
-- SELECT payment_type, count(*) FROM read_parquet('s3://my-bucket/trips/*.parquet')
-- GROUP BY payment_type;

SELECT 'httpfs loaded' AS status;
