#!/usr/bin/env bash

# Quando ho fatto un:
# pg_dump con formato "plain"
# pg_dumpall (che fa solo "plain")
# devo usare psql per fare il restore.

file="$1"
psql --host=localhost --port=2345 --username=postgres --file=${file}
