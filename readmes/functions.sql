select * from pg_catalog.generate_series(1, 51, 13) as x;

-- Dovrebbe fare la lista di tutte le funzioni disponibili.
select proname from pg_catalog.pg_proc order by proname;



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

WIP https://www.w3schools.com/sql/sql_aggregate_functions.asp