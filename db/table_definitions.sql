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

-- 駅データ.jp ここから
CREATE TABLE eki_company (
       company_cd      INTEGER          DEFAULT 0 NOT NULL PRIMARY KEY,
       rr_cd           INTEGER          DEFAULT 0 NOT NULL,
       company_name    VARCHAR(256)     DEFAULT '' NOT NULL,
       company_name_k  VARCHAR(256)     DEFAULT NULL,
       company_name_h  VARCHAR(256)     DEFAULT NULL,
       company_name_r  VARCHAR(256)     DEFAULT NULL,
       company_url     VARCHAR(512)     DEFAULT NULL,
       company_type    INTEGER          DEFAULT 0,
       e_status        INTEGER          DEFAULT 0,
       e_sort          INTEGER          DEFAULT 0
);

CREATE INDEX eki_company_rr_cd         ON eki_company(rr_cd);
CREATE INDEX eki_company_company_type  ON eki_company(company_type);
CREATE INDEX eki_company_e_sort        ON eki_company(e_sort);

CREATE TABLE eki_line (
       line_cd      INTEGER          DEFAULT 0 NOT NULL PRIMARY KEY,
       company_cd   INTEGER          DEFAULT 0 NOT NULL,
       line_name    VARCHAR(256)     DEFAULT '' NOT NULL,
       line_name_k  VARCHAR(256)     DEFAULT NULL,
       line_name_h  VARCHAR(256)     DEFAULT NULL,
       line_color_c VARCHAR(8)       DEFAULT NULL,
       line_color_t VARCHAR(32)      DEFAULT NULL,
       line_type    INTEGER          DEFAULT 0,
       lon          DOUBLE PRECISION DEFAULT 0,
       lat          DOUBLE PRECISION DEFAULT 0,
       zoom         INTEGER          DEFAULT 0,
       e_status     INTEGER          DEFAULT 0,
       e_sort       INTEGER          DEFAULT 0,

       FOREIGN KEY (company_cd) REFERENCES eki_company(company_cd)
);

CREATE INDEX eki_line_company_cd ON eki_line(company_cd);
CREATE INDEX eki_line_e_sort     ON eki_line(e_sort);

CREATE TABLE eki_station (
       station_cd     INTEGER          DEFAULT 0 NOT NULL PRIMARY KEY,
       station_g_cd   INTEGER          DEFAULT 0 NOT NULL,
       station_name   VARCHAR(256)     DEFAULT '' NOT NULL,
       station_name_k VARCHAR(256)     DEFAULT NULL,
       station_name_r VARCHAR(256)     DEFAULT NULL,
       -- station_name2  VARCHAR(256)     DEFAULT NULL,
       -- station_number VARCHAR(256)     DEFAULT NULL,
       -- station_u      VARCHAR(256)     DEFAULT NULL,
       line_cd        INTEGER          DEFAULT 0 NOT NULL,
       pref_cd        INTEGER          DEFAULT 0,
       post           VARCHAR(32)      DEFAULT NULL,
       address        VARCHAR(1024)    DEFAULT NULL,
       lon            DOUBLE PRECISION DEFAULT 0,
       lat            DOUBLE PRECISION DEFAULT 0,
       open_ymd       date             DEFAULT NULL,
       close_ymd      date             DEFAULT NULL,
       e_status       INTEGER          DEFAULT 0,
       e_sort         INTEGER          DEFAULT 0,

       FOREIGN KEY (line_cd) REFERENCES eki_line(line_cd)
);

CREATE INDEX eki_station_station_g_cd ON eki_station(station_g_cd);
CREATE INDEX eki_station_line_cd      ON eki_station(line_cd);
CREATE INDEX eki_station_pref_cd      ON eki_station(pref_cd);
CREATE INDEX eki_station_e_sort       ON eki_station(e_sort);

CREATE TABLE eki_station_join (
       line_cd        INTEGER      DEFAULT 0 NOT NULL,
       station_cd1    INTEGER      DEFAULT 0 NOT NULL,
       station_cd2    INTEGER      DEFAULT 0 NOT NULL,
       
       PRIMARY KEY (line_cd,station_cd1,station_cd2)
);
-- 駅データ.jp ここまで
