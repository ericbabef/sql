-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.8.2
-- PostgreSQL version: 9.5
-- Project Site: pgmodeler.com.br
-- Model Author: ---

SET check_function_bodies = false;
-- ddl-end --

-- object: sig | type: ROLE --
-- DROP ROLE IF EXISTS sig;
CREATE ROLE sig WITH 
	SUPERUSER
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD '********';
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: dict | type: DATABASE --
-- -- DROP DATABASE IF EXISTS dict;
-- CREATE DATABASE dict
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'French_France.UTF8'
-- 	LC_CTYPE = 'French_France.UTF8'
-- 	TABLESPACE = pg_default
-- 	OWNER = sig
-- ;
-- -- ddl-end --
-- 

-- object: cadastre | type: SCHEMA --
-- DROP SCHEMA IF EXISTS cadastre CASCADE;
CREATE SCHEMA cadastre;
-- ddl-end --
ALTER SCHEMA cadastre OWNER TO sig;
-- ddl-end --

-- object: dict | type: SCHEMA --
-- DROP SCHEMA IF EXISTS dict CASCADE;
CREATE SCHEMA dict;
-- ddl-end --
ALTER SCHEMA dict OWNER TO sig;
-- ddl-end --

-- object: reseau | type: SCHEMA --
-- DROP SCHEMA IF EXISTS reseau CASCADE;
CREATE SCHEMA reseau;
-- ddl-end --
ALTER SCHEMA reseau OWNER TO sig;
-- ddl-end --

SET search_path TO pg_catalog,public,cadastre,dict,reseau;
-- ddl-end --

-- object: public.geometry | type: TYPE --
-- DROP TYPE IF EXISTS public.geometry CASCADE;
CREATE TYPE public.geometry;
-- ddl-end --

-- object: postgis | type: EXTENSION --
-- DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis
      WITH SCHEMA public
      VERSION '2.0.3';
-- ddl-end --
COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';
-- ddl-end --

-- object: cadastre.commune | type: TABLE --
-- DROP TABLE IF EXISTS cadastre.commune CASCADE;
CREATE TABLE cadastre.commune(
	nom character varying(45) NOT NULL,
	code_insee character varying(5) NOT NULL,
	geom geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'POLYGON'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4326))

);
-- ddl-end --
ALTER TABLE cadastre.commune OWNER TO sig;
-- ddl-end --

-- object: idx_commune_geom | type: INDEX --
-- DROP INDEX IF EXISTS cadastre.idx_commune_geom CASCADE;
CREATE INDEX idx_commune_geom ON cadastre.commune
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: dict.appli_dict_profil_user_profil_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dict.appli_dict_profil_user_profil_id_seq CASCADE;
CREATE SEQUENCE dict.appli_dict_profil_user_profil_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE dict.appli_dict_profil_user_profil_id_seq OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_profil_user | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_profil_user CASCADE;
CREATE TABLE dict.appli_dict_profil_user(
	profil_id integer NOT NULL DEFAULT nextval('dict.appli_dict_profil_user_profil_id_seq'::regclass),
	administration character varying(255) NOT NULL,
	adresse character varying(255) NOT NULL,
	service character varying(255) NOT NULL,
	mail_service character varying(255),
	tel_service character varying(100),
	fax_service character varying(100),
	carto_lon numeric(16,8) NOT NULL,
	carto_lat numeric(16,8) NOT NULL,
	carto_xmin numeric(16,8) NOT NULL,
	carto_xmax numeric(16,8) NOT NULL,
	carto_ymin numeric(16,8) NOT NULL,
	carto_ymax numeric(16,8) NOT NULL,
	carto_zoom integer NOT NULL,
	CONSTRAINT pk_appli_dict_profil_user PRIMARY KEY (profil_id)

);
-- ddl-end --
ALTER TABLE dict.appli_dict_profil_user OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_user_user_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dict.appli_dict_user_user_id_seq CASCADE;
CREATE SEQUENCE dict.appli_dict_user_user_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE dict.appli_dict_user_user_id_seq OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_user | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_user CASCADE;
CREATE TABLE dict.appli_dict_user(
	user_id integer NOT NULL DEFAULT nextval('dict.appli_dict_user_user_id_seq'::regclass),
	login character varying(65),
	pass character varying(255) NOT NULL,
	mail_user character varying(255) NOT NULL,
	administrator character varying(3) NOT NULL,
	sup_administrator character varying(3) NOT NULL,
	create_data character varying(3) NOT NULL,
	consult_data character varying(3) NOT NULL,
	profil_id integer,
	protocol_id integer,
	CONSTRAINT appli_dict_user_administrator_check CHECK (((administrator)::text = ANY ((ARRAY['oui'::character varying, 'non'::character varying])::text[]))),
	CONSTRAINT appli_dict_user_administrator_check1 CHECK (((administrator)::text = ANY ((ARRAY['oui'::character varying, 'non'::character varying])::text[]))),
	CONSTRAINT appli_dict_user_create_data_check CHECK (((create_data)::text = ANY ((ARRAY['oui'::character varying, 'non'::character varying])::text[]))),
	CONSTRAINT appli_dict_user_consult_data_check CHECK (((consult_data)::text = ANY ((ARRAY['oui'::character varying, 'non'::character varying])::text[]))),
	CONSTRAINT pk_appli_dict_user PRIMARY KEY (user_id),
	CONSTRAINT uk_user_login UNIQUE (login)

);
-- ddl-end --
ALTER TABLE dict.appli_dict_user OWNER TO sig;
-- ddl-end --

