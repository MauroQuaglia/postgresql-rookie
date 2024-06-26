#!/usr/bin/env bash

# Per fare il dump di un solo db alla volta.
# Supporta vari formati: c|d|t|p  (custom, directory, tar, plain text (default))

db="$1"
format="p"
if [ ! -z "$2" ]; then
  format="$2"
fi

file_suffix=$(date '+%Y%m%d%H%M')
pg_dump --host=localhost --port=2345 --username=postgres --dbname=${db} --create --blobs --format=${format} --file=/home/xpuser/mauro-quaglia/postgresql-rookie/dumps/v10/pg_dump-${db}-${format}-${file_suffix}.sql

# Quando si fa il dump, la funzione pg_dump è quella locale non quella remota della macchina pg-vagrant.
# Infatti se poi si guardano i commenti del file di dump, la cosa è chiara.