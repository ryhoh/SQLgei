
--------------------
-- Views
--------------------

CREATE VIEW matsuya (id, store_id, name, yen) AS 
       SELECT foods.id, foods.store_id, foods.name, foods.yen
         FROM foods
         JOIN stores ON stores.id = foods.store_id
        WHERE stores.name = '松屋'
        ORDER BY RANDOM();
 GRANT SELECT ON matsuya TO bot;

CREATE VIEW saizeriya (id, store_id, name, yen) AS 
       SELECT foods.id, foods.store_id, foods.name, foods.yen
         FROM foods
         JOIN stores ON stores.id = foods.store_id
        WHERE stores.name = 'サイゼリヤ'
        ORDER BY RANDOM();
 GRANT SELECT ON saizeriya TO bot;

CREATE VIEW starbucks (id, store_id, name, yen) AS 
       SELECT foods.id, foods.store_id, foods.name, foods.yen
         FROM foods
         JOIN stores ON stores.id = foods.store_id
        WHERE stores.name = 'スターバックス'
        ORDER BY RANDOM();
 GRANT SELECT ON starbucks TO bot;

-- メタデータ出力用
CREATE VIEW help (title, contents) AS
       SELECT bd.title, bd.contents
         FROM bot_detail AS bd
        ORDER BY bd.id ASC;
 GRANT SELECT ON help TO bot;

-- テーブル一覧取得用
CREATE VIEW tables (schemaname, tablename) AS
       SELECT schemaname, tablename
         FROM pg_tables
        WHERE schemaname NOT LIKE 'pg_%' AND schemaname != 'information_schema';
 GRANT SELECT ON tables TO bot;

--------------------
-- Functions
--------------------

CREATE FUNCTION unkosay (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('💩{ ', str);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION shout (str TEXT)
       RETURNS TABLE (
              val text
       )
       AS $$
       SELECT
              CONCAT('＿人', repeat('人', floor(octet_length(str) / 3 * 0.97)::integer), '＿')
       UNION ALL
       SELECT
              CONCAT('＞', str, '＜')
       UNION ALL
       SELECT
              CONCAT('￣Y', repeat('^Y', floor(octet_length(str) / 3 * 0.73)::integer), '￣');
$$
LANGUAGE sql;

CREATE FUNCTION unkoshout (str TEXT)
       RETURNS TABLE (
              val text
       )
       AS $$
       SELECT
              CONCAT('　 💩　　＿人', repeat('人', floor(octet_length(str) / 3 * 0.97)::integer), '＿')
       UNION ALL
       SELECT
              CONCAT(' 👁👁　＞', str, '＜')
       UNION ALL
       SELECT
              CONCAT('💩👄💩￣Y', repeat('^Y', floor(octet_length(str) / 3 * 0.73)::integer), '￣');
$$
LANGUAGE sql;
