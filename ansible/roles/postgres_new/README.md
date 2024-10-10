# Esempio di utilizzo del ruolo
```   
    - role: "nautilus.postgres"
      tags: "postgres"

      # Versione di PostgreSQL desiderata.
      postgres_version: "15"

      # Configurazione del file pg_hba.conf.
      postgres_authentications_local: "mauro"
      postgres_authentications_host:
        - { user: "mauro", address: "11.24.33.1/20", notes: "my_net" }

      # Creazione dei ruoli su database.
      postgres_roles:
        - { user: "mauro", roles: "CREATEDB,SUPERUSER", password: "changeme" }

      # Se non metto nulla c'è un default.
      # Altrimenti posso passare un file pesonalizzato. 
      postgres_autoconf_src_path: "{{ project_dir }}/ansible/files/"
```