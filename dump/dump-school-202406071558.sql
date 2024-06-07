--
-- PostgreSQL database dump
--

-- Dumped from database version 10.23 (Debian 10.23-3.pgdg110+2)
-- Dumped by pg_dump version 11.22 (Debian 11.22-4.pgdg110+1)

-- Started on 2024-06-07 15:58:23 CEST

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

DROP DATABASE school;
--
-- TOC entry 2936 (class 1262 OID 16384)
-- Name: school; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE school WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE school OWNER TO postgres;

\connect school

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
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 2937 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 196 (class 1259 OID 16385)
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    c_no text NOT NULL,
    title text,
    hours integer
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- TOC entry 2930 (class 0 OID 16385)
-- Dependencies: 196
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.courses VALUES ('CS301', 'Databases', 30);
INSERT INTO public.courses VALUES ('CS305', 'Networks', 60);


--
-- TOC entry 2808 (class 2606 OID 16392)
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (c_no);


-- Completed on 2024-06-07 15:58:23 CEST

--
-- PostgreSQL database dump complete
--

