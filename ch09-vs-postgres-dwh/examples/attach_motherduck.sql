-- 第9章: ローカル DuckDB から MotherDuck へ地続きでスケール（md コア拡張）
-- ※実行には MotherDuck アカウントが必要です。構文サンプルとして配置しています。

INSTALL md;
LOAD md;

-- MotherDuck（DuckDB ベースのクラウドDWH）へ接続
ATTACH 'md:';
