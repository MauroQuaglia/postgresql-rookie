# pg_cron
* [pg-cron](https://packages.debian.org/source/sid/pg-cron)
* [citusdata](https://github.com/citusdata/pg_cron?tab=readme-ov-file)
* `sudo apt install postgresql-10-cron`
* In `postgresql.conf`: `shared_preload_libraries = 'pg_cron'`
* posso anche scegliere il database dove installare `pg_cron` altrimenti di default è postgres: `cron.database_name = 'doggie_spa'`
* `restart di postgres`
* Se poi mi collego al database e guardo sotto le estensioni, mi ritrovo anche `pg_cron`.
* Vado in `doggie_spa` e faccio `create extension pg_cron;`
* Provo a schedulare: `SELECT cron.schedule('* * * * *', $$DELETE FROM dogs.breeds WHERE breed = 'bulldog'$$);`
* Poi nel file pg_hba.conf bisogna sistemare gli accessi per permettere all'utente che esegue il cron di collegarsi senza ssl dall'indirizzo locale.
    * Io sono andato di mannaia e ho permesso tutto, ma il gioco sta li.
    * Infatti poi ha funzionato:
    * ```
      hostnossl all             all             0.0.0.0/0          trust
      hostnossl all             all             ::/0          trust
      ```
* Se qualcosa non funziona guardare i log in `/var/log/postgresql/pg_log`.