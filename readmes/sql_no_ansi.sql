-- In PostgreSQL, la clausola DISTINCT ON viene utilizzata per ottenere un solo record per ogni valore
-- distintivo di una o più colonne specificate, mantenendo il controllo su quale riga tra quelle con lo stesso
-- valore debba essere restituita.
-- Questa clausola è utile quando si vuole ottenere il primo risultato (o l'ultimo, a seconda dell'ordinamento)
-- per ciascun gruppo di righe che condividono gli stessi valori in determinate colonne.
-- In altre parole, DISTINCT ON permette di eliminare i duplicati basandosi su una o più colonne,
-- mantenendo solo una delle righe duplicate secondo un criterio di ordinamento specificato.

SELECT DISTINCT ON (merchant_name)
    merchant_name, review_title
FROM merchant_reviews
ORDER BY merchant_name ASC, review_title DESC;
-- Una review per merchant, ma quella review è la prima o l'ultima in ordine alfabetico in base all'ordinamento.

-- se usassi questa non riuscirei a fare la stessa cosa.
SELECT DISTINCT
    merchant_name, review_title
FROM merchant_reviews
ORDER BY merchant_name ASC, review_title DESC;


--------------------------------------------------------------------------------------------------------
-- Anche LIMIT non è standard
-- no standard
SELECT * FROM public.merchant_reviews LIMIT 5;

-- standard
SELECT * FROM public.merchant_reviews FETCH FIRST 5 ROWS ONLY;

-- no standard
SELECT * FROM public.merchant_reviews LIMIT 5 OFFSET 1;

-- standard
SELECT * FROM public.merchant_reviews OFFSET 1 FETCH FIRST 5 ROWS ONLY;


-------------------------------------------
--standard
SELECT CAST('2011-01-23' AS timestamptz)

--shortcut
SELECT '2011-01-09'::timestamptz;

--------------------------------------------------------

-- VALUES permette di fare tabelle virtuali
SELECT * FROM (
                  VALUES
                      ('a', 'b', 100),
                      ('a', 'b', 100),
                      ('a', 'b', 100)
              ) AS tabella(fir,sec,thi);

-- quindi posso provare a


------------------------------------------

-- LIKE (~~) è standard
-- ILIKE (~~*) non lo è


-------------------------------

-- ANY è uno standard.
-- Esempio pratico: SELECT * FROM public.merchant_reviews WHERE merchant_name ILIKE ANY(ARRAY['%_pm%', '%poce']);

------------------

-- Bello lo using... comodo, la query giusto per vedere se funziona.
DELETE FROM merchant_reviews mr
USING merchant_reviews_subratings AS mrs
WHERE mr.review_global_rating = mrs.rating_value AND mrs.rating_value = 5;


-- E anche il RETURNING è comodo.
DELETE FROM merchant_reviews WHERE id_review = 1;
DELETE FROM merchant_reviews WHERE id_review = 2 RETURNING *;
DELETE FROM merchant_reviews WHERE id_review = 4 RETURNING username;


----------------
-- Insert or nothing
INSERT INTO public.aggregated_fpns (id, puid, fpn, created_at, updated_at) VALUES(10, 'a', 'b', NOW(), NOW()) ON CONFLICT DO NOTHING;

-- Insert or update (UPSERT)
INSERT INTO public.aggregated_fpns (id, puid, fpn, created_at, updated_at) VALUES(10, 'a', 'b', NOW(), NOW())
    ON CONFLICT(id) DO UPDATE
        SET puid = ECLUDED.puid;

----------------------------------
--escape
SELECT 'It''s time o go!';
-- SELECT $$It's time o go!$$;

----------------------------------------------
-- FILTER
SELECT
    AVG(review_global_rating) FILTER (WHERE merchant_name = 'x') AS x,
    AVG(review_global_rating) FILTER (WHERE merchant_name = 'y') AS y
FROM merchant_reviews;

--------------------
-- la parte delle query "window" è interessante ma da approfondire
SELECT merchant_name, review_global_rating, AVG(review_global_rating) OVER()
FROM merchant_reviews;

SELECT AVG(review_global_rating) FROM merchant_reviews mr WHERE merchant_name = 'x';

SELECT merchant_name, review_global_rating, AVG(review_global_rating) OVER(PARTITION BY merchant_name = 'x')
FROM merchant_reviews;

