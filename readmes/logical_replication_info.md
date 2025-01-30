* [PostgreSQL v.10](https://www.postgresql.org/docs/10/logical-replication.html)
* [PostgreSQL v.15](https://www.postgresql.org/docs/15/logical-replication.html)

* Durante l’avvio di una replica logica il Subscriber esegue una copia (pull) iniziale (Initial Data Synchronization) completa dei dati prima di iniziare a replicare le modifiche in tempo reale. 
 * Le tabelle sul publisher potrebbero essere momentaneamente in lock per garantire la consistenza dei dati.
* Dopodiché le modifiche sul Publisher vengono inviate (push) al Subscriber in tempo reale e anche i dati in transazione vengono garantiti (transactional replication).
* In sostanza le modifiche vengono accumulate nel WAL e poi consumate, consideriamo che se non consumate il WAL può crescere fino a saturare lo spazio.
  * Però (questa è una ipotesi) se la replica è asincrona, i log difficilmente verranno accumulati perché immediatamente inviati, senza aspettare nessuna notifica dal subscriber.
* Lo schema del database non viene replicato sul subscriber quindi deve essere pre esistente.
* Solo le tabelle regolari possono essere replicate, non le view, le materialized view, le partition root tables o le foreign table.
  * Le tabelle devono avere gli stessi nomi, la replica tra tabelle con nomi diversi non è supportata. 
* Le Sequence non vengono aggiornate, quindi bisogna farlo a mano
  * [logical-replication-restrictions](https://www.postgresql.org/docs/10/logical-replication-restrictions.html)
* Il ruolo dell'utente deve essere SUPEUSER e non ci pensiamo più.
* Configurazione [logical-replication-config](https://www.postgresql.org/docs/10/logical-replication-config.html):
  * A noi dovrebbe andare bene il deault.
```
Publisher:
wal_level = logical
```
# __Publication__:
* Una pubblicazione è un insieme di cambiamenti (INSERT, UPDATE, DELETE) generati su tabelle.
  * Di default tutte queste operazioni sono replicate.
* Una pubblicazione può contenere solo tabelle, gli oggetti devono essere aggiunti esplicitamente a meno che non sia creata con ALL TABLES.

# __Subscription__:
* Ogni subscription riceve cambiamenti da un solo Replication Slot.
  * Possiamo aggiungere dei RS temporanei che durano solo per la fase di IDS. Dopodichè verranno rimossi. Ma questa cosa viene gestita anche in automatico.
* Standby per replica sincrona significa che le transazioni sul publisher non vengono considerate completate finche il subscriber non conferma di averle effettuate (synchronous_commit)
  * Per noi mi sa che è meglio quella asincrona che è più veloce, tanto non abbiamo necessità che i dati siano esattamente gli stessi nello stesso momento.
* Quando creo la subscription (CREATE SUBSCRIPTION) viene creato il Replication Slot principale sul publisher, che è quello per la gestione dell'invio dei dati (push) in tempo reale.
  * Questo è l'unico che rimane attivo per tutta la sincronizzazioen.
* Se il subscriber non ha ancora i dati della tabella, PostgreSQL crea replication slot aggiuntivi temporanei per gestire il trasferimento iniziale dei dati pre-esistenti. 
  * Questi slot temporanei vengono rimossi automaticamente una volta completata la sincronizzazione iniziale.
  * Comunque il default è 10 e va bene così: `SELECT * FROM pg_catalog.pg_settings WHERE name = 'max_replication_slots';`
  * [LOGICAL-REPLICATION-SUBSCRIPTION-SLOT](https://www.postgresql.org/docs/10/logical-replication-subscription.html#LOGICAL-REPLICATION-SUBSCRIPTION-SLOT)
* E' importante che il RS in caso di malfunzionamento generale venga poi eliminato altrimenti continua a riservare del WAL che non viene mai consumato e potrebbe saturare lo spazio disco.
  * [PG-STAT-SUBSCRIPTION](https://www.postgresql.org/docs/10/monitoring-stats.html#PG-STAT-SUBSCRIPTION)
* Quando poi faccio DROP SUBSCRIPTION il RS sul publischer viene buttato, ma a noi non interessa perché poi facciamo lo swith del database e il publische lo spegniamo


# Punti di attenzione
* WAL: `/var/lib/postgresql/15/main`
  * Lo spazio disco aumenta se il WAL non viene consumato.
* Lock iniziale delle tabelle durante la __Initial Data Synchronization__.
* Le `sequence` sono da aggiornare a mano una volta finita la replica.
* La replica di default è __asincorna__ e potrebbe andare bene così perché garantisce performance elevate anche su grandi tabelle.
* Configurazioni:
```
Publisher:
wal_level = logical
```
