#!/bin/sh

rm -rf ./psql
pg_ctl initdb -D ./psql
pg_ctl start -D ./psql -o "-p 54321"
psql -d postgres -p 54321 -f db_definitions.sql

psql -d sandbox -U maintainer -p 54321 -f table_definitions.sql

pg_ctl stop -D ./psql
