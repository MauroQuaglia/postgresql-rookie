-- Alcune query SQL di prova.

SELECT MAX(id_review) FROM public.merchant_reviews;
SELECT MIN(id_review) FROM public.merchant_reviews;

SELECT COUNT(*) FROM public.merchant_reviews;
SELECT COUNT(id_review) FROM public.merchant_reviews;

SELECT SUM(id_review) FROM public.merchant_reviews;
SELECT AVG(id_review) FROM public.merchant_reviews;


SELECT MAX(id_review) FROM public.merchant_reviews;
SELECT MIN(id_review) FROM public.merchant_reviews;

SELECT COUNT(*) FROM public.merchant_reviews;
SELECT COUNT(id_review) FROM public.merchant_reviews;

SELECT SUM(id_review) FROM public.merchant_reviews;
SELECT AVG(id_review) FROM public.merchant_reviews;



-- The percent sign % represents zero, one, or multiple characters
SELECT * FROM public.merchant_reviews WHERE merchant_name LIKE '%shop';

-- The underscore sign _ represents one, single character
SELECT * FROM public.merchant_reviews WHERE merchant_name LIKE '_____shop';

SELECT * FROM public.merchant_reviews WHERE merchant_name IN ('mediashop', 'apmshop');

SELECT * FROM public.merchant_reviews WHERE id_review BETWEEN 1 AND 20;

SELECT merchant_name AS mn FROM public.merchant_reviews;

-- INNER JOIN = intersezione tra le due tabelle
SELECT merchant_reviews.merchant_name AS merchant, merchant_replies."content" AS reply
FROM merchant_reviews INNER JOIN merchant_replies ON merchant_reviews.id_review = merchant_replies.review_id;

-- LEFT JOIN = LEFT OUTER JOIN = prendo tutto della prima
SELECT merchant_reviews.id_review, merchant_reviews.merchant_name, merchant_replies."content"
FROM merchant_reviews LEFT JOIN merchant_replies ON merchant_reviews.id_review = merchant_replies.review_id;

-- RIGHT JOIN = RIGHT OUTER JOIN = prendo tutto della seconda
SELECT merchant_reviews.id_review, merchant_reviews.merchant_name, merchant_replies."content"
FROM merchant_reviews RIGHT JOIN merchant_replies ON merchant_reviews.id_review = merchant_replies.review_id;

-- FULL JOIN = FULL OUTER JOIN = unione tra le due tabelle
SELECT merchant_reviews.merchant_name AS merchant, merchant_replies."content" AS reply
FROM merchant_reviews FULL JOIN merchant_replies ON merchant_reviews.id_review = merchant_replies.review_id;

-- UNION o UNION ALL
SELECT merchant_reviews.review_content AS mrrc FROM public.merchant_reviews
UNION ALL
SELECT product_reviews."content" AS prc FROM public.product_reviews;
