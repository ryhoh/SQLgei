--------------------
-- Table Definition
--------------------

CREATE TABLE Foods (
	name VARCHAR(64),
	store VARCHAR(32),
	yen INT,
	PRIMARY KEY(name, store)
);

CREATE TABLE Digits (
    digit INT PRIMARY KEY
);

CREATE TABLE U8Seq (
    seq INT PRIMARY KEY
);

CREATE TABLE U16Seq (
    seq INT PRIMARY KEY
);

CREATE TABLE I8Seq (
    seq INT PRIMARY KEY
);

CREATE TABLE I16Seq (
    seq INT PRIMARY KEY
);

--------------------
-- Data Insertion
--------------------

INSERT INTO Foods VALUES
    ('牛めし', '松屋', 320),
    ('ネギたっぷり旨辛ネギたま牛めし', '松屋', 430),
    ('おろしポン酢牛めし', '松屋', 420);

INSERT INTO Digits VALUES
    (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);

INSERT INTO U8Seq
    SELECT D1.digit + (D2.digit * 10) + (D3.digit * 100) AS seq
    FROM Digits AS D1
    CROSS JOIN Digits AS D2
    CROSS JOIN Digits AS D3
	WHERE D1.digit + (D2.digit * 10) + (D3.digit * 100) < 256
    ORDER BY seq;

INSERT INTO U16Seq
    SELECT D1.digit + (D2.digit * 10) + (D3.digit * 100) + (D4.digit * 1000) + (D5.digit * 10000) AS seq
    FROM Digits AS D1
    CROSS JOIN Digits AS D2
    CROSS JOIN Digits AS D3
    CROSS JOIN Digits AS D4
    CROSS JOIN Digits AS D5
    WHERE D1.digit + (D2.digit * 10) + (D3.digit * 100) + (D4.digit * 1000) + (D5.digit * 10000) < 65536
    ORDER BY seq;

INSERT INTO I8Seq
    SELECT seq - 128
    FROM U8Seq;

INSERT INTO I16Seq
    SELECT seq - 32768
    FROM U16Seq;
