--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;






\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23 (Debian 10.23-3.pgdg110+2)
-- Dumped by pg_dump version 11.22 (Debian 11.22-4.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23 (Debian 10.23-3.pgdg110+2)
-- Dumped by pg_dump version 11.22 (Debian 11.22-4.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: my_fts; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA my_fts;


ALTER SCHEMA my_fts OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: fts_test; Type: TABLE; Schema: my_fts; Owner: postgres
--

CREATE TABLE my_fts.fts_test (
    id integer NOT NULL,
    row_text_1 text,
    row_text_2 text,
    fts_text tsvector
);


ALTER TABLE my_fts.fts_test OWNER TO postgres;

--
-- Name: fts_test_id_seq; Type: SEQUENCE; Schema: my_fts; Owner: postgres
--

CREATE SEQUENCE my_fts.fts_test_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_fts.fts_test_id_seq OWNER TO postgres;

--
-- Name: fts_test_id_seq; Type: SEQUENCE OWNED BY; Schema: my_fts; Owner: postgres
--

ALTER SEQUENCE my_fts.fts_test_id_seq OWNED BY my_fts.fts_test.id;


--
-- Name: fts_test id; Type: DEFAULT; Schema: my_fts; Owner: postgres
--

ALTER TABLE ONLY my_fts.fts_test ALTER COLUMN id SET DEFAULT nextval('my_fts.fts_test_id_seq'::regclass);


--
-- Data for Name: fts_test; Type: TABLE DATA; Schema: my_fts; Owner: postgres
--

COPY my_fts.fts_test (id, row_text_1, row_text_2, fts_text) FROM stdin;
1	ciccio cicco nonna papera	pippo pluto nonna papera	'ciccio':1A 'cicco':2A 'nonna':3A,7B 'papera':4A,8B 'pippo':5B 'pluto':6B
2	ciccio cicco nonnina	pippo	'ciccio':1A 'cicco':2A 'nonnina':3A 'pippo':4B
3	carlo carlo carlo carlo	pippo	'carlo':1A,2A,3A,4A 'pippo':5B
\.


--
-- Name: fts_test_id_seq; Type: SEQUENCE SET; Schema: my_fts; Owner: postgres
--

SELECT pg_catalog.setval('my_fts.fts_test_id_seq', 3, true);


--
-- Name: fts_test fts_test_pkey; Type: CONSTRAINT; Schema: my_fts; Owner: postgres
--

ALTER TABLE ONLY my_fts.fts_test
    ADD CONSTRAINT fts_test_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

