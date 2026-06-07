-- 第9章: PostgreSQL を分析のときだけ読む（postgres コア拡張）
-- ※実行には稼働中の PostgreSQL サーバが必要です。構文サンプルとして配置しています。

INSTALL postgres;
LOAD postgres;

-- 業務DBを読み取り専用でアタッチ（誤って書き換えないため READ_ONLY）
ATTACH 'dbname=shop user=analyst host=127.0.0.1' AS pg
    (TYPE postgres, READ_ONLY);

-- ネイティブテーブルと同じように pg.スキーマ.テーブル で参照
SELECT count(*) FROM pg.public.orders;

-- 業務DB（PostgreSQL）と手元の Parquet をその場で結合
SELECT
    o.payment_type,
    sum(t.fare_amount) AS total_fare
FROM 'trips.parquet' AS t
JOIN pg.public.orders AS o USING (order_id)
GROUP BY ALL;

-- スキーマが外部で変わったらキャッシュを更新
CALL pg_clear_cache();
