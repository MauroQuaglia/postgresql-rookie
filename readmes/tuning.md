# Dei tuning per un database con 8GB di RAM posso essere di questo tipo:
* Sempre da mettere nel `postgresql.auto.conf`:
```
listen_addresses = '*'
shared_buffers = 2GB
effective_cache_size = 4GB
work_mem = 16MB
maintenance_work_mem = 512MB
autovacuum_vacuum_threshold = 50000
autovacuum_vacuum_scale_factor = 0.05
autovacuum_vacuum_cost_limit = 2000
max_wal_size = 2GB
```

# Query parallelization improvements
Eseguire alcune query su più processi paralleli. Per esempio alcune JOIN sono parallelizzabili, e possono essere fatte in processi separati!

# Declarative table partitioning
Il partizionamento non comporta lo spostamento fisico dei dati da una tabella all'altra, ma piuttosto definisce come i dati
sono suddivisi e archiviati all'interno della stessa tabella. Quando viene applicato il partizionamento a una tabella, 
vengono create partizioni logiche all'interno della tabella stessa.

# Using unlogge table as a fast way to populate new tables
* SET UNLOGGED
* Però attenzione che ci sono delle controindicazioni.
Le "unlogged table" (tabelle non registrate) in PostgreSQL sono tabelle temporanee che non registrano 
le modifiche nel log di transazione WAL (Write-Ahead Logging). 
Questo significa che le modifiche effettuate su queste tabelle non vengono scritte in modo permanente sul disco e non sono ripristinabili dopo un arresto anomalo del database.
Dovrebbero essere utilizzate con cautela e solo in situazioni in cui la persistenza e la ripristinabilità dei dati non sono una priorità.

# Posso anche interrogare direttamente il server
* `select name, setting from pg_settings where category ILIKE '%Tuning%';`

# Risorse
[postgresql | Tuning_Your_PostgreSQL_Server](https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server)

* Per analisi performance c'è una estensione: pg_stat_statements
* Come sql:
 * `VACUUM FULL;`
 * `VACUUM ANALYZE;`
