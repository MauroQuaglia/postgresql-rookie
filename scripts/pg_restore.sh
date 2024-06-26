#!/usr/bin/env bash

# Quando ho fatto un pg_dump con formato NON "plain" devo usare pg_restore per fare il restore.

db=$1
file=$2

pg_restore --host=localhost --port=2345 --username=postgres --dbname=${db} ${file}
