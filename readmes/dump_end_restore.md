# NOTE
* Versioni software:
    * Ho installato in locale un PostgreSQL 15 per avere in locale le versioni di, __pg_dump__ e __pg_restore__ più recenti.
    * Il motivo è che usare delle versioni vecchie (v 10) per lanciare comandi sul database nuovo (v 15) non è buona cosa.
    * Viceversa, usare una versione nuova (v 15) anche per i database vecchi (v 10) va bene, il supporto è garantito.
* Attenzione che per esempio i ruoli e i permessi, come le estensioni sono a livello globale di PostgreSQL quindi in un dump non ci sono.
    * Per quelli serve fare un __pg_dumpall__ ma se ne è già parlato nell replica logica.


# Dump & Restore di una singola tabella
* Esempio usando utente __postgres__ e passando da un tunnel locale:
    * Dump della tabella __nome_tabella__ di un database __nome_database__:
```  
/usr/lib/postgresql/15/bin/pg_dump -U postgres -h localhost -p 32124 --dbname=nome_database -t nome_tabella --format=t --file=/path/database-dumps/nome_database-nome_tabella.tar
```
* Se poi, per esempio, cancello quella tabella da database e volessi provare a fare il restore della tabella stessa:
```
/usr/lib/postgresql/15/bin/pg_restore -U postgres -h localhost -p 32124 -d nome_database /path/database-dumps/nome_database-nome_tabella.tar
```

# Dump & Restore di un intero database
* Esempio usando utente __postgres__ e passando da un tunnel locale:
    * Dump di tutto il database __nome_database__:
```
/usr/lib/postgresql/15/bin/pg_dump -U postgres -h localhost -p 31123 --dbname=nome_database --format=t --file=/path/database-dumps/nome_database.tar
```
* Se poi, per esempio, volessi fare il restore di quel database in uno nuovo.
```
/usr/lib/postgresql/15/bin/pg_restore -U mquser -h localhost -p 31124 -C -d postgres --no-owner /path/database-dumps/nome_database.tar
```
* In questo caso ho usato un utente `mquser` e il flag `--no-owner` che significa che se non trova tra i ruoli l'`owner` di una tabella, gli assegna di default `mquser`.

* __Tuning__:
  * Per la sole fase di restore posso aumentare molto il `max_wal_size`. Per esempio con 8 GB di RAM possiamo metterlo a 6 GB e dopo che il restore è finito portarlo a 2 GB.
  * Sia la fase di __dump__ che quella di __restore__ può essere parallelizzata utilizzando più CPU:
    * `--jobs 4` se ho a disposizione 4 CPU.
    * Questo tipo di dump richiede che il formato del dump sia di tipo __directory__
    * Esempio: 
      * `/usr/lib/postgresql/15/bin/pg_dump -U postgres -h localhost -p 31123 --dbname=nome_database --format=d --jobs 4 --file=/path/database-dumps/nome_database.tar`
      * `/usr/lib/postgresql/15/bin/pg_restore -U mquser -h localhost -p 31124 -C -d postgres --no-owner --jobs 4 /path/database-dumps/nome_database.tar` 