# postgresql-rookie
* Errata: [errata](https://www.oreilly.com/catalog/errata.csp?isbn=0636920052715)
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
# Esempio:
* `sudo -u postgres psql`
* `\l`
```
CREATE DATABASE town;
\c town

CREATE SCHEMA library;
CREATE sCHEMA police;
CREATE SCHEMA school;

CREATE TABLE school.courses(
course_id text PRIMARY KEY,
title text,
hours integer
);
INSERT INTO school.courses VALUES ('CS3000', 'Docker', 60);

CREATE TABLE school.students(
student_id integer PRIMARY KEY,
name text,
start_year integer
);
INSERT INTO school.students VALUES (13, 'Anna', 2021);

CREATE TABLE school.exams(
student_id integer REFERENCES school.students(student_id),
course_id text REFERENCES school.courses(course_id),
score integer,
CONSTRAINT pk PRIMARY KEY(student_id, course_id)
);
INSERT INTO school.exams VALUES (13, 'CS3000', 80);

SELECT schema_name FROM information_schema.schemata;
```
----
# DBeaver
 * Creo Database come sopra (Se non ho il Database non mi connetto a niente e non funziona da DBeaver)
 * Cambio il file `postgresql.conf` specificando `listen_addresses = '*'`
 * Cambio `pg_hba.conf` mettendo all'ultima riga: `host    all             all             0.0.0.0/0               trust`
 * `sudo systemctl restart postgresql`
 * Poi apro DBeaver e provo a connettermi.
# Dump
* Come Local client scegliere: `/usr/lib/postgresql/11`
