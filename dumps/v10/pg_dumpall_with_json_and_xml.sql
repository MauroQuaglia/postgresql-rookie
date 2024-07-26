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
-- Name: json_test; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE json_test WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE json_test OWNER TO postgres;

\connect json_test

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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: persons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persons (
    id integer NOT NULL,
    person json
);


ALTER TABLE public.persons OWNER TO postgres;

--
-- Name: persons_b; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persons_b (
    id integer NOT NULL,
    person jsonb
);


ALTER TABLE public.persons_b OWNER TO postgres;

--
-- Name: persons_b_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.persons_b_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persons_b_id_seq OWNER TO postgres;

--
-- Name: persons_b_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.persons_b_id_seq OWNED BY public.persons_b.id;


--
-- Name: persons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.persons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persons_id_seq OWNER TO postgres;

--
-- Name: persons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.persons_id_seq OWNED BY public.persons.id;


--
-- Name: persons_xml; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persons_xml (
    id integer NOT NULL,
    person xml
);


ALTER TABLE public.persons_xml OWNER TO postgres;

--
-- Name: persons_xml_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.persons_xml_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.persons_xml_id_seq OWNER TO postgres;

--
-- Name: persons_xml_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.persons_xml_id_seq OWNED BY public.persons_xml.id;


--
-- Name: persons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons ALTER COLUMN id SET DEFAULT nextval('public.persons_id_seq'::regclass);


--
-- Name: persons_b id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons_b ALTER COLUMN id SET DEFAULT nextval('public.persons_b_id_seq'::regclass);


--
-- Name: persons_xml id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons_xml ALTER COLUMN id SET DEFAULT nextval('public.persons_xml_id_seq'::regclass);


--
-- Data for Name: persons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons (id, person) FROM stdin;
6	{\n  "friends": [\n    {\n      "name": "Ciro",\n      "age": 31,\n      "email": "alice@example.com"\n    },\n    {\n      "name": "Bob",\n      "age": 25,\n      "email": "bob@example.com"\n    }\n  ]\n}\n
7	{\n  "friends": [\n    {\n      "name": "Ciro",\n      "age": 31,\n      "email": "alice@example.com"\n    },\n    {\n      "name": "Bob",\n      "age": 25,\n      "email": "bob@example.com"\n    }\n  ]\n}\n
8	{\n  "friends": [\n    {\n      "name": "Ciro",\n      "age": 31,\n      "email": "alice@example.com"\n    },\n    {\n      "name": "Bob",\n      "age": 25,\n      "email": "bob@example.com"\n    }\n  ]\n}\n
\.


--
-- Data for Name: persons_b; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons_b (id, person) FROM stdin;
1	{"address": "Via le Mani", "friends": [{"age": 31, "name": "Ciro", "email": "alice@example.com"}, {"age": 25, "name": "Bob", "email": "bob@example.com"}]}
\.


--
-- Data for Name: persons_xml; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persons_xml (id, person) FROM stdin;
1	<library>\n    <book id="bk101">\n        <author>Gambardella, Matthew</author>\n        <title>XML Developer Guide</title>\n        <genre>Computer</genre>\n        <price>44.95</price>\n        <publish_date>2000-10-01</publish_date>\n        <description>An in-depth look at creating applications \n        with XML.</description>\n    </book>\n    <book id="bk102">\n        <author>Ralls, Kim</author>\n        <title>Midnight Rain</title>\n        <genre>Fantasy</genre>\n        <price>5.95</price>\n        <publish_date>2000-12-16</publish_date>\n        <description>A former architect battles corporate zombies, \n        an evil sorceress, and her own childhood to become queen \n        of the world.</description>\n    </book>\n    <book id="bk103">\n        <author>Corets, Eva</author>\n        <title>Maeve Ascendant</title>\n        <genre>Fantasy</genre>\n        <price>5.95</price>\n        <publish_date>2000-11-17</publish_date>\n        <description>After the collapse of a nanotechnology \n        society in England, the young survivors lay the \n        foundation for a new society.</description>\n    </book>\n</library>\n
\.


--
-- Name: persons_b_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persons_b_id_seq', 1, true);


--
-- Name: persons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persons_id_seq', 8, true);


--
-- Name: persons_xml_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.persons_xml_id_seq', 1, true);


--
-- Name: persons_b persons_b_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons_b
    ADD CONSTRAINT persons_b_pkey PRIMARY KEY (id);


--
-- Name: persons persons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons
    ADD CONSTRAINT persons_pkey PRIMARY KEY (id);


--
-- Name: persons_xml persons_xml_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persons_xml
    ADD CONSTRAINT persons_xml_pkey PRIMARY KEY (id);


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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

