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
