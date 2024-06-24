#!/usr/bin/env bash

# Quando si fa il dump, la funzione pg_dump è quella locale non quella remota della macchina pg-vagrant.
# Infatti se poi si guardano i commenti del file di dump, la cosa è chiara.

db=$1

file_suffix=$(date '+%Y%m%d%H%M')
pg_dump --host=localhost --port=2345 --username=postgres --dbname=${db} --create --format=plain --file=/home/xpuser/mauro-quaglia/postgresql-rookie/dumps/v10/dump-${db}-${file_suffix}.sql