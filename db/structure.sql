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
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: annotations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.annotations (
    id integer NOT NULL,
    user_id integer,
    course_id integer,
    text text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: annotations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.annotations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: annotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.annotations_id_seq OWNED BY public.annotations.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: course_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_attributes (
    id bigint NOT NULL,
    external_course_id integer NOT NULL,
    course_offer_number integer,
    course_id bigint,
    term_code integer NOT NULL,
    term_description character varying NOT NULL,
    session_code character varying NOT NULL,
    class_section character varying NOT NULL,
    crse_attribute character varying,
    crse_attribute_description character varying,
    crse_attr_value character varying,
    crse_attr_value_description character varying,
    academic_career character varying,
    bracketed_flag character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: course_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.course_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.course_attributes_id_seq OWNED BY public.course_attributes.id;


--
-- Name: course_instructors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_instructors (
    id integer NOT NULL,
    external_course_id integer,
    course_id integer,
    term_name character varying,
    term_year integer,
    class_section character varying,
    class_meeting_number character varying,
    instructor_role character varying,
    print_instructor_flag character varying,
    first_name character varying,
    middle_name character varying,
    last_name character varying,
    name_prefix character varying,
    name_suffix character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: course_instructors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.course_instructors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_instructors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.course_instructors_id_seq OWNED BY public.course_instructors.id;


--
-- Name: course_meeting_patterns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_meeting_patterns (
    id integer NOT NULL,
    external_course_id integer,
    course_id integer,
    term_name character varying,
    term_year integer,
    class_section character varying,
    class_meeting_number character varying,
    meeting_time_start timestamp without time zone,
    meeting_time_end timestamp without time zone,
    meets_on_monday boolean,
    meets_on_tuesday boolean,
    meets_on_wednesday boolean,
    meets_on_thursday boolean,
    meets_on_friday boolean,
    meets_on_saturday boolean,
    meets_on_sunday boolean,
    start_date date,
    end_date date,
    external_facility_id character varying,
    facility_description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: course_meeting_patterns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.course_meeting_patterns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_meeting_patterns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.course_meeting_patterns_id_seq OWNED BY public.course_meeting_patterns.id;


--
-- Name: course_readings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.course_readings (
    id integer NOT NULL,
    external_course_id integer,
    external_citation_id integer,
    course_id integer,
    title character varying,
    author_last_name character varying,
    author_first_name character varying,
    url character varying,
    annotation text,
    required boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: course_readings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.course_readings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: course_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.course_readings_id_seq OWNED BY public.course_readings.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    external_course_id integer NOT NULL,
    title character varying,
    term_name character varying,
    term_year integer,
    academic_year integer,
    class_section character varying NOT NULL,
    component character varying,
    prereq integer,
    subject character varying,
    subject_description text,
    subject_academic_org_description text,
    academic_group character varying,
    academic_group_description text,
    grading_basis_description text,
    term_pattern_code character varying,
    term_pattern_description text,
    units_maximum integer,
    catalog_number character varying,
    course_description text,
    course_description_long text,
    course_note text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    class_academic_org_description text,
    division character varying,
    division_description character varying,
    term_code integer NOT NULL,
    offer_number integer NOT NULL,
    session_code character varying NOT NULL,
    component_filtered character varying,
    requirement_group character varying,
    requirement_group_description character varying
);


--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: division_mappings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.division_mappings (
    id integer NOT NULL,
    academic_group character varying,
    subject_description character varying,
    division character varying,
    division_description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: division_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.division_mappings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: division_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.division_mappings_id_seq OWNED BY public.division_mappings.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    user_id integer,
    course_id integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: user_courses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_courses (
    id integer NOT NULL,
    user_id integer,
    course_id integer,
    include_in_path boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    course_meeting_pattern_id integer
);


--
-- Name: user_courses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_courses_id_seq OWNED BY public.user_courses.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    api_token character varying,
    schedule_token character varying,
    display_name character varying,
    given_name character varying,
    huid character varying,
    surname character varying,
    username character varying DEFAULT ''::character varying NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: annotations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annotations ALTER COLUMN id SET DEFAULT nextval('public.annotations_id_seq'::regclass);


--
-- Name: course_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_attributes ALTER COLUMN id SET DEFAULT nextval('public.course_attributes_id_seq'::regclass);


--
-- Name: course_instructors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_instructors ALTER COLUMN id SET DEFAULT nextval('public.course_instructors_id_seq'::regclass);


--
-- Name: course_meeting_patterns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_meeting_patterns ALTER COLUMN id SET DEFAULT nextval('public.course_meeting_patterns_id_seq'::regclass);


--
-- Name: course_readings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_readings ALTER COLUMN id SET DEFAULT nextval('public.course_readings_id_seq'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: division_mappings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.division_mappings ALTER COLUMN id SET DEFAULT nextval('public.division_mappings_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: user_courses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_courses ALTER COLUMN id SET DEFAULT nextval('public.user_courses_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: annotations annotations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annotations
    ADD CONSTRAINT annotations_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: course_attributes course_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_attributes
    ADD CONSTRAINT course_attributes_pkey PRIMARY KEY (id);


--
-- Name: course_instructors course_instructors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_instructors
    ADD CONSTRAINT course_instructors_pkey PRIMARY KEY (id);


--
-- Name: course_meeting_patterns course_meeting_patterns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_meeting_patterns
    ADD CONSTRAINT course_meeting_patterns_pkey PRIMARY KEY (id);


--
-- Name: course_readings course_readings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_readings
    ADD CONSTRAINT course_readings_pkey PRIMARY KEY (id);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: division_mappings division_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.division_mappings
    ADD CONSTRAINT division_mappings_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_courses user_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_courses
    ADD CONSTRAINT user_courses_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: by_unique_composite_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX by_unique_composite_key ON public.courses USING btree (external_course_id, offer_number, term_code, session_code, class_section);


--
-- Name: index_annotations_on_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_annotations_on_course_id ON public.annotations USING btree (course_id);


--
-- Name: index_annotations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_annotations_on_user_id ON public.annotations USING btree (user_id);


--
-- Name: index_course_attributes_on_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_course_attributes_on_course_id ON public.course_attributes USING btree (course_id);


--
-- Name: index_course_meeting_patterns_on_course_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_course_meeting_patterns_on_course_id ON public.course_meeting_patterns USING btree (course_id);


--
-- Name: index_course_meeting_patterns_on_meets_on_friday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_course_meeting_patterns_on_meets_on_friday ON public.course_meeting_patterns USING btree (meets_on_friday);


--
-- Name: index_course_meeting_patterns_on_meets_on_monday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_course_meeting_patterns_on_meets_on_monday ON public.course_meeting_patterns USING btree (meets_on_monday);


--
-- Name: index_course_meeting_patterns_on_meets_on_saturday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_course_meeting_patterns_on_meets_on_saturday ON public.course_meeting_patterns USING btree (meets_on_saturday);


--
-- Name: index_course_meeting_patterns_on_meets_on_sunday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_course_meeting_patterns_on_meets_on_sunday ON public.course_meeting_patterns USING btree (meets_on_sunday);


--
-- Name: index_course_meeting_patterns_on_meets_on_thursday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_course_meeting_patterns_on_meets_on_thursday ON public.course_meeting_patterns USING btree (meets_on_thursday);


--
-- Name: index_course_meeting_patterns_on_meets_on_tuesday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_course_meeting_patterns_on_meets_on_tuesday ON public.course_meeting_patterns USING btree (meets_on_tuesday);


--
-- Name: index_course_meeting_patterns_on_meets_on_wednesday; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_course_meeting_patterns_on_meets_on_wednesday ON public.course_meeting_patterns USING btree (meets_on_wednesday);


--
-- Name: index_courses_on_class_section; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_class_section ON public.courses USING btree (class_section);


--
-- Name: index_courses_on_course_note; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_course_note ON public.courses USING gin (course_note);


--
-- Name: index_courses_on_division_description; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_division_description ON public.courses USING btree (division_description);


--
-- Name: index_courses_on_term_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_term_name ON public.courses USING btree (term_name);


--
-- Name: index_courses_on_term_year; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_term_year ON public.courses USING btree (term_year);


--
-- Name: index_courses_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_title ON public.courses USING gin (title);


--
-- Name: index_courses_on_to_tsvector_english_course_description_long; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_courses_on_to_tsvector_english_course_description_long ON public.courses USING gin (to_tsvector('english'::regconfig, course_description_long));


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_username ON public.users USING btree (username);


--
-- Name: courses fk_rails_0e745cfd25; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT fk_rails_0e745cfd25 FOREIGN KEY (prereq) REFERENCES public.courses(id);


--
-- Name: course_instructors fk_rails_146bab2632; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_instructors
    ADD CONSTRAINT fk_rails_146bab2632 FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: course_readings fk_rails_20a71c6634; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_readings
    ADD CONSTRAINT fk_rails_20a71c6634 FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: course_meeting_patterns fk_rails_3b8312f4c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_meeting_patterns
    ADD CONSTRAINT fk_rails_3b8312f4c3 FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: annotations fk_rails_4043df79bf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annotations
    ADD CONSTRAINT fk_rails_4043df79bf FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_courses fk_rails_4a55f742c8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_courses
    ADD CONSTRAINT fk_rails_4a55f742c8 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_courses fk_rails_63b9b1bfc2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_courses
    ADD CONSTRAINT fk_rails_63b9b1bfc2 FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: annotations fk_rails_8e3363eff1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.annotations
    ADD CONSTRAINT fk_rails_8e3363eff1 FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: course_attributes fk_rails_95e3af577e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.course_attributes
    ADD CONSTRAINT fk_rails_95e3af577e FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: tags fk_rails_e689f6d0cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_rails_e689f6d0cc FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tags fk_rails_f5f6cbb85f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_rails_f5f6cbb85f FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: user_courses fk_rails_ff60ec44c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_courses
    ADD CONSTRAINT fk_rails_ff60ec44c4 FOREIGN KEY (course_meeting_pattern_id) REFERENCES public.course_meeting_patterns(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20161106153524'),
('20161208200939'),
('20161208201738'),
('20161208202032'),
('20161209204409'),
('20161209205132'),
('20161209205224'),
('20161213023322'),
('20161213023546'),
('20161213024214'),
('20161213024302'),
('20161213024342'),
('20161213024412'),
('20161219202444'),
('20161219202747'),
('20170104043109'),
('20170112041305'),
('20170314050815'),
('20170314053518'),
('20170323034736'),
('20170323051956'),
('20170327173904'),
('20171221085445'),
('20180109115504'),
('20180126212035'),
('20180129021024'),
('20180206175525'),
('20180814122657'),
('20180829144608'),
('20190315151234'),
('20190318142236'),
('20190318143427'),
('20190318143539'),
('20190318144611'),
('20190603140030'),
('20190619154529'),
('20190621140452');


