
--------------------
-- Views
--------------------

CREATE VIEW matsuya (id, store_id, name, yen) AS 
       SELECT foods.id, foods.store_id, foods.name, foods.yen
         FROM foods
         JOIN stores ON stores.id = foods.store_id
        WHERE stores.name = '松屋'
        ORDER BY RANDOM();

CREATE VIEW saizeriya (id, store_id, name, yen) AS 
       SELECT foods.id, foods.store_id, foods.name, foods.yen
         FROM foods
         JOIN stores ON stores.id = foods.store_id
        WHERE stores.name = 'サイゼリヤ'
        ORDER BY RANDOM();

CREATE VIEW starbucks (id, store_id, name, yen) AS 
       SELECT foods.id, foods.store_id, foods.name, foods.yen
         FROM foods
         JOIN stores ON stores.id = foods.store_id
        WHERE stores.name = 'スターバックス'
        ORDER BY RANDOM();

-- メタデータ出力用
CREATE VIEW help (title, contents) AS
       SELECT bd.title, bd.contents
         FROM bot_detail AS bd
        ORDER BY bd.id ASC;

-- テーブル一覧取得用
CREATE VIEW tables ("type", "name", tbl_name, rootpage, "sql") AS
       SELECT type, name, tbl_name, rootpage, sql
         FROM sqlite_master
        WHERE type = 'table' or type = 'view'
        ORDER BY NAME ASC;

--------------------
-- Functions
--------------------

-- CREATE FUNCTION unkosay (str anyelement) RETURNS TEXT AS $$
-- BEGIN
--        RETURN CONCAT('💩{ ', str);
-- END;
-- $$ LANGUAGE plpgsql;

-- CREATE FUNCTION shout (str TEXT)
--        RETURNS TABLE (
--               val text
--        )
--        AS $$
--        SELECT
--               CONCAT('＿人', repeat('人', floor(octet_length(str) / 3 * 0.97)::integer), '＿')
--        UNION ALL
--        SELECT
--               CONCAT('＞', str, '＜')
--        UNION ALL
--        SELECT
--               CONCAT('￣Y', repeat('^Y', floor(octet_length(str) / 3 * 0.73)::integer), '￣');
-- $$
-- LANGUAGE sql;

-- CREATE FUNCTION unkoshout (str TEXT)
--        RETURNS TABLE (
--               val text
--        )
--        AS $$
--        SELECT
--               CONCAT('　 💩　　＿人', repeat('人', floor(octet_length(str) / 3 * 0.97)::integer), '＿')
--        UNION ALL
--        SELECT
--               CONCAT(' 👁👁　＞', str, '＜')
--        UNION ALL
--        SELECT
--               CONCAT('💩👄💩￣Y', repeat('^Y', floor(octet_length(str) / 3 * 0.73)::integer), '￣');
-- $$
-- LANGUAGE sql;
