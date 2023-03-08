#!/bin/sh

pg_ctl stop -D ./psql  # 起動したまま削除しないようにする
rm -rf ./psql

pg_ctl initdb -D ./psql
pg_ctl start -D ./psql -o "-p 54321"
psql -d postgres -p 54321 -f db_definitions.sql

# テーブル定義
psql -d sandbox -U maintainer -p 54321 -f table_definitions.sql
psql -d sandbox -U maintainer -p 54321 -f table_data.sql

# csv インポート
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_company from ../data/eki/company.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_line from ../data/eki/line.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_station from ../data/eki/station.csv with csv header"
psql -d sandbox -U maintainer -p 54321 -c "\copy eki_station_join from ../data/eki/join.csv with csv header"

psql -d sandbox -U maintainer -p 54321 -c "\copy puppu from ../data/misskey/puppu.csv with csv header"

# そのほかのデータ
psql -d sandbox -U maintainer -p 54321 -f table_miscellaneous.sql

pg_ctl stop -D ./psql
