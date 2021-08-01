--------------------
-- Table Definition
--------------------

CREATE TABLE Food (
	name VARCHAR(64),
	store VARCHAR(32),
	yen INT,
	PRIMARY KEY(name, store)
);


--------------------
-- Data Insertion
--------------------

INSERT INTO Food VALUES
    ('牛めし', '松屋', 320),
    ('ネギたっぷり旨辛ネギたま牛めし', '松屋', 430),
    ('おろしポン酢牛めし', '松屋', 420);
