* Alcunq query utili:
  `SELECT cfgname FROM pg_ts_config;`
  `SHOW default_text_search_config;`

CREATE TABLE fts_test(id SERIAL PRIMARY KEY, row_text_1 TEXT, row_text_2 TEXT, fts_text TSVECTOR);
INSERT INTO fts_test(row_text_1, row_text_2) VALUES ('ciccio cicco nonna papera', 'pippo pluto nonna papera');
INSERT INTO fts_test(row_text_1, row_text_2) VALUES ('ciccio cicco nonnina', 'pippo');
INSERT INTO fts_test(row_text_1, row_text_2) VALUES ('', 'pippo');
UPDATE fts_test SET fts_text = setweight(to_tsvector(row_text_1), 'A') || setweight(to_tsvector(row_text_2), 'B');

SELECT to_tsquery('english', 'business & analytics | anaytics');
SELECT to_tsquery('italian', 'business & analytics | anaytics');
SELECT 'bus & aaa'::tsquery;

SELECT * FROM fts_test;
SELECT row_text_1 FROM fts_test WHERE fts_text @@ to_tsquery('carlo & nonna');
SELECT row_text_1 FROM fts_test WHERE fts_text @@ to_tsquery('carlo | nonna');

SELECT row_text_1 AS row, ts_rank(fts_text, ts) AS rank
FROM fts_test, to_tsquery('carlo | nonna') AS ts
WHERE fts_text @@ ts
ORDER BY RANK DESC ;

Bisognerebbe poi creare un trigger di modo che tutte le volte che un testo row viene aggiornato il campo fts_vector venga re-indicizato.
