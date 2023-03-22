--------------------
-- Data Insertion
--------------------
INSERT INTO digits VALUES
       (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

INSERT INTO u8
       SELECT D1.digit + (D2.digit * 10) + (D3.digit * 100) AS val
         FROM digits AS D1
        CROSS JOIN digits AS D2
        CROSS JOIN digits AS D3
	 WHERE D1.digit + (D2.digit * 10) + (D3.digit * 100) < 256
        ORDER BY val;

INSERT INTO u16
       SELECT D1.digit + (D2.digit * 10) + (D3.digit * 100) + (D4.digit * 1000) + (D5.digit * 10000) AS val
         FROM digits AS D1
        CROSS JOIN digits AS D2
        CROSS JOIN digits AS D3
        CROSS JOIN digits AS D4
        CROSS JOIN digits AS D5
        WHERE D1.digit + (D2.digit * 10) + (D3.digit * 100) + (D4.digit * 1000) + (D5.digit * 10000) < 65536
        ORDER BY val;

INSERT INTO i8
       SELECT val - 128
         FROM u8;

INSERT INTO i16
       SELECT val - 32768
         FROM u16;

INSERT INTO bot_detail (title, contents) VALUES
       ('データベース', (SELECT concat(split_part(version(), ' ', 1), ' ', split_part(version(), ' ', 2)))),
       ('説明', 'hashtag SQL芸 を付けてSQL文を投稿すると、SQLを実行できます。'),
       ('リポジトリ', 'https://github.com/ryhoh/SQLgei'),
       ('テーブル一覧確認', 'SELECT * FROM tables'),
       ('カラム一覧確認', 'SELECT * FROM columns WHERE table_name = ''テーブル名''');

INSERT INTO dependencies (name, url, license_or_term) VALUES
       ('ekidata', 'https://ekidata.jp/', 'https://ekidata.jp/agreement.php'),
       ('inappropriate-words-ja', 'https://github.com/MosasoM/inappropriate-words-ja', 'MIT License');
