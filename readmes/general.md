# postgresql-rookie
* Tutti i settings "postmaster" necessitano un restart, quelli invece "user" basta un reload.

* Comandi utili:
  * `sudo systemctl status postgresql`
* Controllare gli aspetti della localizzazione con il comando `locale` in particolare:
  * `LC_TYPE`: come i caratteri sono trattati e convertiti in base alle regole specifiche della lingua.
  * `LC_COLLATE`: specifica le regole di ordinamento dei caratteri.
----
# Directory utili:
  * log: `/var/log/postgresql`
  * socket, pid: `/run/postgresql`
  * dati del database: `/var/lib/postgresql/10/main` (root)
* Configurazioni: `/etc/postgresql/10/main`
  * server: `postgresql.conf`
  * accessi: `pg_hba.conf`
----
# Copiare file originali in locale
* Facciamo l'esempio di aver installato su Vagrant un PostgreSQL V10 e di voler poi copiare alcuni suoi file di configurazione in locale:
* Devo andare sulla VM, copiare i file in un posto utile così da potergli cambiare i permessi e poi posso copiarmeli in locale:
* Esempio:
```
vagrant ssh
sudo cp /etc/postgresql/10/main/pg_hba.conf /home/vagrant
sudo chown vagrant:vagrant /home/vagrant/pg_hba.conf
scp -i /home/xpuser/mauro-quaglia/postgresql-rookie/ansible/.vagrant/machines/pg-vagrant/virtualbox/private_key -P 2222 vagrant@localhost:/home/vagrant/pg_hba.conf .
```
----
# Client:
  * Il client di default è: `psql`
  * Se si vuole `pgAdmin`, che ha una interfaccia grafica, serve installarlo. 
* `psql`:
  * `sudo -u postgres psql`
----
# DBeaver
 * Creo Database come sopra (Se non ho il Database non mi connetto a niente e non funziona da DBeaver)
 * Cambio il file `postgresql.conf` specificando `listen_addresses = '*'`
 * Cambio `pg_hba.conf` mettendo all'ultima riga: `host    all             all             0.0.0.0/0               trust`
 * `sudo systemctl restart postgresql`
 * Poi apro DBeaver e provo a connettermi.
# Dump
* Come Local client scegliere: `/usr/lib/postgresql/11`
----
# Utenti e Ruoli
* Creo Utente.
* All'Utente assegno un Ruolo.
  * I ruoli definiscono una serie di permessi e capacità da assegnare agli utenti.
  * `SUPERUSER`: bypass di tutti i permessi necessari eccetto la login.
  * `LOGIN`: consente di connettersi al database.
  * `CREATEDB`: consente di creare database.
  * `CREATEROLE`: permette di gestire i ruoli.
  * `REPLICATION`: consente gestione delle repliche.
  * `PASSWORD`: gli assegna una password.
  * `INHERIT`: eredita i privilegi dei ruoli di cui è membro.
  * `BYPASSRLS`: può bypassare le regole di sicurezza a livello di riga. (è possibile anche far vedere solo determinati record di una tabella)
* Dato che un utente senza ruolo non serve a niente si crea già da subito il ruolo.

* Entro come utente `postgres` (`superuser`)
  * `sudo -u postgres psql`
* Voglio creare un nuovo ruolo.
  * Dato che sono utente postgres (quindi superuser) lo posso fare.
  * Il ruolo che vado a definire è a livello di istanza del server, quindi tutti i database lo vedono.
  * `CREATE ROLE messi;`
    * Di default viene fatto come `CREATE ROLE messi WITH NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT NOLOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT -1;`
  * Di fatto questo utente non riesce a fare nulla, perché non ha neanche il ruolo di `LOGIN`.
  * Per cui anche se definito nel `ph_hba.conf`, sui database non riesce a loggarsi neanche se ha metodo `trust`.
* Voglio dare più permessi all'utente `messi`, per cui gli do il ruolo `LOGIN` così che possa autenticarsi.
  * Dato che nel `pg_hba.conf` ha metodo `trust`, la password non gli serve.
  * `ALTER ROLE messi WITH LOGIN;`
  * Ora l'utente `messi` si può loggare senza password ai vari database.
  * Tuttavia neanche riesce a vedere i dati delle tabelle perché non ha i permessi per farlo.
* Diamogli i permessi per visualizzare i dati della tabella `town.school.courses`.
  * `\c town`
  * `GRANT USAGE ON SCHEMA school TO messi;` (prima di tutti deve avere i permessi sullo schema)
  * `GRANT SELECT ON TABLE school.courses TO messi;` (poi per fare select sulla tabella)
  * OSS: L'utente è definito per tutti i database, ma solo sul database `town` ha i permessi per fare select sulla `tabella school.courses`.

* Quindi quando si ha un utente, gli si assegna
  * Un ruolo
  * dei permessi che devono andare a scalate: database -> schema -> tabelle
  * `CREATE ROLE messi WITH LOGIN;` (utente e ruolo, si logga ai database)
  * `GRANT USAGE ON SCHEMA school TO messi;` (schema)
  * `GRANT SELECT ON TABLE school.courses TO messi;` (tabella)
  * I permessi sono molto granulari e posso essere asseganti anche a funzioni, trigger, ecc,.

* Per capire chi sono e come cambiare ruolo.
* Supponiamo di entrare come superuser postgres: `select session_user,current_user;` (postgres, postgres)
* SET ROLE messi; (divento messi)
* `select session_user,current_user;` (postgres, messi)
* Se poi voglio tornare indietro basta fare `RESET ROLE` e torno (postgres, postgres).
  