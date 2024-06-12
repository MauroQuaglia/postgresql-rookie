# Inserimento di un po' di dati iniziali:
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