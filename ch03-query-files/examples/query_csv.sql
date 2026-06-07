-- CSV を直接クエリする（ロード不要）
SELECT * FROM 'data/sales.csv';

-- read_csv で列名・型を明示する
SELECT * FROM read_csv('data/sales.csv',
    header = true,
    columns = {'city': 'VARCHAR', 'year': 'INTEGER', 'sales': 'INTEGER'});
