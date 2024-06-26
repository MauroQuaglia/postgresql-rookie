#!/usr/bin/env bash

# Per fare il dump di tutti i db più le varie impostazioni globali.
# Supporta solo il formato plain

file_suffix=$(date '+%Y%m%d%H%M')
pg_dumpall --host=localhost --port=2345 --username=postgres --file=/home/xpuser/mauro-quaglia/postgresql-rookie/dumps/v10/pg_dumpall-${file_suffix}.sql