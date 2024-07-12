# Analisi
* Capire quali impostazioni sono attive e da dove le prende: `select * from pg_catalog.pg_file_settings;`

* Con psql si possono vedere statistiche interessati su database. Esempio:
* `\dt+ nome_schema.*`
* `\d+ nome_schema.nome_tabella`