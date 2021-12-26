--------------------
-- Table Definition
--------------------

CREATE TABLE nations (
       id SERIAL,
       official VARCHAR(32),
       name VARCHAR(32),

       PRIMARY KEY (id)
);

CREATE TABLE prefs (
       id SERIAL,
       name VARCHAR(16),

       PRIMARY KEY (id)
);

CREATE TABLE stores (
       id SERIAL,
       name VARCHAR(32),
       hq_pref_id INT,

       PRIMARY KEY (id),
       FOREIGN KEY (hq_pref_id) REFERENCES prefs(id)
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

CREATE TABLE os (
       id SERIAL,
       name VARCHAR(32),

       PRIMARY KEY (id)
);

CREATE TABLE editors (
       id SERIAL,
       name VARCHAR(32),

       PRIMARY KEY (id)
);

CREATE TABLE digits (
       digit INT PRIMARY KEY
);

CREATE TABLE u8 (
       val INT PRIMARY KEY
);

CREATE TABLE u16 (
       val INT PRIMARY KEY
);

CREATE TABLE i8 (
       val INT PRIMARY KEY
);

CREATE TABLE i16 (
       val INT PRIMARY KEY
);
