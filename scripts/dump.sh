#!/usr/bin/env bash

file_suffix=$(date '+%Y%m%d%H%M')
pg_dump --host=localhost --port=2345 --username=postgres --dbname=town --create --format=plain --file=/home/xpuser/mauro-quaglia/postgresql-rookie/dumps/v10/dump-town-${file_suffix}.sql