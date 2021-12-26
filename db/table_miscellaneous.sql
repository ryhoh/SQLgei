
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

--------------------
-- Permissions
--------------------

 GRANT SELECT
    ON ALL TABLES IN SCHEMA public
    TO bot;
