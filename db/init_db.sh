#!/bin/sh

pg_ctl stop -D ./psql  # 起動したまま削除しないようにする
rm -rf ./psql

pg_ctl initdb -D ./psql
pg_ctl start -D ./psql -o "-p 54321"

# データベース定義
psql -d postgres -p 54321 -f db_definitions.sql

# テーブル定義
psql -d sandbox -U maintainer -p 54321 -f table_definitions.sql

# データのインポート
sh import_data.sh

# そのほかのデータ
psql -d sandbox -U maintainer -p 54321 -f table_miscellaneous.sql

pg_ctl stop -D ./psql
