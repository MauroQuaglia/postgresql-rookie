* Ecco un estratto di quando ho fatto partire due istanze di PostgreSQL sulla stessa macchina.
* Sulla porta 5430 c'era la V10.
* Sulla porta 5432 c'era la V11.
* Torna tutto... da notare che si deve selezionare una versione esplicita di psql e tramite -p gli si può dire a quale db connettersi.
* Tipo che posso usare psql v11 per connetteri al db v10 e viceversa (questa volta con warning)

```
postgres@pg-vagrant:~$ /usr/lib/postgresql/11/bin/psql -p 5430
psql (11.22 (Debian 11.22-4.pgdg110+1), server 10.23 (Debian 10.23-3.pgdg110+2))
Type "help" for help.

postgres=# select version();
version
-------------------------------------------------------------------------------------------------------------------------------
PostgreSQL 10.23 (Debian 10.23-3.pgdg110+2) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
(1 row)
```

```
postgres@pg-vagrant:~$ /usr/lib/postgresql/11/bin/psql -p 5432
psql (11.22 (Debian 11.22-4.pgdg110+1))
Type "help" for help.

postgres=# select version();
version
-------------------------------------------------------------------------------------------------------------------------------
PostgreSQL 11.22 (Debian 11.22-4.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
(1 row)
```

```
postgres@pg-vagrant:~$ /usr/lib/postgresql/10/bin/psql -p 5430
psql (10.23 (Debian 10.23-3.pgdg110+2))
Type "help" for help.

postgres=# select version();
version
-------------------------------------------------------------------------------------------------------------------------------
PostgreSQL 10.23 (Debian 10.23-3.pgdg110+2) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
(1 row)
```

```
postgres@pg-vagrant:~$ /usr/lib/postgresql/10/bin/psql -p 5432
psql (10.23 (Debian 10.23-3.pgdg110+2), server 11.22 (Debian 11.22-4.pgdg110+1))
WARNING: psql major version 10, server major version 11.
Some psql features might not work.
Type "help" for help.

postgres=# select version();
version
-------------------------------------------------------------------------------------------------------------------------------
PostgreSQL 11.22 (Debian 11.22-4.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
(1 row)
```