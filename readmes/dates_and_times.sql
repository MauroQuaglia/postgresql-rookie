INSERT INTO public.test (my_date, my_time, my_timestamp, my_timestamptz) VALUES(now(), now(), now(), now());
SHOW TIMEZONE;

--esempio di quey sql complicata
select merchant_name,
       (merchant_name || ' ' ||username) as meruser,
       date_part('day', (review_date_insert - NOW())) as days_ago
       from merchant_reviews mr order by days_ago;