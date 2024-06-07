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

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    c_no text NOT NULL,
    title text,
    hours integer
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (c_no, title, hours) FROM stdin;
CS301	Databases	30
CS305	Networks	60
\.


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (c_no);


--
-- PostgreSQL database dump complete
--

