# Inserimento di un po' di dati iniziali:
* `sudo -u postgres psql`
* `\l`
```
CREATE DATABASE town TEMPLATE template0;
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
# Creazione di una vista:
```
  CREATE VIEW school.students_courses AS
  SELECT
  school.students.name AS student_name,
  school.courses.title AS course_title,
  school.exams.score as student_score
  FROM
  school.exams
  JOIN
  school.students ON school.students.student_id = school.exams.student_id
  JOIN
  school.courses ON school.courses.course_id = school.exams.course_id;
```
----
# Creazione di una estensione e suo utilizzo:
* Dal database `town` e da console SQL: `CREATE EXTENSION unaccent CASCADE;`
* Se poi faccio una query: `select * from school.students where unaccent(name) ilike '%e%';`
* Le estensioni sono salvate sotto public mapoi sono disponibili ancheper altri schemi.
---
# Creazione di una funzione:
* Esempio di creazione partendo dallo schema school:
```
CREATE OR REPLACE FUNCTION school.mq_trim(input_string text)
RETURNS text
LANGUAGE plpgsql
AS $function$
BEGIN
RETURN TRIM(BOTH FROM input_string);
END;
$function$
;
```
* Se poi faccio una query: `select mq_trim('   aaa   ');`
----
# Connettersi a un file
* Esempio (configurare postgres per loggare su un CSV e poi vederlo come tabella)
* https://www.postgresql.org/docs/current/runtime-config-logging.html#RUNTIME-CONFIG-LOGGING-CSVLOG
* https://www.postgresql.org/docs/current/file-fdw.html
* Per una prova semplice:
```
CREATE EXTENSION file_fdw;
CREATE SERVER file_server FOREIGN DATA WRAPPER file_fdw;
CREATE FOREIGN TABLE school.teachers (course_id TEXT, name TEXT, notes TEXT)
SERVER file_server
OPTIONS (filename '/var/lib/postgresql/10/main/teachers.csv', format 'csv', header 'true');
```
----
# Esempio di creazione di una vista materializzata
```
CREATE MATERIALIZED VIEW school.teachers_courses AS
select
school.courses.course_id AS course_id,
school.courses.title AS course_title,
school.teachers.name AS teacher_name,
school.teachers.notes AS teacher_notes
FROM
school.courses
JOIN
school.teachers ON school.courses.course_id = school.teachers.course_id;
```
----
# Esempio di una creazione di un trigger:
```
# Si definisce una funzione
CREATE OR REPLACE FUNCTION refresh_teachers_courses()
RETURNS trigger AS $$
BEGIN
REFRESH MATERIALIZED VIEW school.teachers_courses;
RETURN NULL;  -- I trigger AFTER non devono restituire nulla
END;
$$ LANGUAGE plpgsql;

# ...e la si associa a un trigger.
CREATE TRIGGER refresh_teachers_courses_trigger
AFTER INSERT OR UPDATE OR DELETE ON school.courses
FOR EACH STATEMENT
EXECUTE PROCEDURE refresh_teachers_courses();
```
---
# Esempio di creazione di un database per un utente
* Entro come superuser postgres:
    * `sudo -u postgres psql`
* Creo un utente __admin__ come superuser. Se faccio solo un utente normale diventa poi complicato dargli tutti i permessi. 
* Inoltre bisogna considerare che dovrà avere permessi anche sulle cose create in futuro. 
* Con il __superuser__ ci risparmiamo un sacco di cose.
    * `CREATE ROLE admin LOGIN PASSWORD 'buddy' SUPERUSER;`
* Creo un database __doggie_spa__ e lo assegno all'utente __admin__.
    * `CREATE DATABASE doggie_spa WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8' OWNER admin;`
* Mi collego al nuovo database:
  * `\c doggie_spa`
* Creo gli schema che mi interessano;
    * `CREATE SCHEMA dogs;`
    * `CREATE SCHEMA customers;`
    * `CREATE SCHEMA extensions;` (Qui dentro verranno installate le eventuali estensioni del database)
    * Lo schema `public` è di defaul; (In public ci vanno le tabelle condivise e le cose comuni)
* Una volta fatto devo sistemare il file `pg_hba.conf` per l'accesso del nuovo utente al database.
---
# Estensioni
* Molte sono installate di default sul server.
* Sempre meglio comunque installare anche `postgresql-contrib`.
* Per vedere tutte le estensioni installate sul server:
  * `SELECT * FROM pg_available_extensions ORDER BY name`;
  * Si vedono anche da DBeaver
  * Quelle attualmenye installate: `SELECT * FROM pg_available_extensions where installed_version IS NOT NULL ORDER BY name;`
* Vado sul DB che mi interessa e installo una estensione nello schema extensions.
  * `create extension unaccent schema extensions;`
* Le extension le posso usare da qualunque altro schema ma vanno opportunamente richiamate. Per esempio:
  * `select * from doggie_spa.dogs.breeds where doggie_spa.extensions.unaccent(breed) = 'bulldog';`
---