-- object: idx_login | type: INDEX --
-- DROP INDEX IF EXISTS dict.idx_login CASCADE;
CREATE INDEX idx_login ON dict.appli_dict_user
	USING btree
	(
	  login
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: dict.appli_dict_group_group_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dict.appli_dict_group_group_id_seq CASCADE;
CREATE SEQUENCE dict.appli_dict_group_group_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE dict.appli_dict_group_group_id_seq OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_group | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_group CASCADE;
CREATE TABLE dict.appli_dict_group(
	group_id integer NOT NULL DEFAULT nextval('dict.appli_dict_group_group_id_seq'::regclass),
	name_group character varying(50) NOT NULL,
	CONSTRAINT pk_group_id PRIMARY KEY (group_id),
	CONSTRAINT uk_name_group UNIQUE (name_group)

);
-- ddl-end --
COMMENT ON TABLE dict.appli_dict_group IS 'Groupe selon le réseau';
-- ddl-end --
ALTER TABLE dict.appli_dict_group OWNER TO sig;
-- ddl-end --

-- object: idx_name_group | type: INDEX --
-- DROP INDEX IF EXISTS dict.idx_name_group CASCADE;
CREATE UNIQUE INDEX idx_name_group ON dict.appli_dict_group
	USING btree
	(
	  (lower((name_group)::text))
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: dict.appli_dict_param_param_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dict.appli_dict_param_param_id_seq CASCADE;
CREATE SEQUENCE dict.appli_dict_param_param_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE dict.appli_dict_param_param_id_seq OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_param | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_param CASCADE;
CREATE TABLE dict.appli_dict_param(
	param_id integer NOT NULL DEFAULT nextval('dict.appli_dict_param_param_id_seq'::regclass),
	name_param character varying(50) NOT NULL,
	group_id integer NOT NULL,
	nom_reseau character varying(50) NOT NULL,
	service character varying(100) NOT NULL,
	adresse_contact character varying(255) NOT NULL,
	logo_1 character varying(50) NOT NULL,
	logo_2 character varying(50),
	annexe text[],
	couche_localisation character varying(50) NOT NULL,
	legend_localisation character varying(50) NOT NULL,
	couche_atlas character varying(50) NOT NULL,
	classe_reseau character varying NOT NULL,
	CONSTRAINT pk_param_id PRIMARY KEY (param_id),
	CONSTRAINT uk_param_group UNIQUE (name_param,group_id),
	CONSTRAINT appli_dict_param_classe_reseau_check CHECK (((classe_reseau)::text = ANY ((ARRAY['A'::character varying, 'B'::character varying, 'C'::character varying])::text[])))

);
-- ddl-end --
COMMENT ON TABLE dict.appli_dict_param IS 'Param selon le groupe';
-- ddl-end --
ALTER TABLE dict.appli_dict_param OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_user_group_param | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_user_group_param CASCADE;
CREATE TABLE dict.appli_dict_user_group_param(
	user_id integer,
	group_id integer,
	param_id integer,
	CONSTRAINT uk_user_group_param UNIQUE (param_id,group_id,user_id)

);
-- ddl-end --
ALTER TABLE dict.appli_dict_user_group_param OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_atlas_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dict.appli_dict_atlas_id_seq CASCADE;
CREATE SEQUENCE dict.appli_dict_atlas_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE dict.appli_dict_atlas_id_seq OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_atlas | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_atlas CASCADE;
CREATE TABLE dict.appli_dict_atlas(
	id integer NOT NULL DEFAULT nextval('dict.appli_dict_atlas_id_seq'::regclass),
	group_id integer NOT NULL,
	param_id integer NOT NULL,
	num_dict character varying(50) NOT NULL,
	type_dict character varying(50) NOT NULL,
	adresse_dict character varying(255),
	date_dict date NOT NULL,
	geom geometry,
	CONSTRAINT pk_appli_dict_atlas PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE dict.appli_dict_atlas OWNER TO sig;
-- ddl-end --

-- object: idx_appli_dict_atlas_geom | type: INDEX --
-- DROP INDEX IF EXISTS dict.idx_appli_dict_atlas_geom CASCADE;
CREATE INDEX idx_appli_dict_atlas_geom ON dict.appli_dict_atlas
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: dict.appli_dict_atlas2_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dict.appli_dict_atlas2_id_seq CASCADE;
CREATE SEQUENCE dict.appli_dict_atlas2_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE dict.appli_dict_atlas2_id_seq OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_atlas2 | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_atlas2 CASCADE;
CREATE TABLE dict.appli_dict_atlas2(
	id integer NOT NULL DEFAULT nextval('dict.appli_dict_atlas2_id_seq'::regclass),
	group_id integer NOT NULL,
	param_id integer NOT NULL,
	num_dict character varying(50) NOT NULL,
	type_dict character varying(50) NOT NULL,
	adresse_dict character varying(255),
	date_dict date NOT NULL,
	row_number integer,
	geom geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'POLYGON'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4326)),
	CONSTRAINT pk_appli_dict_atlas2 PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE dict.appli_dict_atlas2 OWNER TO sig;
-- ddl-end --

-- object: idx_appli_dict_atlas2_geom | type: INDEX --
-- DROP INDEX IF EXISTS dict.idx_appli_dict_atlas2_geom CASCADE;
CREATE INDEX idx_appli_dict_atlas2_geom ON dict.appli_dict_atlas2
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: dict.appli_dict_polygon_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dict.appli_dict_polygon_id_seq CASCADE;
CREATE SEQUENCE dict.appli_dict_polygon_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE dict.appli_dict_polygon_id_seq OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_polygon | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_polygon CASCADE;
CREATE TABLE dict.appli_dict_polygon(
	id integer NOT NULL DEFAULT nextval('dict.appli_dict_polygon_id_seq'::regclass),
	group_id integer,
	param_id integer,
	num_dict character varying(50) NOT NULL,
	type_dict character varying(50) NOT NULL,
	adresse_dict character varying(255),
	date_dict date NOT NULL,
	impact_dict character varying(3) NOT NULL,
	date_envoyer_dict date NOT NULL,
	contact_dict character varying(255),
	courriel_dict character varying(255),
	denomination_dict character varying(255),
	commune_pal_dict character varying(150),
	nature_travaux_dict character varying(255),
	xml_dict character varying(3) NOT NULL,
	tel_dict character varying(50),
	geom geometry,
	CONSTRAINT appli_dict_polygon_type_dict_check CHECK (((type_dict)::text = ANY ((ARRAY['DT'::character varying, 'DICT'::character varying, 'dtDictConjointes'::character varying, 'ATU'::character varying])::text[]))),
	CONSTRAINT appli_dict_polygon_impact_dict_check CHECK (((impact_dict)::text = ANY ((ARRAY['oui'::character varying, 'non'::character varying])::text[]))),
	CONSTRAINT appli_dict_polygon_xml_dict_check CHECK (((xml_dict)::text = ANY ((ARRAY['xml'::character varying, 'non'::character varying])::text[]))),
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'MULTIPOLYGON'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4326)),
	CONSTRAINT pk_appli_dict_polygon PRIMARY KEY (id),
	CONSTRAINT uk_group_param_numdict UNIQUE (group_id,param_id,num_dict)

);
-- ddl-end --
ALTER TABLE dict.appli_dict_polygon OWNER TO sig;
-- ddl-end --

