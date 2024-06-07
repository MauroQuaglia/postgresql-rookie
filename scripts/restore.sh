#!/usr/bin/env bash

file_name=$1
psql --host=localhost --port=2345 --username=postgres --file=/home/xpuser/mauro-quaglia/postgresql-rookie/dumps/${file_name}
