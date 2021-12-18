--------------------
-- Table Definition
--------------------

CREATE TABLE stores (
       id SERIAL,
       name VARCHAR(32),

       PRIMARY KEY (id)
);

CREATE TABLE foods (
       id SERIAL,
       store_id INT,
       name VARCHAR(64),
       yen INT,

       PRIMARY KEY (id),
	UNIQUE (name, store_id),
       FOREIGN KEY (store_id) REFERENCES stores(id)
);

CREATE TABLE digits (
       digit INT PRIMARY KEY
);

CREATE TABLE u8seq (
       seq INT PRIMARY KEY
);

CREATE TABLE u16seq (
       seq INT PRIMARY KEY
);

CREATE TABLE i8seq (
       seq INT PRIMARY KEY
);

CREATE TABLE i16seq (
       seq INT PRIMARY KEY
);

--------------------
-- Data Insertion
--------------------

INSERT INTO stores (name)
VALUES
       ('松屋'),
       ('サイゼリヤ'),
       ('スターバックス');

INSERT INTO foods (store_id, name, yen)
VALUES
       (1, '牛めしミニ盛', 330),
       (1, '牛めし並盛', 380),
       (1, '牛めしあたま大盛', 480),
       (1, '牛めし大盛', 530),
       (1, '牛めし特盛', 650),
       (1, 'ネギたっぷり旨辛ネギたま牛めしミニ盛', 440),
       (1, 'ネギたっぷり旨辛ネギたま牛めし並盛', 490),
       (1, 'ネギたっぷり旨辛ネギたま牛めし大盛', 640),
       (1, 'ネギたっぷり旨辛ネギたま牛めし特盛', 760),
       (1, 'おろしポン酢牛めしミニ盛', 430),
       (1, 'おろしポン酢牛めし並盛', 480),
       (1, 'おろしポン酢牛めし大盛', 630),
       (1, 'おろしポン酢牛めし特盛', 750),
       (1, '創業ビーフカレー', 490),
       (1, '創業ビーフカレー彩り生野菜セット', 600),
       (1, '創業ビーフカレギュウ', 720),
       (1, '創業ハンバーグビーフカレー', 720),
       (1, 'キムカル丼', 500),
       (1, '厚切りネギ塩豚焼肉丼', 580),
       (1, 'アンガス牛焼ビビン丼', 580),
       (2, 'プチフォッカ', 150),
       (2, '柔らか青豆の温サラダ', 200),
       (2, 'ほうれん草のソテー', 200),
       (2, '辛味チキン', 300),
       (2, 'エスカルゴのオーブン焼き', 400),
       (2, 'ムール貝のガーリック焼き', 400),
       (2, 'マルゲリータピザ', 400),
       (2, 'たらこソースシリー風', 400),
       (2, 'ペペロンチーノ', 300),
       (2, 'ミラノ風ドリア', 300),
       (2, 'チーズたっぷりミラノ風ドリア', 400),
       (2, '半熟卵のミラノ風ドリア', 350),
       (3, 'ドリップコーヒー Short', 319),
       (3, 'ドリップコーヒー Tall', 363),
       (3, 'ドリップコーヒー Grande', 407),
       (3, 'ドリップコーヒー Venti', 451),
       (3, 'カフェミスト Short', 374),
       (3, 'カフェミスト Tall', 418),
       (3, 'カフェミスト Grande', 462),
       (3, 'カフェミスト Venti', 506),
       (3, 'カプチーノ Short', 374),
       (3, 'カプチーノ Tall', 418),
       (3, 'カプチーノ Grande', 462),
       (3, 'カプチーノ Venti', 506),
       (3, 'キャラメルマキアート Short', 429),
       (3, 'キャラメルマキアート Tall', 473),
       (3, 'キャラメルマキアート Grande', 517),
       (3, 'キャラメルマキアート Venti', 561);
       -- todo もっと品目を増やす

INSERT INTO digits VALUES
       (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

INSERT INTO u8seq
       SELECT D1.digit + (D2.digit * 10) + (D3.digit * 100) AS seq
         FROM digits AS D1
        CROSS JOIN digits AS D2
        CROSS JOIN digits AS D3
	 WHERE D1.digit + (D2.digit * 10) + (D3.digit * 100) < 256
        ORDER BY seq;

INSERT INTO u16seq
       SELECT D1.digit + (D2.digit * 10) + (D3.digit * 100) + (D4.digit * 1000) + (D5.digit * 10000) AS seq
         FROM digits AS D1
        CROSS JOIN digits AS D2
        CROSS JOIN digits AS D3
        CROSS JOIN digits AS D4
        CROSS JOIN digits AS D5
        WHERE D1.digit + (D2.digit * 10) + (D3.digit * 100) + (D4.digit * 1000) + (D5.digit * 10000) < 65536
        ORDER BY seq;

INSERT INTO i8seq
       SELECT seq - 128
         FROM u8seq;

INSERT INTO i16seq
       SELECT seq - 32768
         FROM u16seq;
