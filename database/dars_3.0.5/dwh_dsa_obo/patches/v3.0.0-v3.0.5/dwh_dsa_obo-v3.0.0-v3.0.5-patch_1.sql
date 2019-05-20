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


-- Drop table and recreate the table with new columns:
DROP TABLE   public.mon__data_collection_source;
CREATE TABLE public.mon__data_collection_source (
    dcs_id                   BIGINT               not null,
    source_hostname          VARCHAR(50)          not null,
    source_component_name    VARCHAR(50)          not null,
    created_on               TIMESTAMP            not null,    -- new column
    last_updated_on          TIMESTAMP            not null,
    etl_batch_id_insert      BIGINT               not null,
    etl_batch_id_last_update BIGINT               null
);
ALTER TABLE ONLY public.mon__data_collection_source ADD CONSTRAINT pk_mon__data_collection_source PRIMARY KEY (dcs_id);
CREATE INDEX ix_mon__data_collection_source_01 ON public.mon__data_collection_source (last_updated_on);


-- Drop table and recreate the table with new columns:
DROP TABLE   public.mon__managed_objects;
CREATE TABLE public.mon__managed_objects (
    managed_object_id        BIGINT               not null,
    managed_object_name      VARCHAR(50)          not null,
    created_on               TIMESTAMP            not null,    -- new column
    last_updated_on          TIMESTAMP            not null,
    etl_batch_id_insert      BIGINT               not null,
    etl_batch_id_last_update BIGINT               null
);
ALTER TABLE ONLY public.mon__managed_objects ADD CONSTRAINT pk_mon__managed_objects PRIMARY KEY (managed_object_id);
CREATE INDEX ix_mon__managed_object_01 ON public.mon__managed_objects (last_updated_on);


-- Drop table and recreate the table with new columns:
DROP TABLE   public.obo__analysis_results;
CREATE TABLE public.obo__analysis_results (
    analysis_result_id           BIGINT               not null,
    analysis_result_type_id      SMALLINT             not null,
    passage_event_id             BIGINT               not null, -- new column
    pedd_id                      BIGINT               null,
    licence_plate_country_code   VARCHAR(2)           null,     -- new column
    licence_plate_number         VARCHAR(14)          null,
    scheme_liability_category_id SMALLINT             null,     -- new column
    axle_tariff_category_id      SMALLINT             null,     -- new column
    last_updated_on              TIMESTAMP            not null,
    etl_batch_id_insert          BIGINT               not null,
    etl_batch_id_last_update     BIGINT               null
);
ALTER TABLE ONLY public.obo__analysis_results ADD CONSTRAINT pk_obo__analysis_results PRIMARY KEY (analysis_result_id);
CREATE INDEX ix_obo__analysis_results_01 ON public.obo__analysis_results (last_updated_on);
-- Requested by Bjørn Tore 2018.11.26:
CREATE INDEX ix_obo__analysis_results_02 on public.obo__analysis_results (
    analysis_result_type_id,
    scheme_liability_category_id
);
--
---- This is an alternate way to add the new columns to the table, but the added sophistication is not needed:
--
--TRUNCATE public.obo__analysis_results;  -- So that the new columns will be define properly, even for old/existing rows
---- This block of SQL effectively patches the structure of the
---- obo__analysis_results table as follows:
----
----     ALTER TABLE public.obo__analysis_results ADD COLUMN passage_event_id             bigint not null;
----     ALTER TABLE public.obo__analysis_results ADD COLUMN licence_plate_country_code   character varying(2);
----     ALTER TABLE public.obo__analysis_results ADD COLUMN scheme_liability_category_id smallint;
----     ALTER TABLE public.obo__analysis_results ADD COLUMN axle_tariff_category_id      smallint;
----
--ALTER TABLE public.obo__analysis_results DROP CONSTRAINT IF EXISTS pk_obo__analysis_results;
--DROP INDEX IF EXISTS ix_obo__analysis_results_01;
--SELECT COUNT(*) AS "obo__analysis_results rows (before)" FROM public.obo__analysis_results;
--ALTER TABLE public.obo__analysis_results RENAME TO tmp_obo__analysis_results;
--CREATE TABLE public.obo__analysis_results (
--    analysis_result_id           BIGINT               not null,
--    analysis_result_type_id      SMALLINT             not null,
--    passage_event_id             BIGINT               not null, -- new column
--    pedd_id                      BIGINT               null,
--    licence_plate_country_code   VARCHAR(2)           null,     -- new column
--    licence_plate_number         VARCHAR(14)          null,
--    scheme_liability_category_id SMALLINT             null,     -- new column
--    axle_tariff_category_id      SMALLINT             null,     -- new column
--    last_updated_on              TIMESTAMP            not null,
--    etl_batch_id_insert          BIGINT               not null,
--    etl_batch_id_last_update     BIGINT               null
--);
--ALTER TABLE ONLY public.obo__analysis_results ADD CONSTRAINT pk_obo__analysis_results PRIMARY KEY (analysis_result_id);
--INSERT INTO public.obo__analysis_results (
--    analysis_result_id,
--    analysis_result_type_id,
--    passage_event_id,                -- new column
--    pedd_id,
--    licence_plate_country_code,      -- new column
--    licence_plate_number,
--    scheme_liability_category_id,    -- new column
--    axle_tariff_category_id,         -- new column
--    last_updated_on,
--    etl_batch_id_insert,
--    etl_batch_id_last_update
--)
--SELECT
--    analysis_result_id,
--    analysis_result_type_id,
--    null,                            -- new column  <- Not allowed because of "NOT NULL" column constraint
--    pedd_id,
--    null,                            -- new column
--    licence_plate_number,
--    null,                            -- new column
--    null,                            -- new column
--    last_updated_on,
--    etl_batch_id_insert,
--    etl_batch_id_last_update
--FROM
--    public.tmp_obo__analysis_results;
--CREATE INDEX ix_obo__analysis_results_01 ON public.obo__analysis_results (last_updated_on);
--CREATE INDEX ix_obo__analysis_results_02 on public.obo__analysis_results (
--    analysis_result_type_id,
--    scheme_liability_category_id
--);
--SELECT COUNT(*) AS "obo__analysis_results rows (after)" FROM public.obo__analysis_results;
--DROP TABLE public.tmp_obo__analysis_results;  -- should only be executed if there were no errors above


