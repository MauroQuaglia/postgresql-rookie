# postgresql-rookie
* Errata: [errata](https://www.oreilly.com/catalog/errata.csp?isbn=0636920052715)
* Comandi utili:
  * `sudo systemctl status postgresql`
* Controllare gli aspetti della localizzazione con il comando `locale` in particolare:
  * `LC_TYPE`: come i caratteri sono trattati e convertiti in base alle regole specifiche della lingua.
  * `LC_COLLATE`: specifica le regole di ordinamento dei caratteri.
----
* Directory utili:
  * log: `/var/log/postgresql`
  * socket, pid: `/run/postgresql`
  * dati del database: `/var/lib/postgresql/10/main` (root)
* Configurazioni: `/etc/postgresql/10/main`
  * server: `postgresql.conf`
  * accessi: `pg_hba.conf`
----
* Client:
  * Il client di default è: `psql`
  * Se si vuole `pgAdmin`, che ha una interfaccia grafica, serve installarlo. 
* `psql`:
  * `sudo -u postgres psql`
----
* Esempio:
  * `sudo -u postgres psql`
  * `\l`
  * CREATE DATABASE test;
  * `\c test`
  * `test=#` CREATE TABLE courses(c_no text PRIMARY KEY, title text, hours integer);
  * `test=#` INSERT INTO courses(c_no, title, hours) VALUES ('CS301', 'Databases', 30), ('CS305', 'Networks', 60); 
----
* DBeaver
 * Creo Database come sopra
 * Cambio il file `postgresql.conf` specificando `listen_addresses = '*'`
 * Cambio `pg_hba.conf` mettendo all'ultima riga: `host    all             all             0.0.0.0/0               trust`
 * `sudo systemctl restart postgresql`
 * Poi apro DBeaver e provo a connettermi.
