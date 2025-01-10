* Note:
    * E' un esempio della migrazione dei dati del MQService
        * Da PostgreSQL 10 su Debian 10
        * A PostgreSQL 15 su Debian 12
    * Versioni software:
        * Ho installato in locale un PostgreSQL 15 per avere in locale le versioni di `pg_dumpall`, `pg_dump`, `psql` più recenti.
        * Il motivo è che usare delle versioni vecchie (v 10) per lanciare comandi sul database nuovo (v 15) non è buona cosa.
        * Viceversa, usare una versione nuova (v 15) anche per i database vecchi (v 10) va bene, il supporto è garantito.
    * Utente mquser
        * Anche se l'utente `mquser` non ha il ruolo `REPLICATION`, per la replica logica funziona lo stesso perché ha comunque accesso ai dati delle tabelle che è tutto ciò che gli serve.
* Check delle configurazioni generali di PostgreSQL.
    * __DB_OLD__: `/usr/lib/postgresql/15/bin/pg_dumpall -U mquser -h localhost -p 20056 -g -f /home/mquser/ruby/mq-service/dumps/db_old_globals.sql`
    * Dovrebbero esserci solo gli utenti con i loro ruoli.
    * Già il nostro ansible dovrebbe averli creati.
* Connessione tra i database:
    * Provato un `telnet` da __DB_OLD__ a __DB_NEW__ e viceversa:
        * `PRO mquser@old:~$ telnet new 5432`: OK
        * `PRO mquser@new:~$ telnet old 5432`: OK
        * I database si vedono tra di loro.
* Dump della sola struttura del __DB_OLD__:
    * `/usr/lib/postgresql/15/bin/pg_dump -U mquser -h localhost -p 20056 -s -d mqservice_production -C -f /home/mquser/ruby/mq-service/dumps/db_old_schemas.sql`
* Ricreare la stessa struttura sul __DB_NEW__:
    * `/usr/lib/postgresql/15/bin/psql -U mquser -h localhost -p 20058 -d postgres -f /home/mquser/ruby/mq-service/dumps/db_old_schemas.sql`
    * __NB__:
        * `-d postgres` è necessario perché gli serve come database di "appoggio" da cui poi creare il __mqservice_production__.
        * Chiederà la password di __mquser__ che è quella per connettersi al database e che è criptata con il vault di ansible all'interno del progetto.
* Fare un compare tra i setting del DB_OLD e quelli del DB_NEW:
    * Lanciata la query `SELECT "name", setting, unit FROM pg_catalog.pg_settings ORDER BY lower("name") ASC;` su DB_OLD e DB_NEW, scaricati i csv e fatto un meld.
    * Ci saranno sicuramente una marea di cose nuove, ma giusto per avere una idea.
    * Controllare Encoding: deve essere `UTF8` per DB_OLD e DB_NEW.
    * Controllare TimeZone: deve essere `Europe/Rome` per DB_OLD e DB_NEW.
      Inizio della procedura di Replica Logica:
    * NB: Se da DBeaver si marca la connessione come "Production" non funziona perché DBeaver per queste connessioni fa qualcosa (una specie di BEGIN ... COMMIT nascosto) e non funziona.
        * Marcare momentaneamente la connessione come non di production.
* Mettere nel `/var/lib/postgresql/10/main/postgresql.auto.conf` (DB_OLD):
    * `wal_level = logical` ma __non__ `synchronous_standby_names = '*'`.
        * Io poi non l'ho riattivato il synchronous_standby_names, da valutare se è il caso di farlo.
        * In ogni caso non si può fare a priori perché aspetterebbe il commit della SUBSCRIPTION che in questo momento non c'è ancora, quindi si blocca il database.
    * Fatto restart: `systemctl restart postgresql`
    * Impostare su DBeaver come default il database che si vuole replicare (clic destro -> Set as default) sul nome del database.
    * Sempre su DB_OLD: `CREATE PUBLICATION full_db_pub FOR ALL TABLES;`
    * Check:
        * `SELECT * FROM pg_catalog.pg_publication;`
        * `SHOW wal_level;`
* Poi nel __DB_NEW__:
    * Impostare su DBeaver come default il database che si vuole replicare (clic destro -> Set as default) sul nome del database.
    * `CREATE SUBSCRIPTION full_db_sub CONNECTION 'host=olddb port=5432 dbname=mqservice_production user=mquser' PUBLICATION full_db_pub;`
    * In questo caso non ho specificato la password perché mquser sul DB_OLD non ha la password!
    * Check:
        * `SELECT * FROM pg_subscription;`
* Monitorare i log dei due database.
* A questo punto posso fare delle prove per vedere se la sincronizzazione avviene correttamente.
* __NB__: controllare anche la correttezza delle sequence perché una volta avevamo avuto un problema causa reset delle sequence.
    * Dovrebbe essere un problema noto:  [move_a_1tb_database_from_postgresql_10_to](https://www.reddit.com/r/PostgreSQL/comments/1bnnmep/move_a_1tb_database_from_postgresql_10_to)

* Posso deployare il BlackService facendolo puntare al DB_NEW.
* Post deploy:
    * Eliminare la SUBSCRIPTION dal DB_NEW.
    * Eliminare i DB vecchi
        * Spegnamo le macchine.
        * Se dopo qualche giorno non le reclama nessuno le possiamo buttare.
    * Spostare tutti i check sui DB nuovi.
        * Attivare politiche di backup sui nuovi database.

----

# ALCUNI COMANDI SU DB_OLD
```
-- CREATE PUBLICATION full_db_pub FOR ALL TABLES;
-- SELECT * FROM pg_catalog.pg_publication;
-- SHOW wal_level;
-- DROP PUBLICATION full_db_pub;
```

# ALCUNI COMANDI SU DB_NEW
```
-- CREATE SUBSCRIPTION full_db_sub CONNECTION 'host=olddb port=5432 dbname=mqservice_production user=mquser' PUBLICATION full_db_pub;
-- SELECT * FROM pg_subscription;
-- SELECT * FROM pg_stat_subscription;
-- SELECT * FROM pg_stat_replication;
-- DROP SUBSCRIPTION full_db_sub;
```