# データのインポート
psql -d sandbox -U maintainer -p 54321 -c "\copy nations from ../data/general/nations.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy prefs from ../data/general/prefs.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy stores from ../data/general/stores.csv with csv header"

psql -d sandbox -U maintainer -p 54321 -c "\copy eki_company from ../data/eki/company.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_line from ../data/eki/line.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_station from ../data/eki/station.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_station_join from ../data/eki/join.csv with csv header"

psql -d sandbox -U maintainer -p 54321 -c "\copy msky_emoji from ../data/misskey/emojis.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy puppu from ../data/misskey/puppu.csv with csv header"

psql -d sandbox -U maintainer -p 54321 -f table_data.sql
