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
-- Name: dates_and_times; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE dates_and_times WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE dates_and_times OWNER TO postgres;

\connect dates_and_times

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
-- Name: test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.test (
    my_date date,
    my_time time without time zone,
    my_timestamp timestamp without time zone,
    my_timestamptz timestamp with time zone
);


ALTER TABLE public.test OWNER TO postgres;

--
-- Data for Name: test; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.test (my_date, my_time, my_timestamp, my_timestamptz) FROM stdin;
2012-12-25	\N	\N	\N
2012-12-26	\N	\N	\N
2012-12-31	\N	\N	\N
2012-12-31	\N	\N	\N
2012-12-31	12:00:00	\N	\N
2012-12-31	12:00:00	2012-12-31 15:00:00	\N
2012-12-31	12:00:00	2012-12-31 00:00:00	\N
2012-12-31	12:00:00	2012-12-31 15:00:00	2012-12-31 22:00:00+00
2012-12-31	12:00:00	2012-12-31 15:00:00	2012-12-31 21:00:45+00
\.


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
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

