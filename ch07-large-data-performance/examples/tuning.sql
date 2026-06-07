-- 第7章 memory_limit / threads / temp_directory / preserve_insertion_order
-- 実行: duckdb < examples/tuning.sql （data/ ディレクトリで）

-- 現在の設定値を確認する（出力は環境依存）
SELECT current_setting('memory_limit') AS memory_limit,
       current_setting('threads')      AS threads;

-- メモリ上限とスレッド数を変更する
SET memory_limit = '10GB';  -- メモリ上限を 10GB に絞る
SET threads = 4;            -- 並列スレッドを 4 に制限する

-- スピル（ディスク退避）先を明示的に指定する
SET temp_directory = '/tmp/duckdb_spill.tmp/';

-- ORDER BY のない結果について、並び順の保持をやめてメモリを節約する
SET preserve_insertion_order = false;

-- 変更後の値を確認する
SELECT current_setting('memory_limit') AS memory_limit,
       current_setting('threads')      AS threads;
