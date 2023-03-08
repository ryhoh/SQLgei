import unittest

from main import *


# 単体試験
class TestTable(unittest.TestCase):
    def test_from_select_stmt(self):
        # 通常ケース
        expected = Table(
            columns=['one', 'two'],
            records=[('1⃣', '2⃣')],
        )
        actual = Table.from_select_stmt("select '1⃣' as one, '2⃣' as two")
        self.assertEqual(expected, actual)

        # 複数文
        expected = Table(
            columns=['one', 'two'],
            records=[('1⃣', '2⃣')],
        )
        actual = Table.from_select_stmt("select '2⃣' as one, '1⃣' as two; select '1⃣' as one, '2⃣' as two")
        self.assertEqual(expected, actual)

        # 複数文で、途中にコメントを挟むケース
        expected = Table(
            columns=['one', 'two'],
            records=[('1⃣', '2⃣')],
        )
        actual = Table.from_select_stmt("""
        select '2⃣' as one, '1⃣' as two;  -- first  statement
        select '1⃣' as one, '2⃣' as two   -- second statement
        """)
        self.assertEqual(expected, actual)

        # テーブル作成からデータ挿入
        expected = Table(
            columns=[],
            records=[()],
        )
        actual = Table.from_select_stmt("""
create table primes(val int);
insert into primes values (2), (3), (5), (7), (11);
""")
        self.assertEqual(expected, actual)
        Table.from_select_stmt("drop table primes;")  # 次のテストに備え create したテーブルを捨てる

        # テーブル作成からデータ挿入、データ取得
        expected = Table(
            columns=['val'],
            records=[(2,), (3,), (5,), (7,), (11,)],
        )
        actual = Table.from_select_stmt("""
create table primes(val int);
insert into primes values (2), (3), (5), (7), (11);
select * from primes;
""")
        self.assertEqual(expected, actual)
        Table.from_select_stmt("drop table primes;")  # 次のテストに備え create したテーブルを捨てる

    def test_str(self):
        # 通常ケース
        expected = \
"""one | two
1⃣ | 2⃣
"""
        actual = str(
            Table(
                columns=['one', 'two'],
                records=[('1⃣', '2⃣')],
            )
        )
        self.assertEqual(expected, actual)

        # 空のケース
        expected = "\n\n"
        actual = str(
            Table(
                columns=[],
                records=[()],
            )
        )
        self.assertEqual(expected, actual)

    def test_twit_shorten_for_tweet(self):
        # 通常ケース
        expected = \
"""223 | 3 | ドリップ コーヒー Short | 319
224 | 3 | ドリップ コーヒー Tall | 363
225 | 3 | ドリップ コーヒー Grande | 407
226 | 3 | ドリップ コーヒー Venti® | 451
227 | 3 | カフェ ミスト Short | 374
228 | 3 | カフェ ミスト Tall | 418
229 | 3 | カフェ ミスト Grande | 462
...
"""
        actual = twit_shorten_for_tweet(
"""223 | 3 | ドリップ コーヒー Short | 319
224 | 3 | ドリップ コーヒー Tall | 363
225 | 3 | ドリップ コーヒー Grande | 407
226 | 3 | ドリップ コーヒー Venti® | 451
227 | 3 | カフェ ミスト Short | 374
228 | 3 | カフェ ミスト Tall | 418
229 | 3 | カフェ ミスト Grande | 462
230 | 3 | カフェ ミスト Venti® | 506
231 | 3 | コールドブリュー コーヒー Short | 363
232 | 3 | コールドブリュー コーヒー Tall | 407
233 | 3 | コールドブリュー コーヒー Grande | 451
234 | 3 | コールドブリュー コーヒー Venti® | 495
235 | 3 | トリプルエスプレッソ ラテ Tall | 495
""")
        self.assertEqual(expected, actual)

        # 何もないケース
        expected = ""
        actual = ""
        self.assertEqual(expected, actual)

        # 省略しないケース
        expected = \
"""one | two | a
1⃣ | 2⃣ | あ
"""
        actual = \
"""one | two | a
1⃣ | 2⃣ | あ
"""
        self.assertEqual(expected, actual)


class TestPreprocess(unittest.TestCase):
    # 前処理のテスト
    def test_preprocess(self):
        # 通常ケース
        expected = ""
        actual = db_preprocess("#SQL芸")
        self.assertEqual(expected, actual)

        # 通常ケース
        expected = "<>"
        actual = db_preprocess("&lt;&gt;")
        self.assertEqual(expected, actual)

        # 通常ケース
        expected = "test"
        actual = db_preprocess("\n test\n ")
        self.assertEqual(expected, actual)

        # 通常ケース
        expected = "test`"
        actual = db_preprocess("```test````")
        self.assertEqual(expected, actual)

        # 通常ケース
        expected = "test"
        actual = db_preprocess("`test`")
        self.assertEqual(expected, actual)


# 結合試験
class TestJoin(unittest.TestCase):
    # 実用的な入力ケース
    def test_db_run_select_stmt(self):
        expected = \
"""one | two | a
1⃣ | 2⃣ | あ
1⃣ | 2⃣ | あ
1⃣ | 2⃣ | あ
"""
        actual = db_run_select_stmt("""
        ```select '1⃣' as one, '2⃣' as two, 'あ' as a  -- サンプルデータを
        from u8  /* u8テーブルをダミーで使って */
        limit 3;  -- 3回出力する```""")
        self.assertEqual(expected, actual)

    # 画像出力との結合を見る
    def test_db_run_select_stmt_ret_img(self):
        expected = \
"""one | two | a
1⃣ | 2⃣ | あ
"""
        actual = db_run_select_stmt_ret_img("select '1⃣' as one, '2⃣' as two, 'あ' as a")
        self.assertEqual(expected, actual[0])
        # tmpディレクトリに画像が出力されていることを確認すること
        # 文字化けしていないことを確認すること


if __name__ == '__main__':
    unittest.main()