-- object: idx_appli_dict_polygon_geom | type: INDEX --
-- DROP INDEX IF EXISTS dict.idx_appli_dict_polygon_geom CASCADE;
CREATE INDEX idx_appli_dict_polygon_geom ON dict.appli_dict_polygon
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: dict.appli_dict_stats_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dict.appli_dict_stats_id_seq CASCADE;
CREATE SEQUENCE dict.appli_dict_stats_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE dict.appli_dict_stats_id_seq OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_stats | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_stats CASCADE;
CREATE TABLE dict.appli_dict_stats(
	id integer NOT NULL DEFAULT nextval('dict.appli_dict_stats_id_seq'::regclass),
	num_dict character varying(50),
	categ_dict character varying(50),
	file_dict character varying(250),
	ip_dict character varying(15),
	host_dict character varying(100),
	browser_dict character varying(250),
	referer_dict character varying(250),
	date_dict timestamp,
	CONSTRAINT pk_appli_dict_stats PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE dict.appli_dict_stats OWNER TO sig;
-- ddl-end --

-- object: dict.v_appli_dict_atlas | type: VIEW --
-- DROP VIEW IF EXISTS dict.v_appli_dict_atlas CASCADE;
CREATE VIEW dict.v_appli_dict_atlas
AS 

SELECT a.id, a.num_dict, a.type_dict, a.adresse_dict, a.date_dict, a.group_id, a.param_id, a.row_number, (((((a.group_id)::text || '_'::text) || (a.param_id)::text) || '_'::text) || (a.num_dict)::text) AS ident, a.geom FROM dict.appli_dict_atlas2 a;
-- ddl-end --
ALTER VIEW dict.v_appli_dict_atlas OWNER TO sig;
-- ddl-end --

-- object: dict.v_appli_dict_atlas_union | type: VIEW --
-- DROP VIEW IF EXISTS dict.v_appli_dict_atlas_union CASCADE;
CREATE VIEW dict.v_appli_dict_atlas_union
AS 

SELECT appli_dict_atlas2.num_dict, appli_dict_atlas2.group_id, appli_dict_atlas2.param_id, st_union(appli_dict_atlas2.geom) AS geom FROM dict.appli_dict_atlas2 GROUP BY appli_dict_atlas2.num_dict, appli_dict_atlas2.group_id, appli_dict_atlas2.param_id;
-- ddl-end --
ALTER VIEW dict.v_appli_dict_atlas_union OWNER TO sig;
-- ddl-end --

-- object: dict.v_appli_dict_emplacement | type: VIEW --
-- DROP VIEW IF EXISTS dict.v_appli_dict_emplacement CASCADE;
CREATE VIEW dict.v_appli_dict_emplacement
AS 

SELECT appli_dict_polygon.id, appli_dict_polygon.group_id, appli_dict_polygon.param_id, appli_dict_polygon.num_dict, appli_dict_polygon.type_dict, appli_dict_polygon.adresse_dict, appli_dict_polygon.date_dict, appli_dict_polygon.impact_dict, appli_dict_polygon.date_envoyer_dict, appli_dict_polygon.contact_dict, appli_dict_polygon.courriel_dict, appli_dict_polygon.denomination_dict, appli_dict_polygon.commune_pal_dict, appli_dict_polygon.nature_travaux_dict, st_pointonsurface(appli_dict_polygon.geom) AS geom FROM dict.appli_dict_polygon;
-- ddl-end --
ALTER VIEW dict.v_appli_dict_emplacement OWNER TO sig;
-- ddl-end --

-- object: dict.v_appli_dict_polygon | type: VIEW --
-- DROP VIEW IF EXISTS dict.v_appli_dict_polygon CASCADE;
CREATE VIEW dict.v_appli_dict_polygon
AS 

SELECT count(a.num_dict) AS nb_plan, a.num_dict, a.type_dict, a.adresse_dict, a.date_dict, a.impact_dict, a.group_id, a.param_id, a.geom, a.date_envoyer_dict, a.contact_dict, a.courriel_dict, string_agg((b.nom)::text, ', '::text) AS commune FROM (dict.appli_dict_polygon a JOIN commune b ON (st_intersects(a.geom, b.geom))) GROUP BY a.num_dict, a.type_dict, a.adresse_dict, a.date_dict, a.impact_dict, a.group_id, a.param_id, a.geom, a.date_envoyer_dict, a.contact_dict, a.courriel_dict;
-- ddl-end --
ALTER VIEW dict.v_appli_dict_polygon OWNER TO sig;
-- ddl-end --

-- object: dict.v_appli_dict_polygon2 | type: VIEW --
-- DROP VIEW IF EXISTS dict.v_appli_dict_polygon2 CASCADE;
CREATE VIEW dict.v_appli_dict_polygon2
AS 

SELECT appli_dict_polygon.id, appli_dict_polygon.group_id, appli_dict_polygon.param_id, appli_dict_polygon.num_dict, appli_dict_polygon.type_dict, appli_dict_polygon.adresse_dict, appli_dict_polygon.date_dict, appli_dict_polygon.impact_dict, appli_dict_polygon.date_envoyer_dict, appli_dict_polygon.contact_dict, appli_dict_polygon.courriel_dict, appli_dict_polygon.denomination_dict, appli_dict_polygon.commune_pal_dict, appli_dict_polygon.nature_travaux_dict, appli_dict_polygon.xml_dict, appli_dict_polygon.tel_dict, appli_dict_polygon.geom, (((((appli_dict_polygon.group_id)::text || '_'::text) || (appli_dict_polygon.param_id)::text) || '_'::text) || (appli_dict_polygon.num_dict)::text) AS ident_dict_polygon FROM dict.appli_dict_polygon;
-- ddl-end --
ALTER VIEW dict.v_appli_dict_polygon2 OWNER TO sig;
-- ddl-end --

-- object: dict.v_appli_dict_stats_consult | type: VIEW --
-- DROP VIEW IF EXISTS dict.v_appli_dict_stats_consult CASCADE;
CREATE VIEW dict.v_appli_dict_stats_consult
AS 

SELECT appli_dict_stats.id, appli_dict_stats.num_dict, appli_dict_stats.categ_dict, appli_dict_stats.file_dict, appli_dict_stats.ip_dict, appli_dict_stats.host_dict, appli_dict_stats.browser_dict, appli_dict_stats.referer_dict, appli_dict_stats.date_dict FROM dict.appli_dict_stats WHERE (((((appli_dict_stats.ip_dict)::bpchar <> '10.254.1.237'::bpchar) AND ((appli_dict_stats.ip_dict)::bpchar <> '10.255.68.158'::bpchar)) AND ((appli_dict_stats.ip_dict)::bpchar <> '10.255.68.152'::bpchar)) AND ((appli_dict_stats.ip_dict)::bpchar <> '10.255.68.141'::bpchar));
-- ddl-end --
ALTER VIEW dict.v_appli_dict_stats_consult OWNER TO sig;
-- ddl-end --

-- object: reseau.fibre_fibre_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS reseau.fibre_fibre_id_seq CASCADE;
CREATE SEQUENCE reseau.fibre_fibre_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE reseau.fibre_fibre_id_seq OWNER TO sig;
-- ddl-end --

-- object: reseau.fibre | type: TABLE --
-- DROP TABLE IF EXISTS reseau.fibre CASCADE;
CREATE TABLE reseau.fibre(
	fibre_id integer NOT NULL DEFAULT nextval('reseau.fibre_fibre_id_seq'::regclass),
	param_id integer,
	geom geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'LINESTRING'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4326)),
	CONSTRAINT pk_fibre_id PRIMARY KEY (fibre_id)

);
-- ddl-end --
ALTER TABLE reseau.fibre OWNER TO sig;
-- ddl-end --

