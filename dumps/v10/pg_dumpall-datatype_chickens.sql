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

-- Dumped from database version 10.23 (Debian 10.23-4.pgdg110+1)
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

-- Dumped from database version 10.23 (Debian 10.23-4.pgdg110+1)
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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: chickens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chickens (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.chickens OWNER TO postgres;

--
-- Name: ducks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ducks (
    id integer NOT NULL,
    chickens public.chickens[]
);


ALTER TABLE public.ducks OWNER TO postgres;

--
-- Data for Name: chickens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chickens (id, name) FROM stdin;
2	gamba di ferro
1	paparino
\.


--
-- Data for Name: ducks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ducks (id, chickens) FROM stdin;
1	{"(2,\\"gamba di ferro\\")"}
\.


--
-- Name: chickens chickens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chickens
    ADD CONSTRAINT chickens_pkey PRIMARY KEY (id);


--
-- Name: ducks ducks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ducks
    ADD CONSTRAINT ducks_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