-- Drop table and recreate the table with new columns:
DROP TABLE   public.obo__compliance_case_register;
CREATE TABLE public.obo__compliance_case_register (
    compliance_case_id        BIGINT               not null,
    compliance_case_type_id   SMALLINT             not null,
    compliance_case_status_id SMALLINT             not null,
    registered_on             TIMESTAMP            not null,    -- new column
    last_updated_on           TIMESTAMP            not null,
    etl_batch_id_insert       BIGINT               not null,
    etl_batch_id_last_update  BIGINT               null,
    CONSTRAINT PK_OBO__COMPLIANCE_CASE_REGIST PRIMARY KEY (compliance_case_id)
);
CREATE INDEX ix_obo__compliance_case_register_01 ON public.obo__compliance_case_register (last_updated_on);


-- New table added to DSA.
CREATE TABLE IF NOT EXISTS public.obo__control_point_event_capture_category (
    control_point_event_capture_category_id SMALLINT             not null,
    enum_name                               VARCHAR(30)          not null,
    description                             VARCHAR(50)          not null,
    etl_batch_id_insert                     BIGINT               not null,
    etl_batch_id_last_update                BIGINT               null,
    CONSTRAINT PK_OBO__CONTROL_POINT_EVENT_CA PRIMARY KEY (control_point_event_capture_category_id)
);


-- Drop table and recreate the table with new columns:
DROP TABLE   public.obo__passage_event;
CREATE TABLE public.obo__passage_event (
    passage_event_id                           BIGINT                      not null,
    passage_event_type_id                      SMALLINT                    not null,
    data_arrival_timestamp                     timestamp without time zone not null,
    passage_event_timestamp                    timestamp without time zone not null,
    control_point_id                           SMALLINT                    not null,
    control_point_event_capture_category_id    SMALLINT                    not null,
    charged_road_section_id                    BIGINT                      not null,
    obu_count                                  SMALLINT                    not null,    -- new column
    vehicle_image_count                        smallint                    not null,    -- new column
    detected_scheme_liability_category_id      SMALLINT                    not null,
    detected_scheme_compliance_category_id     SMALLINT                    not null,
    detected_scheme_compliance_sub_category_id SMALLINT                    not null,
    detected_axle_tariff_category_id           smallint                    null,         -- new column
    detected_lpn_country_code                  character varying(2)        null,         -- new column
    detected_lpn_number                        character varying(14)       null,         -- new column
    declared_axle_tariff_category_id           smallint                    null,         -- new column
    declared_euro_emission_class_id            smallint                    null,         -- new column
    declared_lpn_country_code                  character varying(2)        null,         -- new column
    declared_lpn_number                        character varying(14)       null,         -- new column
    etl_batch_id_insert                        BIGINT                      not null,
    etl_batch_id_last_update                   BIGINT                      null,
    CONSTRAINT pk_obo__passage_event PRIMARY KEY (passage_event_id)
);
-- Requested by Bjørn Tore 2018.11.26:
CREATE INDEX ix_obo__passage_event_01 ON public.obo__passage_event (
    passage_event_timestamp
);