-- object: idx_fibre_geom | type: INDEX --
-- DROP INDEX IF EXISTS reseau.idx_fibre_geom CASCADE;
CREATE INDEX idx_fibre_geom ON reseau.fibre
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: reseau.eau_pluviale_eau_pluviale_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS reseau.eau_pluviale_eau_pluviale_id_seq CASCADE;
CREATE SEQUENCE reseau.eau_pluviale_eau_pluviale_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE reseau.eau_pluviale_eau_pluviale_id_seq OWNER TO sig;
-- ddl-end --

-- object: reseau.eau_pluviale | type: TABLE --
-- DROP TABLE IF EXISTS reseau.eau_pluviale CASCADE;
CREATE TABLE reseau.eau_pluviale(
	eau_pluviale_id integer NOT NULL DEFAULT nextval('reseau.eau_pluviale_eau_pluviale_id_seq'::regclass),
	param_id integer,
	geom geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'LINESTRING'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4326)),
	CONSTRAINT pk_eau_pluviale_id PRIMARY KEY (eau_pluviale_id)

);
-- ddl-end --
ALTER TABLE reseau.eau_pluviale OWNER TO sig;
-- ddl-end --

-- object: idx_eau_pluviale_geom | type: INDEX --
-- DROP INDEX IF EXISTS reseau.idx_eau_pluviale_geom CASCADE;
CREATE INDEX idx_eau_pluviale_geom ON reseau.eau_pluviale
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: reseau.eau_potable_eau_potable_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS reseau.eau_potable_eau_potable_id_seq CASCADE;
CREATE SEQUENCE reseau.eau_potable_eau_potable_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE reseau.eau_potable_eau_potable_id_seq OWNER TO sig;
-- ddl-end --

