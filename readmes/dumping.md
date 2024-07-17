* Il pg_dump fa il dump del database specificato.
* Capire che versione usare del pg_dump, per esempio io ho usato quella installata sul server del tps e poi me lo sono copiato in locale:
 * `pg_dump -f pg_dump_tps_lab.sql -d staging -h localhost -p 5432 -U postgres`

* Il pg_dumpall fa il dump di tutto oppure solo della configurazione del server (`-g`):
 * `pg_dumpall -f pg_dumpall_tps_lab_all.sql -h localhost -p 5432 -U postgres`
 * `pg_dumpall -f pg_dumpall_tps_lab_not_all.sql -g -h localhost -p 5432 -U postgres`