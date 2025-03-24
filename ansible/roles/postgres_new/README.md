# Ruolo nautilus.postgres
* Fa il setup di PostgreSQL:
  * Crea i ruoli su database se necessario.
  * Di default utilizza il file `postgresql.auto.conf`, ma se voglio una configurazione personalizzata glielo posso passare da fuori.
  * Anche il `pg_hba.conf` e completamente personalizzabile attraverso delle variabili.  

# Ruolo originale
* Questo ruolo è stato sviluppato Mauro Quaglia.

# Esempio di utilizzo del ruolo
```   
    - role: "postgres"
      tags: "postgres"

      # Versione di PostgreSQL desiderata.
      postgres_version: "15"

      # Configurazione del file pg_hba.conf.
      postgres_authentications_local: "mquser"
      postgres_authentications_host:
        - { user: "mquser", address: "11.20.77.0/20", notes: "staging_1" }
        - { user: "mquser", address: "12.24.11.0/20", notes: "staging_2 }

      # Creazione dei ruoli su database.
      postgres_roles:
        - { user: "mquser", roles: "CREATEDB,SUPERUSER", password: "changeme" }
        - { user: "mquser_test", roles: "LOGIN", password: "changemetest" }

      # Se non metto nulla c'è un default.
      # Altrimenti posso passare un file pesonalizzato. 
      postgres_autoconf_src_path: "{{ project_dir }}/ansible/files/"
```