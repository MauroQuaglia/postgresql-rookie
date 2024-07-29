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

Da chatGPT:
Puoi utilizzare il Full Text Search (FTS) di PostgreSQL al posto di Solr per molte esigenze di ricerca full-text. 

PostgreSQL offre una potente funzionalità di ricerca full-text integrata, 
che è in grado di soddisfare molteplici requisiti di ricerca per applicazioni di piccole e medie dimensioni.
Tuttavia, ci sono alcune considerazioni da fare riguardo ai vantaggi e alle limitazioni di entrambe le soluzioni.

Vantaggi dell'uso di PostgreSQL FTS
Integrazione: Essendo integrato direttamente nel database, non c'è bisogno di configurare e mantenere un sistema separato come Solr.
Consistenza dei Dati: Le ricerche full-text in PostgreSQL sono sempre coerenti con i dati più recenti, senza necessità di sincronizzazioni tra database e un motore di ricerca esterno.
Semplicità: Configurare e utilizzare la ricerca full-text in PostgreSQL può essere più semplice rispetto a configurare un server Solr.
Performance Accettabile: Per molte applicazioni di piccole e medie dimensioni, le prestazioni della ricerca full-text di PostgreSQL sono sufficienti.
Costo: Può essere più economico non dover mantenere un'infrastruttura separata per il motore di ricerca.

Limitazioni di PostgreSQL FTS
Scalabilità: Per applicazioni molto grandi o con elevate esigenze di ricerca, Solr (o Elasticsearch) può offrire una scalabilità migliore.
Funzionalità Avanzate: Solr offre molte funzionalità avanzate come il clustering, il faceting, le ricerche distribuite, ecc., che possono non essere così potenti o semplici da implementare in PostgreSQL.
Ottimizzazioni di Ricerca: Solr è progettato specificamente per la ricerca full-text e può gestire query complesse e ad alto volume più efficientemente rispetto a PostgreSQL.
