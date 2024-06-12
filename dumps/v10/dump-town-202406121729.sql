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

--
-- Name: file_fdw; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS file_fdw WITH SCHEMA school;


--
-- Name: EXTENSION file_fdw; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION file_fdw IS 'foreign-data wrapper for flat file access';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA school;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


--
-- Name: mq_trim(text); Type: FUNCTION; Schema: school; Owner: postgres
--

CREATE FUNCTION school.mq_trim(input_string text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN TRIM(BOTH FROM input_string);
END;
$$;


ALTER FUNCTION school.mq_trim(input_string text) OWNER TO postgres;

--
-- Name: refresh_teachers_courses(); Type: FUNCTION; Schema: school; Owner: postgres
--

CREATE FUNCTION school.refresh_teachers_courses() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    REFRESH MATERIALIZED VIEW teachers_courses;
    RETURN NULL;
END;
$$;


ALTER FUNCTION school.refresh_teachers_courses() OWNER TO postgres;

--
-- Name: file_server; Type: SERVER; Schema: -; Owner: postgres
--

CREATE SERVER file_server FOREIGN DATA WRAPPER file_fdw;


ALTER SERVER file_server OWNER TO postgres;

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
-- Name: students_courses; Type: VIEW; Schema: school; Owner: postgres
--

CREATE VIEW school.students_courses AS
 SELECT students.name AS student_name,
    courses.title AS course_title,
    exams.score AS student_score
   FROM ((school.exams
     JOIN school.students ON ((students.student_id = exams.student_id)))
     JOIN school.courses ON ((courses.course_id = exams.course_id)));


ALTER TABLE school.students_courses OWNER TO postgres;

--
-- Name: teachers; Type: FOREIGN TABLE; Schema: school; Owner: postgres
--

CREATE FOREIGN TABLE school.teachers (
    course_id text,
    name text,
    notes text
)
SERVER file_server
OPTIONS (
    filename '/var/lib/postgresql/10/main/teachers.csv',
    format 'csv',
    header 'true'
);


ALTER FOREIGN TABLE school.teachers OWNER TO postgres;

--
-- Name: teachers_courses; Type: MATERIALIZED VIEW; Schema: school; Owner: postgres
--

CREATE MATERIALIZED VIEW school.teachers_courses AS
 SELECT courses.course_id,
    courses.title AS course_title,
    teachers.name AS teacher_name,
    teachers.notes AS teacher_notes
   FROM (school.courses
     JOIN school.teachers ON ((courses.course_id = teachers.course_id)))
  WITH NO DATA;


ALTER TABLE school.teachers_courses OWNER TO postgres;

--
-- Data for Name: courses; Type: TABLE DATA; Schema: school; Owner: postgres
--

COPY school.courses (course_id, title, hours) FROM stdin;
CS3000	Docker	60
DX9000	JavaScript	100
Z101	Reti	10
\.


--
-- Data for Name: exams; Type: TABLE DATA; Schema: school; Owner: postgres
--

COPY school.exams (student_id, course_id, score) FROM stdin;
13	CS3000	80
14	DX9000	18
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: school; Owner: postgres
--

COPY school.students (student_id, name, start_year) FROM stdin;
13	Anna	2021
14	Adèlchi	2000
15	Benedetto	1999
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
-- Name: courses refresh_teachers_courses_trigger; Type: TRIGGER; Schema: school; Owner: postgres
--

CREATE TRIGGER refresh_teachers_courses_trigger AFTER INSERT OR DELETE OR UPDATE ON school.courses FOR EACH STATEMENT EXECUTE PROCEDURE school.refresh_teachers_courses();


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
-- Name: teachers_courses; Type: MATERIALIZED VIEW DATA; Schema: school; Owner: postgres
--

REFRESH MATERIALIZED VIEW school.teachers_courses;


--
-- PostgreSQL database dump complete
--

