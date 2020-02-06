-- This file contains patch code in development for the dwh_dsa_obo database.
--
-- While the SQL in the file can be executed for testing during development, it
-- must be integrated elsewhere for updating the dwh_dsa_obo installation script
-- or upgrade script, e.g., in the scripts:
--
--   si-dars-solution/env-init/dev2/trdci0912/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql
--   si-dars-solution/env-init/prd/si01-prd-08cl/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql
--   si-dars-solution/env-init/qfr/si01-qfr-08cl/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql
--   si-dars-solution/env-init/stg/si01-stg-08cl/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql
--   si-dars-solution/env-init/uat/si01-uat-08cl/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql



-- mon_opr:

ALTER TABLE public.mon__alarm             ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.mon__alarm_action_type ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.mon__alarm_actions     ADD COLUMN etl_batch_id_last_update bigint;


-- obo_opr:

-- These tables are no longer needed in the DSA so they are being removed:
DROP TABLE IF EXISTS public.obo__passage_event_derived_data_with_rating CASCADE;
DROP TABLE IF EXISTS public.obo__analysis_queue CASCADE;


-- New tables and columns added to DSA tables:

-- The following columns were added to table obo__analysis_request:
-- 
--     analysis_request_type_id
--     analysis_request_status_id
--     analysis_request_status_timestamp
--     analysis_result_id
DROP TABLE IF EXISTS public.obo__analysis_request CASCADE;
CREATE TABLE public.obo__analysis_request (
   analysis_request_id               BIGINT               not null,
   analysis_request_type_id          SMALLINT             not null,             -- new column
   analysis_request_status_id        SMALLINT             not null,             -- new column
   analysis_request_status_timestamp TIMESTAMP            not null,             -- new column
   passage_event_id                  BIGINT               not null,
   analysis_result_id                BIGINT               null,                 -- new column
   pedd_id                           BIGINT               not null,
   etl_batch_id_insert               BIGINT               not null,
   etl_batch_id_last_update          BIGINT               null,
   CONSTRAINT PK_OBO__ANALYSIS_REQUEST PRIMARY KEY (analysis_request_id)
);
CREATE INDEX ix_obo__analysis_request_01 ON obo__analysis_request (analysis_request_status_timestamp);

-- Add table to DSA.
DROP TABLE IF EXISTS public.obo__analysis_request_status CASCADE;
CREATE TABLE public.obo__analysis_request_status(
	analysis_request_status_id smallint              NOT NULL,
	enum_name                  character varying(30) NOT NULL,
	description                character varying(50) NOT NULL,
	etl_batch_id_insert        bigint                NOT NULL,
	etl_batch_id_last_update   bigint,
	CONSTRAINT pk_obo__analysis_request_statu PRIMARY KEY (analysis_request_status_id)
);

-- Add table to DSA.
DROP TABLE IF EXISTS public.obo__analysis_request_type CASCADE;
CREATE TABLE public.obo__analysis_request_type(
	analysis_request_type_id smallint              NOT NULL,
	enum_name                character varying(30) NOT NULL,
	description              character varying(50) NOT NULL,
	etl_batch_id_insert      bigint                NOT NULL,
	etl_batch_id_last_update bigint,
	CONSTRAINT pk_obo__analysis_request_type PRIMARY KEY (analysis_request_type_id)
);

-- The following column was added to table obo__analysis_results:
-- 
--     analysis_result_status_timestamp
DROP TABLE IF EXISTS public.obo__analysis_results CASCADE;
CREATE TABLE public.obo__analysis_results (
   analysis_result_id               BIGINT               not null,
   analysis_result_type_id          SMALLINT             not null,
   analysis_result_status_id        SMALLINT             not null,
   analysis_result_status_timestamp TIMESTAMP            not null,              -- new column
   passage_event_id                 BIGINT               not null,
   pedd_id                          BIGINT               null,
   licence_plate_country_code       VARCHAR(2)           null,
   licence_plate_number             VARCHAR(14)          null,
   scheme_liability_category_id     SMALLINT             null,
   scheme_compliance_category_id    SMALLINT             null,
   axle_tariff_category_id          SMALLINT             null,
   last_updated_on                  TIMESTAMP            not null,
   etl_batch_id_insert              BIGINT               not null,
   etl_batch_id_last_update         BIGINT               null,
   CONSTRAINT PK_OBO__ANALYSIS_RESULTS PRIMARY KEY (analysis_result_id)
);
CREATE INDEX ix_obo__analysis_results_01 ON obo__analysis_results (last_updated_on);
CREATE INDEX ix_obo__analysis_results_02 ON obo__analysis_results (analysis_result_type_id, scheme_liability_category_id);
CREATE INDEX ix_obo__analysis_results_03 ON obo__analysis_results (passage_event_id);

