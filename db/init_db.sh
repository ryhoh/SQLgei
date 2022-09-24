#!/bin/sh

rm -f sandbox.db
sqlite3 sandbox.db ".read table_definitions.sql"
sqlite3 sandbox.db ".read table_data.sql"

# 駅データ.jp の csv をインポート
sqlite3 -separator , sandbox.db ".import ../data/eki/company.csv eki_company"
sqlite3 -separator , sandbox.db ".import ../data/eki/line.csv eki_line"
sqlite3 -separator , sandbox.db ".import ../data/eki/station.csv eki_station"
sqlite3 -separator , sandbox.db ".import ../data/eki/join.csv eki_station_join"

sqlite3 sandbox.db ".read table_miscellaneous.sql"