-- object: reseau.eau_potable | type: TABLE --
-- DROP TABLE IF EXISTS reseau.eau_potable CASCADE;
CREATE TABLE reseau.eau_potable(
	eau_potable_id integer NOT NULL DEFAULT nextval('reseau.eau_potable_eau_potable_id_seq'::regclass),
	param_id integer,
	geom geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'LINESTRING'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4326)),
	CONSTRAINT pk_eau_potable_id PRIMARY KEY (eau_potable_id)

);
-- ddl-end --
ALTER TABLE reseau.eau_potable OWNER TO sig;
-- ddl-end --

-- object: idx_eau_potable_geom | type: INDEX --
-- DROP INDEX IF EXISTS reseau.idx_eau_potable_geom CASCADE;
CREATE INDEX idx_eau_potable_geom ON reseau.eau_potable
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: reseau.eau_usee_eau_usee_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS reseau.eau_usee_eau_usee_id_seq CASCADE;
CREATE SEQUENCE reseau.eau_usee_eau_usee_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE reseau.eau_usee_eau_usee_id_seq OWNER TO sig;
-- ddl-end --

-- object: reseau.eau_usee | type: TABLE --
-- DROP TABLE IF EXISTS reseau.eau_usee CASCADE;
CREATE TABLE reseau.eau_usee(
	eau_usee_id integer NOT NULL DEFAULT nextval('reseau.eau_usee_eau_usee_id_seq'::regclass),
	param_id integer,
	geom geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'LINESTRING'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 4326)),
	CONSTRAINT pk_eau_usee_id PRIMARY KEY (eau_usee_id)

);
-- ddl-end --
ALTER TABLE reseau.eau_usee OWNER TO sig;
-- ddl-end --

