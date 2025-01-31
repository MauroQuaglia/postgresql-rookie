# Parte teorica
* Documentazione ufficiale:
  * [PostgreSQL v.10](https://www.postgresql.org/docs/10/logical-replication.html)
  * [PostgreSQL v.15](https://www.postgresql.org/docs/15/logical-replication.html)
* Durante l’avvio di una replica logica il Subscriber esegue una copia (__pull__) iniziale (Initial Data Synchronization) completa dei dati prima di iniziare a replicare le modifiche in tempo reale.
* Le tabelle sul Publisher potrebbero essere momentaneamente in lock per garantire la consistenza dei dati.
* Dopodiché le modifiche sul Publisher vengono inviate (__push__) al Subscriber in tempo reale e anche i dati in transazione vengono garantiti (transactional replication).
* In sostanza le modifiche vengono accumulate nel WAL del Publisher e poi consumate.
  * Consideriamo che se non consumate il WAL può crescere fino a saturare lo spazio.
  * Però (questa è una ipotesi) se la replica è asincrona, i log difficilmente verranno accumulati perché immediatamente inviati, senza aspettare nessuna notifica dal Subscriber.
* Lo schema del database non viene replicato sul Subscriber quindi deve essere pre esistente.
* Solo le tabelle regolari possono essere replicate, non le view, le materialized view, le partition root tables o le foreign table.
  * Le tabelle devono avere gli stessi nomi, la replica tra tabelle con nomi diversi non è supportata.
* Le Sequence non vengono aggiornate, quindi bisogna farlo a mano
  * [logical-replication-restrictions](https://www.postgresql.org/docs/10/logical-replication-restrictions.html)
* Il ruolo dell'utente deve essere SUPEUSER e non ci pensiamo più.
* Configurazione [logical-replication-config](https://www.postgresql.org/docs/10/logical-replication-config.html):
  * A noi dovrebbe andare bene il deault.

# __Publication__:
* Una pubblicazione è un insieme di cambiamenti (`INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`) generati su tabelle.
  * Di default tutte queste operazioni sono replicate.
* Una pubblicazione può contenere solo tabelle, gli "oggetti" devono essere aggiunti esplicitamente a meno che non sia creata con `ALL TABLES`.
  * Noi abbiamo sempre usato `ALL TABLES`.

# __Subscription__:
* Ogni subscription riceve cambiamenti da un solo Replication Slot.
  * Il RS è processo che si incarica di mandare i dati dal WAL del Publisher.
  * Possiamo aggiungere dei RS temporanei che durano solo per la fase di IDS. Dopodiché verranno rimossi. Ma questa cosa viene gestita anche in automatico, quindi è meglio lasciare fare a lui.
* Standby per replica sincrona significa che le transazioni sul Publisher non vengono considerate completate finché il Subscriber non conferma di averle effettuate (synchronous_commit):
  * Per noi mi sa che è meglio quella asincrona che è più veloce, tanto non abbiamo necessità che i dati siano esattamente gli stessi nello stesso momento.
* Quando creo la subscription (`CREATE SUBSCRIPTION`) viene creato il Replication Slot principale sul Publisher, che è quello per la gestione dell'invio dei dati (__push__) in tempo reale.
  * Questo è l'unico che rimane attivo per tutta la sincronizzazione.
* Se il Subscriber non ha ancora i dati della tabella, PostgreSQL crea replication slot aggiuntivi temporanei per gestire il trasferimento iniziale dei dati preesistenti.
  * Questi slot temporanei vengono rimossi automaticamente una volta completata la sincronizzazione iniziale.
  * Comunque il default è 10 e va bene così: `SELECT * FROM pg_catalog.pg_settings WHERE name = 'max_replication_slots';`
  * [LOGICAL-REPLICATION-SUBSCRIPTION-SLOT](https://www.postgresql.org/docs/10/logical-replication-subscription.html#LOGICAL-REPLICATION-SUBSCRIPTION-SLOT)
* E' importante che il RS in caso di malfunzionamento generale venga poi eliminato altrimenti continua a riservare del WAL che non viene mai consumato e potrebbe saturare lo spazio disco.
  * [PG-STAT-SUBSCRIPTION](https://www.postgresql.org/docs/10/monitoring-stats.html#PG-STAT-SUBSCRIPTION)
* Quando poi faccio `DROP SUBSCRIPTION` il RS sul Publisher viene buttato, ma a noi non interessa perché poi facciamo lo switch del database e il Publisher lo spegniamo.

----

# ESEMPIO DI UNA MIGRAZIONE EFFETTUATA
* E' un esempio della migrazione dei dati del MQService.
  * Da PostgreSQL 10 su Debian 10
  * A PostgreSQL 15 su Debian 12
* Versioni software:
  * Ho installato in locale un PostgreSQL 15 per avere in locale le versioni di `pg_dumpall`, `pg_dump`, `psql` più recenti.
    * Il motivo è che usare delle versioni vecchie (v 10) per lanciare comandi sul database nuovo (v 15) non è buona cosa.
    * Viceversa, usare una versione nuova (v 15) anche per i database vecchi (v 10) va bene, il supporto è garantito.
* Utente __mquser__:
  * Non ha il ruolo `REPLICATION`, ma essendo `SUPERUSER` non è un problema perché ha comunque tutti i privilegi necessari.

## Check delle configurazioni generali di PostgreSQL:
* __DB_OLD__: `/usr/lib/postgresql/15/bin/pg_dumpall -U mquser -h localhost -p 20056 -g -f /home/mquser/ruby/mq-service/dumps/db_old_globals.sql`
  * Dovrebbero esserci solo gli utenti con i loro ruoli.
  * Già il nostro ansible dovrebbe averli creati.

## Check Connessione tra DB_OLD e DB_NEW:
* Provato un `telnet` da __DB_OLD__ a __DB_NEW__ e viceversa:
  * `PRO mquser@mq-old-db:~$ telnet mq-new-db.pro.lcl 5432`: OK
  * `PRO mquser@mq-new-db:~$ telnet mq-old-db.pro.lcl 5432`: OK
  * I database si vedono tra di loro.

## Dump (DB_OLD) - Restore (DB_NEW) della sola struttura del database:
* Dump della sola struttura del __DB_OLD__:
  * `/usr/lib/postgresql/15/bin/pg_dump -U mquser -h localhost -p 20056 -s -d mq_service_production -C -f /home/mquser/ruby/mq-service/dumps/db_old_schemas.sql`
  * __NB__:
    * In questo dump ci sono anche le sequence che come detto sono impostate con `START WITH 1`.
    * Già da qui possiamo modificare questo valore con uno maggiore, andando a vedere cosa c'è sul __DB_OLD__ (`SELECT last_value FROM sequence_name;`) e avendo cura di mettere un valore sufficientemente grande.
* Restore della stessa struttura sul __DB_NEW__:
  * `/usr/lib/postgresql/15/bin/psql -U mquser -h localhost -p 20058 -d postgres -f /home/mquser/ruby/mq-service/dumps/db_old_schemas.sql`
  * __NB__:
    * `-d postgres` perché è necessario specificare un database esistente come punto di partenza per l'importazione della struttura.
    * Chiederà la password di __mquser__ che è quella per connettersi al database e che è criptata con il vault di ansible all'interno del progetto.
* Fare un compare tra i setting del DB_OLD e quelli del DB_NEW:
  * Lanciamo la query `SELECT "name", setting, unit FROM pg_catalog.pg_settings ORDER BY lower("name") ASC;` su DB_OLD e DB_NEW, scarichiamo i CSV e facciamo un `meld`.
  * Ci saranno sicuramente una marea di cose nuove, ma serve per avere una idea.
  * Controllare Encoding: deve essere `UTF8` per DB_OLD e DB_NEW.
  * Controllare TimeZone: deve essere `Europe/Rome` per DB_OLD e DB_NEW.


## <span style="background-color:palegreen;">PROCEDURA DI REPLICA LOGICA</span>
* Sul __DB_OLD__:
  * Mettere nel `/var/lib/postgresql/10/main/postgresql.auto.conf` la configurazione: `wal_level = logical`
  * Fare restart: `systemctl restart postgresql`
* Per sicurezza impostare su DBeaver come default il database che si vuole replicare (clic destro -> Set as default) sul nome del database.
  * Eseguire la query: `CREATE PUBLICATION full_db_pub FOR ALL TABLES;`
  * Check:
    * `SHOW wal_level;`
    * `SELECT * FROM pg_catalog.pg_publication;`
* Sul __DB_NEW__:
  * Per sicurezza impostare su DBeaver come default il database che si vuole replicare (clic destro -> Set as default) sul nome del database.
  * `CREATE SUBSCRIPTION full_db_sub CONNECTION 'host=mq-old-db port=5432 dbname=mq_service_production user=mquser' PUBLICATION full_db_pub;`
  * In questo caso non ho specificato la password perché mquser sul DB_OLD non ha la password, altrimenti andrebbe specificata nella stringa di connessione.
  * Check:
    * `SELECT * FROM pg_subscription;`
    * `SELECT * FROM pg_stat_subscription;`
* Monitorare il WAL del __DB_OLD__ ma potrebbe essere talemente veloce la replica che finisce subito... provare per credere.
* A questo punto posso fare delle prove per vedere se la sincronizzazione avviene correttamente.
  * Facciamo delle insert su __DB_OLD__ e vediamo che vengono replicate sul __DB_NEW__.
  * __NB__: Questo non vale come check delle sequence, perchè è solo al momento dello switch tra i due database che la sequence sul __DB_NEW__ entra in gioco.

## Deploy
* Posso deployare il MQService facendolo puntare al __DB_NEW__.
  * Mettere la password sulla GitLab CI.
* Post deploy:
  * Eliminare la subscription dal DB_NEW: `DROP SUBSCRIPTION full_db_sub;`
  * Dovrei eliminare anche la publication dal __DB_OLD__ ma visto che tanto il database poi lo spegniamo possiamo anche non farlo.
  * Adesso sì che devo fare delle insert e vedere che le sequence sul __DB_NEW__ sono a posto!

## Sistemisti.
* Mandare mail ai sistemisti per:
  * Eliminare il __DB_OLD__:
    * Spegniamo le macchine e __se__ dopo qualche giorno non le reclama nessuno le possiamo buttare.
  * Spostare tutti i check sul __DB_NEW__:
    * Grafana, Zabbix, ...
    * Attivare politiche di backup sui nuovi database.
