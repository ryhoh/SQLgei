
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
CREATE VIEW tables (tablename) AS
       SELECT tablename
         FROM pg_tables
        WHERE schemaname NOT LIKE 'pg_%' AND schemaname != 'information_schema';
 GRANT SELECT ON tables TO bot;

 -- カラム一覧取得用
CREATE VIEW columns (table_name, column_name, data_type) AS
       SELECT table_name, column_name, data_type
         FROM information_schema.columns
        WHERE table_schema NOT LIKE 'pg_%' AND table_schema != 'information_schema'
        ORDER BY ordinal_position;

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

-- for misskey
CREATE FUNCTION msky_as_emoji (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT(':', str, ':');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_bold (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('**', str, '**');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_italic (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('<i>', str, '</i>');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_strike (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('~~', str, '~~');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_small (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('<small>', str, '</small>');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_quote (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('> ', str);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_dbl_quote (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('>> ', str);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_center (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('<center>', str, '</center>');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_code_inline (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('`', str, '`');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_code_block (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('```', str, '```');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_flip (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[flip ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_flip_v (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[flip.v ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_flip_h (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[flip.h ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_flip_hv (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[flip.h,v ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_font (str anyelement, font anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[font.', font, ' ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_blur (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[blur ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_plain (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('<plain>', str, '</plain>');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_search (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT(str, ' 検索');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_jelly (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[jelly ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_tada (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[tada ', str, ' ]');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_bounce (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[bounce ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_shake (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[shake ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_twitch (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[twitch ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinzr (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.z,right ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinzl (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.z,left ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinz (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.z,alternate ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinxr (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.x,right ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinxl (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.x,left ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinx (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.x,alternate ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinyr (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.y,right ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinyl (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.y,left ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spiny (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.y,alternate ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinspdzr (str anyelement, speed anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.z,right,speed=', speed, 'ms ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinspdzl (str anyelement, speed anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.z,left,speed=', speed, 'ms ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinspdz (str anyelement, speed anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.z,alternate,speed=', speed, 'ms ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinspdxr (str anyelement, speed anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.x,right,speed=', speed, 'ms ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinspdxl (str anyelement, speed anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.x,left,speed=', speed, 'ms ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinspdx (str anyelement, speed anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.x,alternate,speed=', speed, 'ms ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinspdyr (str anyelement, speed anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.y,right,speed=', speed, 'ms ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinspdyl (str anyelement, speed anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.y,left,speed=', speed, 'ms ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_spinspdy (str anyelement, speed anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('$[spin.y,alternate,speed=', speed, 'ms ', str, ']');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_color (str anyelement, color anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('\textcolor{', color, '}{', str, '}');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_bgcolor (str anyelement, color anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('\fcolorbox{', color, '}{', str, '}');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_fcolorbox (str anyelement, color anyelement, bgcolor anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('\fcolorbox{', color, '}{', bgcolor, '}{', str, '}');
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION msky_box (str anyelement) RETURNS TEXT AS $$
BEGIN
       RETURN CONCAT('\boxed{', str, '}');
END;
$$ LANGUAGE plpgsql;
