#!/usr/bin/env bash

file_suffix=$(date '+%Y%m%d%H%M')
pg_dump --host=localhost --port=2345 --username=postgres --dbname=school --format=plain --file=/home/xpuser/mauro-quaglia/postgresql-rookie/dumps/dump-school-${file_suffix}.sql