-- Drop table and recreate the table with new columns:
DROP TABLE   public.obo__passage_event_derived_data_details;
CREATE TABLE public.obo__passage_event_derived_data_details (
    pedd_id                              BIGINT                      not null,
    created_on                           timestamp without time zone not null,    -- new column
    last_updated_on                      timestamp without time zone not null,
    passage_event_type_id                SMALLINT                    not null,    -- new column
    passage_event_timestamp              timestamp without time zone not null,    -- new column
    control_point_id                     SMALLINT                    not null,    -- new column
    obu_present                          boolean                     not null,    -- new column
    applied_scheme_liability_category_id SMALLINT                    not null,    -- new column
    applied_axle_tariff_category_id      SMALLINT                    not null,
    applied_euro_emission_class_id       SMALLINT                    not null,
    applied_lpn_country                  character varying(2)        null,
    applied_lpn_number                   character varying(14)       null,        -- new column
    applied_payment_means_pan            character varying(19)       null,        -- new column
    applied_obuid                        character varying(15)       null,        -- new column
    base_rate_total                      INTEGER                     not null,
    etl_batch_id_insert                  BIGINT                      not null,
    etl_batch_id_last_update             BIGINT                      null
);
ALTER TABLE ONLY public.obo__passage_event_derived_data_details ADD CONSTRAINT PK_OBO__PE_DERIVED_DD PRIMARY KEY (pedd_id);
CREATE INDEX ix_obo__passage_event_derived_data_details_01 ON public.obo__passage_event_derived_data_details (last_updated_on);


-- https://issues.q-free.com/browse/QFC-BODARS-2618:
--
-- Drop table and recreate the table with the new columns:
DROP TABLE   public.obo__passage_event_rse_logic_data;
CREATE TABLE public.obo__passage_event_rse_logic_data (
    perseld_id                           bigint                      not null,
    passage_event_id                     bigint                      not null,
    rse_passage_type_id                  smallint                    null,        -- new column
    rse_compliance_check_axles_check_id  smallint                    null,
    etl_batch_id_insert                  BIGINT                      not null,
    etl_batch_id_last_update             BIGINT                      null         -- new column
);
ALTER TABLE ONLY public.obo__passage_event_rse_logic_data ADD CONSTRAINT pk_obo__passage_event_rse_logi PRIMARY KEY (perseld_id);
--
-- Requested by Bjørn Tore 2018.11.26:
CREATE INDEX IF NOT EXISTS ix_obo__passage_event_rse_logic_data_01 ON public.obo__passage_event_rse_logic_data (
    rse_compliance_check_axles_check_id
);
CREATE INDEX IF NOT EXISTS ix_obo__passage_event_rse_logic_data_02 ON public.obo__passage_event_rse_logic_data (
    passage_event_id
);


-- New table added to DSA.
CREATE TABLE IF NOT EXISTS public.obo__rate_modification_category (
    rate_modification_category_id SMALLINT             not null,
    enum_name                     VARCHAR(30)          not null,
    description                   VARCHAR(50)          not null,
    etl_batch_id_insert           BIGINT               not null,
    etl_batch_id_last_update      BIGINT               null,
    CONSTRAINT PK_OBO__RATE_MODIFICATION_CATE PRIMARY KEY (rate_modification_category_id)
);


-- Drop table and recreate the table with new columns:
DROP TABLE   public.obo__road_section;
CREATE TABLE public.obo__road_section (
   road_section_id           BIGINT               not null,
   road_segment_id           BIGINT               not null,
   road_scheme_validity_id   BIGINT               not null,
   road_section_identifier   VARCHAR(2)           not null,
   description               VARCHAR(50)          not null,
   tollable_distance         SMALLINT             not null,
   charged_object_identifier VARCHAR(10)          not null,
   alternative_identifier    VARCHAR(1024)        null,        -- new column
   etl_batch_id_insert       BIGINT               not null,
   etl_batch_id_last_update  BIGINT               null,
   CONSTRAINT PK_OBO__ROAD_SECTION PRIMARY KEY (road_section_id)
);