-- Add table to DSA.
DROP TABLE IF EXISTS public.obo__analysis_result_status CASCADE;
CREATE TABLE public.obo__analysis_result_status(
	analysis_result_status_id smallint              NOT NULL,
	enum_name                 character varying(30) NOT NULL,
	description               character varying(50) NOT NULL,
	etl_batch_id_insert       bigint                NOT NULL,
	etl_batch_id_last_update  bigint,
	CONSTRAINT pk_obo__analysis_result_status PRIMARY KEY (analysis_result_status_id)
);

-- Add table to DSA.
DROP TABLE IF EXISTS public.obo__analysis_result_type CASCADE;
CREATE TABLE public.obo__analysis_result_type(
	analysis_result_type_id  smallint              NOT NULL,
	enum_name                character varying(30) NOT NULL,
	description              character varying(50) NOT NULL,
	etl_batch_id_insert      bigint                NOT NULL,
	etl_batch_id_last_update bigint,
	CONSTRAINT pk_obo__analysis_result_type PRIMARY KEY (analysis_result_type_id)
);

ALTER TABLE public.obo__applied_rating_detail_data ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__axle_tariff_category       ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__control_point_status       ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__control_point_type         ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__control_points             ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__country                    ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__dsrc_data_receipt          ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__euro_emissions_class       ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__obu_register_status        ADD COLUMN etl_batch_id_last_update bigint;

-- Add two columns to table: obo__passage_event_derived_data_details:
-- 
--     applied_scheme_compliance_category_id
--     applied_scheme_compliance_sub_category_id
DROP TABLE IF EXISTS public.obo__passage_event_derived_data_details CASCADE;
CREATE TABLE public.obo__passage_event_derived_data_details (
   pedd_id                                   BIGINT               not null,
   created_on                                TIMESTAMP            not null,
   identified_as_duplicate                   BOOLEAN              not null,
   identified_as_miscorrelated               BOOLEAN              null,
   last_updated_on                           TIMESTAMP            not null,
   passage_event_id                          BIGINT               null,
   passage_event_type_id                     SMALLINT             not null,
   passage_event_timestamp                   TIMESTAMP            not null,
   control_point_id                          SMALLINT             not null,
   obu_present                               BOOLEAN              not null,
   applied_scheme_liability_category_id      SMALLINT             not null,
   applied_scheme_compliance_category_id     SMALLINT             not null,     -- new column
   applied_scheme_compliance_sub_category_id SMALLINT             not null,     -- new column
   applied_axle_tariff_category_id           SMALLINT             not null,
   applied_euro_emission_class_id            SMALLINT             not null,
   applied_lpn_country                       VARCHAR(2)           null,
   applied_lpn_number                        VARCHAR(14)          null,
   applied_payment_means_pan                 VARCHAR(19)          null,
   applied_obuid                             VARCHAR(15)          null,
   base_rate_total                           INTEGER              not null,
   rate_modification_category_id             SMALLINT             not null,
   etl_batch_id_insert                       BIGINT               not null,
   etl_batch_id_last_update                  BIGINT               null,
   CONSTRAINT PK_OBO__PE_DERIVED_DD PRIMARY KEY (pedd_id)
);
CREATE INDEX ix_obo__passage_event_derived_data_details_01 ON obo__passage_event_derived_data_details (last_updated_on);

ALTER TABLE public.obo__passage_event_type                   ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__pedd_status                          ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__rate_component_fee_category          ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__rate_component_fee_type              ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__road_scheme_status                   ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__road_segments                        ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__roads                                ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__scheme_compliance_category           ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__scheme_compliance_sub_category       ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__topology_road_section_control_points ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__topology_road_sections               ADD COLUMN etl_batch_id_last_update bigint;
ALTER TABLE public.obo__topology_road_segments               ADD COLUMN etl_batch_id_last_update bigint;

