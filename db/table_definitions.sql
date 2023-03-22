--------------------
-- Table Definition
--------------------

CREATE TABLE nations (
       id INT PRIMARY KEY,
       official VARCHAR(32) NOT NULL,
       short VARCHAR(32) NOT NULL
);
 GRANT SELECT ON nations TO bot;

CREATE TABLE prefs (
       id INT PRIMARY KEY,
       name VARCHAR(16) NOT NULL
);
 GRANT SELECT ON prefs TO bot;

CREATE TABLE stores (
       id INT PRIMARY KEY,
       name VARCHAR(32) NOT NULL,
       hq_pref_id INT NOT NULL,

       FOREIGN KEY (hq_pref_id) REFERENCES prefs(id)
);
 GRANT SELECT ON stores TO bot;

CREATE TABLE foods (
       id SERIAL PRIMARY KEY,
       store_id INT NOT NULL,
       name VARCHAR(64) NOT NULL,
       yen INT NOT NULL,

	UNIQUE (name, store_id),
       FOREIGN KEY (store_id) REFERENCES stores(id)
);
 GRANT SELECT ON foods TO bot;

CREATE TABLE os (
       id SERIAL PRIMARY KEY,
       name VARCHAR(32) NOT NULL,
       emoji VARCHAR(128) -- fixme id を参照すべき
);
 GRANT SELECT ON os TO bot;

CREATE TABLE editors (
       id SERIAL PRIMARY KEY,
       name VARCHAR(32) NOT NULL,
       emoji VARCHAR(128) -- fixme id を参照すべき
);
 GRANT SELECT ON editors TO bot;

CREATE TABLE persons (
       id SERIAL PRIMARY KEY,
       name VARCHAR(16) NOT NULL
);
 GRANT SELECT ON persons TO bot;

CREATE TABLE digits (
       digit INT PRIMARY KEY
);
 GRANT SELECT ON digits TO bot;

CREATE TABLE u8 (
       val INT PRIMARY KEY
);
 GRANT SELECT ON u8 TO bot;

CREATE TABLE u16 (
       val INT PRIMARY KEY
);
 GRANT SELECT ON u16 TO bot;

CREATE TABLE i8 (
       val INT PRIMARY KEY
);
 GRANT SELECT ON i8 TO bot;

CREATE TABLE i16 (
       val INT PRIMARY KEY
);
 GRANT SELECT ON i16 TO bot;

CREATE TABLE bot_detail (
       id SERIAL PRIMARY KEY,
       title VARCHAR(32) NOT NULL,
       contents VARCHAR(256) NOT NULL
);
 GRANT SELECT ON bot_detail TO bot;

CREATE TABLE dependencies (
       id SERIAL PRIMARY KEY,
       name VARCHAR(64) NOT NULL,
       url VARCHAR(256) NOT NULL,
       license_or_term VARCHAR(256) NOT NULL
);
 GRANT SELECT ON libraries TO bot;

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
 GRANT SELECT ON eki_company TO bot;

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
 GRANT SELECT ON eki_line TO bot;

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
 GRANT SELECT ON eki_station TO bot;

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
 GRANT SELECT ON eki_station_join TO bot;
-- 駅データ.jp ここまで

-- misskey 系 ここから
CREATE TABLE msky_emoji (
       id SERIAL PRIMARY KEY,
       name VARCHAR(128) NOT NULL,
       info VARCHAR(1024)
);
 GRANT SELECT ON msky_emoji TO bot;

CREATE TABLE msky_hiragana (
       id SERIAL PRIMARY KEY,
       kana CHAR(1) NOT NULL,
       emoji_id INTEGER NOT NULL,
       
       FOREIGN KEY (emoji_id) REFERENCES msky_emoji(id)
);
 GRANT SELECT ON msky_hiragana TO bot;

CREATE TABLE puppu (
       code VARCHAR(32) PRIMARY KEY  -- fixme msky_emoji.id を参照すべき
);
 GRANT SELECT ON puppu TO bot;
-- misskey 系、ここまで
