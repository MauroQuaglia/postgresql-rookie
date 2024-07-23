* Solito casino dei fusi a vari livelli.
* Da Dbeaver nonostante facessi  `set timezone to 'America/Los_Angeles';` quando poi facevo ` INSERT INTO public.test (my_date, my_time, my_timestamp, my_timestamptz) VALUES(now(), now(), now(), now()); ` non prendeva il fuso.
* Perché DBeaver avrà una sua impostazione.
* Se vado con il  `psql ` invece funziona:
```
dates_and_times=# INSERT INTO public.test (my_date, my_time, my_timestamp, my_timestamptz) VALUES(now(), now(), now(), now());
INSERT 0 1
dates_and_times=# SELECT * from public.test;
  my_date   |     my_time     |        my_timestamp        |        my_timestamptz         
------------+-----------------+----------------------------+-------------------------------
 2024-07-23 | 06:12:00.038636 | 2024-07-23 06:12:00.038636 | 2024-07-23 06:12:00.038636-07    QUI ERANO LE 06:12:00, A Greenwich (+07) CIOE' 13:12:00 UTC
(1 row)


dates_and_times=# SELECT * from public.test;
  my_date   |     my_time     |        my_timestamp        |        my_timestamptz         
------------+-----------------+----------------------------+-------------------------------
 2024-07-23 | 06:12:00.038636 | 2024-07-23 06:12:00.038636 | 2024-07-23 06:12:00.038636-07
(1 row)

dates_and_times=# show timezone;
      TimeZone       
---------------------
 America/Los_Angeles
(1 row)

dates_and_times=# set timezone to 'Europe/Rome';
SET
dates_and_times=# show timezone;
  TimeZone   
-------------
 Europe/Rome
(1 row)

dates_and_times=# SELECT * from public.test;
  my_date   |     my_time     |        my_timestamp        |        my_timestamptz         
------------+-----------------+----------------------------+-------------------------------
 2024-07-23 | 06:12:00.038636 | 2024-07-23 06:12:00.038636 | 2024-07-23 15:12:00.038636+02
(1 row)

```
* Alcuni comandi usati:
```
SHOW TIMEZONE;
set timezone to 'America/Los_Angeles';
INSERT INTO public.test (my_date, my_time, my_timestamp, my_timestamptz) VALUES(now(), now(), now(), now());
select  my_timestamptz from public.test t;
set timezone to 'Europe/Rome'
```
* Altro esempio:
```
postgres=# show timezone;
 TimeZone 
----------
 Etc/UTC
(1 row)

postgres=# set timezone to 'America/Los_Angeles';
SET
postgres=# show timezone;
      TimeZone       
---------------------
 America/Los_Angeles
(1 row)

postgres=# select '2012-03-11 3:10 AM America/Los_Angeles'::timestamptz;
      timestamptz       
------------------------
 2012-03-11 03:10:00-07
(1 row)

postgres=# set timezone to 'Europe/Rome';
SET
postgres=# show timezone;
  TimeZone   
-------------
 Europe/Rome
(1 row)

postgres=# select '2012-03-11 3:10 AM America/Los_Angeles'::timestamptz;
      timestamptz       
------------------------
 2012-03-11 11:10:00+01
(1 row)

```
* Altro esempio:
```
postgres=# select '2012-03-11 12:30 Europe/Rome'::timestamptz;
      timestamptz       
------------------------
 2012-03-11 12:30:00+01 # UTC erano le 11:30:00
(1 row)

postgres=# select '2012-03-11 3:00 AM America/Los_Angeles'::timestamptz;
      timestamptz       
------------------------
 2012-03-11 11:00:00+01 # UTC erano le 10:00:00
(1 row)

postgres=# select '2012-03-11 12:30 Europe/Rome'::timestamptz - '2012-03-11 3:00 AM America/Los_Angeles'::timestamptz as hours;
  hours   
----------
 01:30:00 # UTC 11:30:00 - UTC 10:00:00 = 01:30:00
(1 row)
```

* Altro esempio:
```
select '2012-03-11 6:00 AM America/Los_Angeles'::timestamptz at time zone 'Europe/Rome';
      timezone       
---------------------
 2012-03-11 14:00:00
(1 row)
A Los_Angeles erano le 6 del mattino, a Greenwich le 13 (+7), da noi le 14 (+1 ancora)


postgres=# select '2012-03-11 6:00 AM America/Los_Angeles'::timestamptz at time zone 'US/Samoa';
      timezone       
---------------------
 2012-03-11 02:00:00
(1 row)
A Los_Angeles erano le 6 del mattino, a Greenwich le 13 (+7), a Samoa (-11) le 02:00
```