-- object: idx_eau_usee_geom | type: INDEX --
-- DROP INDEX IF EXISTS reseau.idx_eau_usee_geom CASCADE;
CREATE INDEX idx_eau_usee_geom ON reseau.eau_usee
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: public.makegrid_2d | type: FUNCTION --
-- DROP FUNCTION IF EXISTS public.makegrid_2d(public.geometry,integer,integer) CASCADE;
CREATE FUNCTION public.makegrid_2d ( bound_polygon public.geometry DEFAULT 2154,  grid_step integer,  metric_srid integer)
	RETURNS public.geometry
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 100
	AS $$

DECLARE
  BoundM public.geometry; --Bound polygon transformed to the metric projection (with metric_srid SRID)
  Xmin DOUBLE PRECISION;
  Xmax DOUBLE PRECISION;
  Ymax DOUBLE PRECISION;
  X DOUBLE PRECISION;
  Y DOUBLE PRECISION;
  sectors public.geometry[];
  i INTEGER;
BEGIN
  BoundM := ST_Transform($1, $3); --From WGS84 (SRID 4326) to the metric projection, to operate with step in meters
  Xmin := ST_XMin(BoundM);
  Xmax := ST_XMax(BoundM);
  Ymax := ST_YMax(BoundM);

  Y := ST_YMin(BoundM); --current sector's corner coordinate
  i := -1;
  <<yloop>>
  LOOP
    IF (Y > Ymax) THEN  --Better if generating polygons exceeds the bound for one step. You always can crop the result. But if not you may get not quite correct data for outbound polygons (e.g. if you calculate frequency per sector)
        EXIT;
    END IF;

    X := Xmin;
    <<xloop>>
    LOOP
      IF (X > Xmax) THEN
          EXIT;
      END IF;

      i := i + 1;
      sectors[i] := ST_GeomFromText('POLYGON(('||X||' '||Y||', '||(X+$2)||' '||Y||', '||(X+$2)||' '||(Y+$2)||', '||X||' '||(Y+$2)||', '||X||' '||Y||'))', $3);

      X := X + $2;
    END LOOP xloop;
    Y := Y + $2;
  END LOOP yloop;

  RETURN ST_Transform(ST_Collect(sectors), ST_SRID($1));
END;

$$;
-- ddl-end --
ALTER FUNCTION public.makegrid_2d(public.geometry,integer,integer) OWNER TO sig;
-- ddl-end --

-- object: idx_poly_group | type: INDEX --
-- DROP INDEX IF EXISTS dict.idx_poly_group CASCADE;
CREATE INDEX idx_poly_group ON dict.appli_dict_polygon
	USING btree
	(
	  group_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_poly_param | type: INDEX --
-- DROP INDEX IF EXISTS dict.idx_poly_param CASCADE;
CREATE INDEX idx_poly_param ON dict.appli_dict_polygon
	USING btree
	(
	  param_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: reseau.union_eau_pluviale | type: TABLE --
-- DROP TABLE IF EXISTS reseau.union_eau_pluviale CASCADE;
CREATE TABLE reseau.union_eau_pluviale(
	param_id smallint,
	geom public.geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'MULTILINESTRING'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 2154))

);
-- ddl-end --
ALTER TABLE reseau.union_eau_pluviale OWNER TO sig;
-- ddl-end --

-- object: reseau.union_eau_usee | type: TABLE --
-- DROP TABLE IF EXISTS reseau.union_eau_usee CASCADE;
CREATE TABLE reseau.union_eau_usee(
	param_id smallint,
	geom public.geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'MULTILINESTRING'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 2154))

);
-- ddl-end --
ALTER TABLE reseau.union_eau_usee OWNER TO sig;
-- ddl-end --

-- object: reseau.union_fibre | type: TABLE --
-- DROP TABLE IF EXISTS reseau.union_fibre CASCADE;
CREATE TABLE reseau.union_fibre(
	param_id smallint,
	geom public.geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'MULTILINESTRING'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 2154))

);
-- ddl-end --
ALTER TABLE reseau.union_fibre OWNER TO sig;
-- ddl-end --

-- object: reseau.union_eau_potable | type: TABLE --
-- DROP TABLE IF EXISTS reseau.union_eau_potable CASCADE;
CREATE TABLE reseau.union_eau_potable(
	param_id smallint,
	geom public.geometry,
	CONSTRAINT enforce_dims_geom CHECK ((st_ndims(geom) = 2)),
	CONSTRAINT enforce_geotype_geom CHECK (((geometrytype(geom) = 'MULTILINESTRING'::text) OR (geom IS NULL))),
	CONSTRAINT enforce_srid_geom CHECK ((st_srid(geom) = 2154))

);
-- ddl-end --
ALTER TABLE reseau.union_eau_potable OWNER TO sig;
-- ddl-end --

