select * from pg_catalog.generate_series(1, 51, 13) as x;

-- Dovrebbe fare la lista di tutte le funzioni disponibili.
select proname from pg_catalog.pg_proc order by proname;

-- array
SELECT arr[2:4] FROM (SELECT ARRAY[1, 2, 3, 4, 5, 6] AS arr) AS subquery;


-- https://www.postgresql.org/docs/10/functions-string.html
-- 00abc
select lpad('abc', 5, '0');

-- abc00
select rpad('abc', 5, '0');

select
    lpad('abc', 5, '0') as lp,
    rpad('abc', 5, '0') as rp;

-- Generare stringhe
select
    repeat('a', 3) || i || repeat('b', 3) as result,
    i as index from pg_catalog.generate_series(0, 200,5) as i;

-- Così è anche più chiara
select
    repeat('a', 3) || x || repeat('b', 3) as result
    from pg_catalog.generate_series(0, 200,5) as x;


-- altri esempi di funzioni
select split_part('abc.123.def', '.', 2) as result;
select string_to_array('abc.123.def', '.') as result;
select unnest(string_to_array('abc.123.def', '.')) as result;

-- esempio
select substring('GTAT' from i for 1) from generate_series(1, length('GTAT'), 1) as i;

select regexp_replace(regexp_replace('GTAT', 'T', 'X', 'g'), 'G', 'H', 'g')


SELECT ARRAY[1, 2, 3] AS n;
n
---------
{1,2,3}
(1 row)


select array(select generate_series(1,10,2));
array
-------------
{1,3,5,7,9}

 postgres=# select '{Alex,Piero}'::text[] as name;
name
--------------
{Alex,Piero}


select * from (values ('{A,B}'::text[])) as txt;
column1
---------
{A,B}
(1 row)


postgres=# select '{AAA,BBB}'::text[] as name;
name
-----------
{AAA,BBB}
(1 row)

postgres=# select unnest('{AAA,BBB}'::text[]) as name;
name
------
AAA
BBB


--esempio di quey sql complicata
select merchant_name,
       (merchant_name || ' ' ||username) as meruser,
       date_part('day', (review_date_insert - NOW())) as days_ago
from merchant_reviews mr order by days_ago;


SELECT * FROM public.merchant_reviews;

SELECT username, review_title FROM public.merchant_reviews;

SELECT DISTINCT username FROM public.merchant_reviews;
SELECT DISTINCT merchant_name, username FROM public.merchant_reviews; -- Le coppie (merchant_name, username) distinte

SELECT * FROM public.merchant_reviews WHERE username = 'username';
SELECT * FROM public.merchant_reviews WHERE NOT username = 'username';

SELECT * FROM public.merchant_reviews ORDER BY review_title ASC, id_review DESC;
SELECT * FROM public.merchant_reviews ORDER BY review_title DESC, id_review ASC;

SELECT * FROM public.merchant_reviews WHERE (username = 'username' OR review_title = 'review 0');

UPDATE public.merchant_reviews
SET review_title = 'Juan'
WHERE review_title = 'review 22';


-- Range

SELECT '[1979-01-07,1988-05-19]'::daterange;
-- Viene canonicizzato: [1979-01-07,1988-05-20)

SELECT '(0,)'::int8range;
-- Diventa [1,)

-- Con il costruttore
SELECT daterange('1979-01-07','1988-05-19', '[]');

-- Verificare che la data sia in un range.
SELECT '[1979-01-07,2030-05-19]'::daterange @> CURRENT_DATE AS b;

-- esempio di creazione di una tabella con un campo JSONe dei dati
CREATE TABLE persons(id serial PRIMARY KEY, person json);
INSERT INTO persons (person) VALUES ('{
  "friends": [
    {
      "name": "Ciro",
      "age": 31,
      "email": "alice@example.com"
    },
    {
      "name": "Bob",
      "age": 25,
      "email": "bob@example.com"
    }
  ]
}
');
SELECT person -> 'friends' AS friends FROM persons;
SELECT person -> 'friends' -> 0 ->> 'name' AS name FROM persons;
SELECT json_array_elements(person -> 'friends') ->> 'name' AS name FROM persons;

-- JSONB
CREATE TABLE public.persons_b (
    id serial4 NOT NULL,
    person jsonb NULL,
    CONSTRAINT persons_b_pkey PRIMARY KEY (id)
);
INSERT INTO persons_b (person) VALUES ('{
  "friends": [
    {
      "name": "Ciro",
      "age": 31,
      "email": "alice@example.com"
    },
    {
      "name": "Bob",
      "age": 25,
      "email": "bob@example.com"
    }
  ]
}
');

SELECT person -> 'friends' -> 0 ->> 'name' AS name FROM persons;

CREATE TABLE public.persons_b (
                                  id serial4 NOT NULL,
                                  person jsonb NULL,
                                  CONSTRAINT persons_b_pkey PRIMARY KEY (id)
);
INSERT INTO persons_b (person) VALUES ('{
  "friends": [
    {
      "name": "Ciro",
      "age": 31,
      "email": "alice@example.com"
    },
    {
      "name": "Bob",
      "age": 25,
      "email": "bob@example.com"
    }
  ]
}
');

SELECT person AS j FROM persons p WHERE id = 6;
SELECT person AS jb FROM persons_b WHERE id = 1;



UPDATE persons_b SET person = person || '{"address": "Via le Mani"}'::jsonb RETURNING person;



CREATE TABLE public.persons_xml (
                                    id serial4 NOT NULL,
                                    person xml NULL,
                                    CONSTRAINT persons_xml_pkey PRIMARY KEY (id)
);
INSERT INTO public.persons_xml(person) VALUES('<?xml version="1.0" encoding="UTF-8"?>
<library>
  <book id="bk101">
    <author>Gambardella, Matthew</author>
    <title>XML Developer Guide</title>
    <genre>Computer</genre>
    <price>44.95</price>
    <publish_date>2000-10-01</publish_date>
    <description>An in-depth look at creating applications
      with XML.</description>
  </book>
  <book id="bk102">
    <author>Ralls, Kim</author>
    <title>Midnight Rain</title>
    <genre>Fantasy</genre>
    <price>5.95</price>
    <publish_date>2000-12-16</publish_date>
    <description>A former architect battles corporate zombies,
      an evil sorceress, and her own childhood to become queen
      of the world.</description>
  </book>
  <book id="bk103">
    <author>Corets, Eva</author>
    <title>Maeve Ascendant</title>
    <genre>Fantasy</genre>
    <price>5.95</price>
    <publish_date>2000-11-17</publish_date>
    <description>After the collapse of a nanotechnology
      society in England, the young survivors lay the
      foundation for a new society.</description>
  </book>
</library>
');

SELECT
    person,
    xpath('/library/book/author/text()', person)::text AS author
FROM
    public.persons_xml;


