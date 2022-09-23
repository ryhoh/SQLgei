#!/bin/sh

rm -f sandbox.db
sqlite3 sandbox.db ".read table_definitions.sql"
sqlite3 sandbox.db ".read table_data.sql"

# 駅データ.jp の csv をインポート
sqlite3 -separator , sandbox.db ".import ../data/eki/company20200619.csv eki_company"
sqlite3 -separator , sandbox.db ".import ../data/eki/line20211208free.csv eki_line"
sqlite3 -separator , sandbox.db ".import ../data/eki/station20211222free.csv eki_station"
sqlite3 -separator , sandbox.db ".import ../data/eki/join20211208.csv eki_station_join"

#sqlite3 sandbox.db ".read table_miscellaneous.sql"
