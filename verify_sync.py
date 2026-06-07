#!/usr/bin/env python3
"""companion の SQL を実機実行し、出力ボックスのデータ行が
本書本文 (.md) に存在するか照合する。全章ローカル SYNC 検証。

不一致 = 本文の出力ボックスが実機と食い違っている（捏造 or 古い）疑い。
"""
import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent
BOOK = Path(
    "/Users/hisaoyoshitome/Workspace/books-monorepo/packages/duckdb-textbook/chapters"
)

# 章ディレクトリ -> (本文 md, 実行する sql のリスト, 事前再生成するか, 永続DB必要か)
CHAPTERS = {
    "ch03-query-files": ("03_query_files_directly.md",
                         ["query_parquet.sql", "query_csv.sql"], True, None),
    "ch04-analytical-sql": ("04_analytical_sql.md",
                            ["aggregate.sql", "join.sql", "subquery.sql"],
                            False, None),
    "ch05-advanced-sql": ("05_advanced_sql.md",
                          ["cte.sql", "window.sql", "qualify.sql", "pivot.sql"],
                          True, None),
    "ch11-practical-recipes": ("11_practical_recipes.md",
                               ["recipes.sql"], True, None),
}

ANSI = re.compile(r"\x1b\[[0-9;]*m")
# box の縦罫線で囲まれたデータ行（│ ... │）。区切り行・ヘッダ罫は対象外。
BOX_ROW = re.compile(r"^│.*│$")

# companion にのみ存在し、本書には意図的に載せていないデモクエリの出力行。
# （本書は DESCRIBE から始める / read_csv の型指定例は別の例を採用、等）
# これらは「本文に無い＝正しい」ので照合対象から除外する。
COMPANION_ONLY = {
    # ch03 query_parquet.sql 冒頭の SELECT VendorID ... LIMIT 3（本書は DESCRIBE で開く）
    "│ VendorID │ trip_distance │  fare_amount  │",
    "│  int64   │ decimal(23,2) │ decimal(23,2) │",
    "│        1 │          0.50 │          4.00 │",
    "│        2 │          0.63 │          4.55 │",
    "│        3 │          0.76 │          5.10 │",
    # ch03 query_csv.sql 2本目 read_csv(columns=...INTEGER) の int32 型行
    # （本書は types={'sales':'DOUBLE'} の別例を採用）
    "│ varchar │ int32 │ int32 │",
}


def strip(s: str) -> str:
    return ANSI.sub("", s)


def normalize(line: str) -> str:
    # 末尾空白を畳んで比較（box 幅は md と一致する想定だが、念のため右トリム）
    return line.rstrip()


def data_rows(output: str) -> list[str]:
    rows = []
    for raw in output.splitlines():
        line = normalize(strip(raw))
        if BOX_ROW.match(line):
            # 罫線・区切りは除外（─ や型行・ヘッダも box 行だが、これらも本文に
            # 載るので照合対象に含める＝より厳しいチェック）
            rows.append(line)
    return rows


def run_sql(chdir: Path, sql: str) -> str:
    r = subprocess.run(
        ["duckdb"], stdin=open(chdir / "examples" / sql),
        cwd=chdir, capture_output=True, text=True,
    )
    return r.stdout + r.stderr


def regenerate(chdir: Path):
    if (chdir / "regenerate.py").exists():
        subprocess.run([str(REPO / ".venv/bin/python"), "regenerate.py"],
                       cwd=chdir, capture_output=True, text=True)


def main():
    total_rows = 0
    total_miss = 0
    miss_detail = []
    for ch, (md, sqls, regen, _) in CHAPTERS.items():
        chdir = REPO / ch
        book_text = (BOOK / md).read_text(encoding="utf-8")
        book_lines = {normalize(l) for l in book_text.splitlines()}
        if regen:
            regenerate(chdir)
        ch_rows = 0
        ch_miss = 0
        for sql in sqls:
            out = run_sql(chdir, sql)
            for row in data_rows(out):
                if row in COMPANION_ONLY:
                    continue
                ch_rows += 1
                if row not in book_lines:
                    ch_miss += 1
                    miss_detail.append(f"  [{ch}/{sql}] NOT IN BOOK: {row}")
        total_rows += ch_rows
        total_miss += ch_miss
        status = "OK" if ch_miss == 0 else f"MISS {ch_miss}/{ch_rows}"
        print(f"{ch:28s} rows={ch_rows:4d}  {status}")
    print(f"\n--- 合計: {total_rows} 行中 {total_miss} 行が本文に未検出 ---")
    if miss_detail:
        print("\n".join(miss_detail[:60]))
        return 1
    print("全章 SYNC OK: 実機出力ボックスの全行が本文に存在")
    return 0


if __name__ == "__main__":
    sys.exit(main())
