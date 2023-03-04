#!/bin/sh

rm -rf ./psql
pg_ctl initdb -D ./psql
pg_ctl start -D ./psql -o "-p 54321"
psql -d postgres -p 54321 -f db_definitions.sql

psql -d sandbox -U maintainer -p 54321 -f table_definitions.sql
psql -d sandbox -U maintainer -p 54321 -f table_data.sql

# 駅データ.jp の csv をインポート
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_company from ../data/eki/company.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_line from ../data/eki/line.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_station from ../data/eki/station.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_station_join from ../data/eki/join.csv with csv header"

psql -d sandbox -U maintainer -p 54321 -f table_miscellaneous.sql

pg_ctl stop -D ./psql
