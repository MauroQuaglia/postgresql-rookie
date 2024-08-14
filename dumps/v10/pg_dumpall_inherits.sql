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
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    log_id integer NOT NULL,
    user_name character varying(50),
    description text,
    log_ts timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- Name: logs2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs2 (
    log_id2 integer NOT NULL,
    user_name2 character varying(50),
    description2 text,
    log_ts2 timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.logs2 OWNER TO postgres;

--
-- Name: logs2_log_id2_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.logs2 ALTER COLUMN log_id2 ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.logs2_log_id2_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: logs_2011; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs_2011 (
    CONSTRAINT chk_y2011 CHECK (((log_ts >= '2010-12-31 23:00:00+00'::timestamp with time zone) AND (log_ts < '2011-12-31 23:00:00+00'::timestamp with time zone)))
)
INHERITS (public.logs);


ALTER TABLE public.logs_2011 OWNER TO postgres;

--
-- Name: logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_log_id_seq
    AS integer
    START WITH 4
    INCREMENT BY 2
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.logs_log_id_seq OWNER TO postgres;

--
-- Name: logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_log_id_seq OWNED BY public.logs.log_id;


--
-- Name: logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN log_id SET DEFAULT nextval('public.logs_log_id_seq'::regclass);


--
-- Name: logs_2011 log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs_2011 ALTER COLUMN log_id SET DEFAULT nextval('public.logs_log_id_seq'::regclass);


--
-- Name: logs_2011 log_ts; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs_2011 ALTER COLUMN log_ts SET DEFAULT now();


--
-- Data for Name: logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs (log_id, user_name, description, log_ts) FROM stdin;
1			2024-08-05 08:40:43.452126+00
5	zz	zzzz	2024-08-05 08:43:26.5893+00
7	zz	zzzz	2024-08-05 08:43:30.138842+00
9	zz	zzzz	2024-08-05 08:43:30.7239+00
25	PADRE	PADRE	2011-09-08 22:00:00+00
27	PADRE	PADRE	2011-09-08 22:00:00+00
31	PADRE	PADRE	2011-09-08 22:00:00+00
\.


--
-- Data for Name: logs2; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs2 (log_id2, user_name2, description2, log_ts2) FROM stdin;
3			2024-08-05 08:40:59.542568+00
\.


--
-- Data for Name: logs_2011; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.logs_2011 (log_id, user_name, description, log_ts) FROM stdin;
17	a	a	2011-08-05 08:53:39.177157+00
19	a	a	2011-08-08 22:00:00+00
21	a	a	2011-08-08 22:00:00+00
23	a	a	2011-08-08 22:00:00+00
29	ab	ab	2011-08-08 22:00:00+00
\.


--
-- Name: logs2_log_id2_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs2_log_id2_seq', 1, false);


--
-- Name: logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.logs_log_id_seq', 31, true);


--
-- Name: logs2 logs2_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs2
    ADD CONSTRAINT logs2_pkey PRIMARY KEY (log_id2);


--
-- Name: logs_2011 logs_2011_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs_2011
    ADD CONSTRAINT logs_2011_pkey PRIMARY KEY (log_id);


--
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (log_id);


--
-- Name: idx_logs_log_ts; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logs_log_ts ON public.logs USING btree (log_ts);


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--
