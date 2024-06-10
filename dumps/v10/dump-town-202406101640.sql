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
-- Name: town; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE town WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';


ALTER DATABASE town OWNER TO postgres;

\connect town

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
-- Name: library; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA library;


ALTER SCHEMA library OWNER TO postgres;

--
-- Name: police; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA police;


ALTER SCHEMA police OWNER TO postgres;

--
-- Name: school; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA school;


ALTER SCHEMA school OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: courses; Type: TABLE; Schema: school; Owner: postgres
--

CREATE TABLE school.courses (
    course_id text NOT NULL,
    title text,
    hours integer
);


ALTER TABLE school.courses OWNER TO postgres;

--
-- Name: exams; Type: TABLE; Schema: school; Owner: postgres
--

CREATE TABLE school.exams (
    student_id integer NOT NULL,
    course_id text NOT NULL,
    score integer
);


ALTER TABLE school.exams OWNER TO postgres;

--
-- Name: students; Type: TABLE; Schema: school; Owner: postgres
--

CREATE TABLE school.students (
    student_id integer NOT NULL,
    name text,
    start_year integer
);


ALTER TABLE school.students OWNER TO postgres;

--
-- Data for Name: courses; Type: TABLE DATA; Schema: school; Owner: postgres
--

COPY school.courses (course_id, title, hours) FROM stdin;
CS3000	Docker	60
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: school; Owner: postgres
--

COPY school.exams (student_id, course_id, score) FROM stdin;
13	CS3000	80
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: school; Owner: postgres
--

COPY school.students (student_id, name, start_year) FROM stdin;
13	Anna	2021
\.


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: school; Owner: postgres
--

ALTER TABLE ONLY school.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: exams pk; Type: CONSTRAINT; Schema: school; Owner: postgres
--

ALTER TABLE ONLY school.exams
    ADD CONSTRAINT pk PRIMARY KEY (student_id, course_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: school; Owner: postgres
--

ALTER TABLE ONLY school.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: exams exams_course_id_fkey; Type: FK CONSTRAINT; Schema: school; Owner: postgres
--

ALTER TABLE ONLY school.exams
    ADD CONSTRAINT exams_course_id_fkey FOREIGN KEY (course_id) REFERENCES school.courses(course_id);


--
-- Name: exams exams_student_id_fkey; Type: FK CONSTRAINT; Schema: school; Owner: postgres
--

ALTER TABLE ONLY school.exams
    ADD CONSTRAINT exams_student_id_fkey FOREIGN KEY (student_id) REFERENCES school.students(student_id);


--
-- PostgreSQL database dump complete
--