-- object: union_eau_usee_geom_1509978544916 | type: INDEX --
-- DROP INDEX IF EXISTS reseau.union_eau_usee_geom_1509978544916 CASCADE;
CREATE INDEX union_eau_usee_geom_1509978544916 ON reseau.union_eau_usee
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: union_eau_pluviale_geom_1509978544925 | type: INDEX --
-- DROP INDEX IF EXISTS reseau.union_eau_pluviale_geom_1509978544925 CASCADE;
CREATE INDEX union_eau_pluviale_geom_1509978544925 ON reseau.union_eau_pluviale
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: union_fibre_geom_1509978544934 | type: INDEX --
-- DROP INDEX IF EXISTS reseau.union_fibre_geom_1509978544934 CASCADE;
CREATE INDEX union_fibre_geom_1509978544934 ON reseau.union_fibre
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: union_eau_potable_geom_1509978544938 | type: INDEX --
-- DROP INDEX IF EXISTS reseau.union_eau_potable_geom_1509978544938 CASCADE;
CREATE INDEX union_eau_potable_geom_1509978544938 ON reseau.union_eau_potable
	USING gist
	(
	  geom
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: dict.appli_dict_protocol_mail_protocol_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS dict.appli_dict_protocol_mail_protocol_id_seq CASCADE;
CREATE SEQUENCE dict.appli_dict_protocol_mail_protocol_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE dict.appli_dict_protocol_mail_protocol_id_seq OWNER TO sig;
-- ddl-end --

-- object: dict.appli_dict_protocol_mail | type: TABLE --
-- DROP TABLE IF EXISTS dict.appli_dict_protocol_mail CASCADE;
CREATE TABLE dict.appli_dict_protocol_mail(
	protocol_id integer NOT NULL DEFAULT nextval('dict.appli_dict_protocol_mail_protocol_id_seq'::regclass),
	nom_protocol character varying(50) NOT NULL,
	protocol_mail text[] NOT NULL,
	CONSTRAINT pk_appli_dict_protocol_mail PRIMARY KEY (protocol_id),
	CONSTRAINT appli_dict_protocol_mail_nom_protocol_key UNIQUE (nom_protocol)

);
-- ddl-end --
ALTER TABLE dict.appli_dict_protocol_mail OWNER TO sig;
-- ddl-end --

-- object: idx_poly_num_dict | type: INDEX --
-- DROP INDEX IF EXISTS dict.idx_poly_num_dict CASCADE;
CREATE INDEX idx_poly_num_dict ON dict.appli_dict_polygon
	USING btree
	(
	  num_dict
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_union_eau_potable_param | type: INDEX --
-- DROP INDEX IF EXISTS reseau.idx_union_eau_potable_param CASCADE;
CREATE INDEX idx_union_eau_potable_param ON reseau.union_eau_potable
	USING btree
	(
	  param_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_union_eau_pluviale_param | type: INDEX --
-- DROP INDEX IF EXISTS reseau.idx_union_eau_pluviale_param CASCADE;
CREATE INDEX idx_union_eau_pluviale_param ON reseau.union_eau_pluviale
	USING btree
	(
	  param_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_union_eau_usee_param | type: INDEX --
-- DROP INDEX IF EXISTS reseau.idx_union_eau_usee_param CASCADE;
CREATE INDEX idx_union_eau_usee_param ON reseau.union_eau_usee
	USING btree
	(
	  param_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: idx_union_fibre_param | type: INDEX --
-- DROP INDEX IF EXISTS reseau.idx_union_fibre_param CASCADE;
CREATE INDEX idx_union_fibre_param ON reseau.union_fibre
	USING btree
	(
	  param_id
	)	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: fk_user_profil | type: CONSTRAINT --
-- ALTER TABLE dict.appli_dict_user DROP CONSTRAINT IF EXISTS fk_user_profil CASCADE;
ALTER TABLE dict.appli_dict_user ADD CONSTRAINT fk_user_profil FOREIGN KEY (profil_id)
REFERENCES dict.appli_dict_profil_user (profil_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_user_protocol_mail | type: CONSTRAINT --
-- ALTER TABLE dict.appli_dict_user DROP CONSTRAINT IF EXISTS fk_user_protocol_mail CASCADE;
ALTER TABLE dict.appli_dict_user ADD CONSTRAINT fk_user_protocol_mail FOREIGN KEY (protocol_id)
REFERENCES dict.appli_dict_protocol_mail (protocol_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_group_param | type: CONSTRAINT --
-- ALTER TABLE dict.appli_dict_param DROP CONSTRAINT IF EXISTS fk_group_param CASCADE;
ALTER TABLE dict.appli_dict_param ADD CONSTRAINT fk_group_param FOREIGN KEY (group_id)
REFERENCES dict.appli_dict_group (group_id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_user_id_param | type: CONSTRAINT --
-- ALTER TABLE dict.appli_dict_user_group_param DROP CONSTRAINT IF EXISTS fk_user_id_param CASCADE;
ALTER TABLE dict.appli_dict_user_group_param ADD CONSTRAINT fk_user_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_group_id_user | type: CONSTRAINT --
-- ALTER TABLE dict.appli_dict_user_group_param DROP CONSTRAINT IF EXISTS fk_group_id_user CASCADE;
ALTER TABLE dict.appli_dict_user_group_param ADD CONSTRAINT fk_group_id_user FOREIGN KEY (group_id)
REFERENCES dict.appli_dict_group (group_id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_user_id_group | type: CONSTRAINT --
-- ALTER TABLE dict.appli_dict_user_group_param DROP CONSTRAINT IF EXISTS fk_user_id_group CASCADE;
ALTER TABLE dict.appli_dict_user_group_param ADD CONSTRAINT fk_user_id_group FOREIGN KEY (user_id)
REFERENCES dict.appli_dict_user (user_id) MATCH SIMPLE
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_polygon_id_param | type: CONSTRAINT --
-- ALTER TABLE dict.appli_dict_polygon DROP CONSTRAINT IF EXISTS fk_polygon_id_param CASCADE;
ALTER TABLE dict.appli_dict_polygon ADD CONSTRAINT fk_polygon_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_polygon_id_group | type: CONSTRAINT --
-- ALTER TABLE dict.appli_dict_polygon DROP CONSTRAINT IF EXISTS fk_polygon_id_group CASCADE;
ALTER TABLE dict.appli_dict_polygon ADD CONSTRAINT fk_polygon_id_group FOREIGN KEY (group_id)
REFERENCES dict.appli_dict_group (group_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_fibre_id_param | type: CONSTRAINT --
-- ALTER TABLE reseau.fibre DROP CONSTRAINT IF EXISTS fk_fibre_id_param CASCADE;
ALTER TABLE reseau.fibre ADD CONSTRAINT fk_fibre_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_eau_pluviale_id_param | type: CONSTRAINT --
-- ALTER TABLE reseau.eau_pluviale DROP CONSTRAINT IF EXISTS fk_eau_pluviale_id_param CASCADE;
ALTER TABLE reseau.eau_pluviale ADD CONSTRAINT fk_eau_pluviale_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_eau_potable_id_param | type: CONSTRAINT --
-- ALTER TABLE reseau.eau_potable DROP CONSTRAINT IF EXISTS fk_eau_potable_id_param CASCADE;
ALTER TABLE reseau.eau_potable ADD CONSTRAINT fk_eau_potable_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_eau_usee_id_param | type: CONSTRAINT --
-- ALTER TABLE reseau.eau_usee DROP CONSTRAINT IF EXISTS fk_eau_usee_id_param CASCADE;
ALTER TABLE reseau.eau_usee ADD CONSTRAINT fk_eau_usee_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_union_eau_pluviale_id_param | type: CONSTRAINT --
-- ALTER TABLE reseau.union_eau_pluviale DROP CONSTRAINT IF EXISTS fk_union_eau_pluviale_id_param CASCADE;
ALTER TABLE reseau.union_eau_pluviale ADD CONSTRAINT fk_union_eau_pluviale_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_union_eau_usee_id_param | type: CONSTRAINT --
-- ALTER TABLE reseau.union_eau_usee DROP CONSTRAINT IF EXISTS fk_union_eau_usee_id_param CASCADE;
ALTER TABLE reseau.union_eau_usee ADD CONSTRAINT fk_union_eau_usee_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_union_fibre_id_param | type: CONSTRAINT --
-- ALTER TABLE reseau.union_fibre DROP CONSTRAINT IF EXISTS fk_union_fibre_id_param CASCADE;
ALTER TABLE reseau.union_fibre ADD CONSTRAINT fk_union_fibre_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_union_eau_potable_id_param | type: CONSTRAINT --
-- ALTER TABLE reseau.union_eau_potable DROP CONSTRAINT IF EXISTS fk_union_eau_potable_id_param CASCADE;
ALTER TABLE reseau.union_eau_potable ADD CONSTRAINT fk_union_eau_potable_id_param FOREIGN KEY (param_id)
REFERENCES dict.appli_dict_param (param_id) MATCH SIMPLE
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.geometry | type: TYPE --
-- DROP TYPE IF EXISTS public.geometry CASCADE;
CREATE TYPE public.geometry;
-- ddl-end --

-- object: grant_dd69c7400b | type: PERMISSION --
GRANT CREATE,USAGE
   ON SCHEMA cadastre
   TO sig;
-- ddl-end --

-- object: grant_e507fe3aae | type: PERMISSION --
GRANT CREATE,USAGE
   ON SCHEMA dict
   TO sig;
-- ddl-end --

-- object: grant_bfada35a1e | type: PERMISSION --
GRANT CREATE,USAGE
   ON SCHEMA reseau
   TO sig;
-- ddl-end --


