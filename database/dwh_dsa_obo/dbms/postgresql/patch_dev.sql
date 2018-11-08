-- This file contains patch code in development for the dwh_dsa_obo database.
--
-- While the SQL in the file can be executed for testing during development, it
-- must be integrated elsewhere for updating the dwh_dsa_obo installation script
-- or upgrade script.


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
CREATE INDEX ix_mon__data_collection_source_last_updated_on ON public.mon__data_collection_source (last_updated_on);


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
CREATE INDEX ix_mon__managed_objects_last_updated_on ON public.mon__managed_objects (last_updated_on);


-- Drop table and recreate the table with new columns:
DROP TABLE   public.obo__analysis_results;
CREATE TABLE public.obo__analysis_results (
    analysis_result_id           BIGINT               not null,
    analysis_result_type_id      SMALLINT             not null,
    pedd_id                      BIGINT               null,
    licence_plate_country_code   VARCHAR(2)           null,    -- new column
    licence_plate_number         VARCHAR(14)          null,
    scheme_liability_category_id SMALLINT             null,    -- new column
    axle_tariff_category_id      SMALLINT             null,    -- new column
    last_updated_on              TIMESTAMP            not null,
    etl_batch_id_insert          BIGINT               not null,
    etl_batch_id_last_update     BIGINT               null
);
ALTER TABLE ONLY public.obo__analysis_results ADD CONSTRAINT pk_obo__analysis_results PRIMARY KEY (pedd_id);
CREATE INDEX ix_obo__analysis_results_last_updated_on ON public.obo__analysis_results (last_updated_on);
--
---- This is an alternate way to add the new columns to the table, but the added sophistication is not needed:
--
--TRUNCATE public.obo__analysis_results;  -- So that the new columns will be define properly, even for old/existing rows
---- This block of SQL effectively patches the structure of the
---- obo__analysis_results table as follows:
----
----     ALTER TABLE public.obo__analysis_results ADD COLUMN licence_plate_country_code   character varying(2);
----     ALTER TABLE public.obo__analysis_results ADD COLUMN scheme_liability_category_id smallint;
----     ALTER TABLE public.obo__analysis_results ADD COLUMN axle_tariff_category_id      smallint;
----
--ALTER TABLE public.obo__analysis_results DROP CONSTRAINT IF EXISTS obo__analysis_results;
--DROP INDEX IF EXISTS ix_obo__analysis_results_01;
--SELECT COUNT(*) AS "obo__analysis_results rows (before)" FROM public.obo__analysis_results;
--ALTER TABLE public.obo__analysis_results RENAME TO tmp_obo__analysis_results;
--CREATE TABLE public.obo__analysis_results (
--    analysis_result_id           BIGINT               not null,
--    analysis_result_type_id      SMALLINT             not null,
--    pedd_id                      BIGINT               null,
--    licence_plate_country_code   VARCHAR(2)           null,    -- new column
--    licence_plate_number         VARCHAR(14)          null,
--    scheme_liability_category_id SMALLINT             null,    -- new column
--    axle_tariff_category_id      SMALLINT             null,    -- new column
--    last_updated_on              TIMESTAMP            not null,
--    etl_batch_id_insert          BIGINT               not null,
--    etl_batch_id_last_update     BIGINT               null
--);
--ALTER TABLE ONLY public.obo__analysis_results ADD CONSTRAINT pk_obo__analysis_results PRIMARY KEY (pedd_id);
--INSERT INTO public.obo__analysis_results (
--    analysis_result_id,
--    analysis_result_type_id,
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
--CREATE INDEX ix_obo__analysis_results_last_updated_on ON public.obo__analysis_results (last_updated_on);
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
    CONSTRAINT pk_obo__compliance_case_register PRIMARY KEY (compliance_case_id)
);
CREATE INDEX ix_obo__compliance_case_register_last_updated_on ON public.obo__compliance_case_register (last_updated_on);


-- New table added to DSA.
CREATE TABLE  public.obo__control_point_event_capture_category (
    control_point_event_capture_category_id SMALLINT             not null,
    enum_name                               VARCHAR(30)          not null,
    description                             VARCHAR(50)          not null,
    etl_batch_id_insert                     BIGINT               not null,
    etl_batch_id_last_update                BIGINT               null,
    CONSTRAINT pk_obo__control_point_event_capture_category PRIMARY KEY (control_point_event_capture_category_id)
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


-- Drop table and recreate the table with new columns:
DROP TABLE   public.obo__passage_event_derived_data_details;
CREATE TABLE public.obo__passage_event_derived_data_details (
    pedd_id                              BIGINT                      not null,
    created_on                           timestamp without time zone not null,    -- new column
    passage_event_timestamp              timestamp without time zone not null,    -- new column
    obu_present                          boolean                     not null,    -- new column
    applied_scheme_liability_category_id smallint                    not null,    -- new column
    applied_axle_tariff_category_id      SMALLINT                    not null,
    applied_euro_emission_class_id       SMALLINT                    not null,
    applied_lpn_country                  character varying(2)        null,
    applied_lpn_number                   character varying(14)       null,        -- new column
    applied_payment_means_pan            character varying(19)       null,        -- new column
    applied_obuid                        character varying(15)       null,        -- new column
    base_rate_total                      INTEGER                     not null,
    last_updated_on                      timestamp without time zone not null,
    etl_batch_id_insert                  BIGINT                      not null,
    etl_batch_id_last_update             BIGINT                      null
);
ALTER TABLE ONLY public.obo__passage_event_derived_data_details ADD CONSTRAINT pk_obo__passage_event_derived_data_details PRIMARY KEY (pedd_id);
CREATE INDEX ix_obo__passage_event_derived_data_details_last_updated_on ON public.obo__passage_event_derived_data_details (last_updated_on);
--
---- This is an alternate way to add the new columns to the table, but the added sophistication is not needed:
--
--TRUNCATE public.obo__passage_event_derived_data_details;  -- So that the new columns will be define properly, even for old/existing rows
---- This block of SQL effectively patches the structure of the
---- obo__passage_event_derived_data_details table as follows:
----
----     ALTER TABLE public.obo__passage_event_derived_data_details ADD COLUMN passage_event_timestamp              timestamp without time zone not null;
----     ALTER TABLE public.obo__passage_event_derived_data_details ADD COLUMN obu_present                          boolean                     not null;
----     ALTER TABLE public.obo__passage_event_derived_data_details ADD COLUMN applied_scheme_liability_category_id smallint                    not null;
----     ALTER TABLE public.obo__passage_event_derived_data_details ADD COLUMN applied_lpn_number                   character varying(14);
----     ALTER TABLE public.obo__passage_event_derived_data_details ADD COLUMN applied_payment_means_pan            character varying(19);
----     ALTER TABLE public.obo__passage_event_derived_data_details ADD COLUMN applied_obuid                        character varying(15);
----
--ALTER TABLE public.obo__passage_event_derived_data_details DROP CONSTRAINT IF EXISTS pk_obo__pe_derived_dd;
--DROP INDEX IF EXISTS ix_obo__passage_event_derived_data_details_01;
--SELECT COUNT(*) AS "obo__passage_event_derived_data_details rows (before)" FROM public.obo__passage_event_derived_data_details;
--ALTER TABLE public.obo__passage_event_derived_data_details RENAME TO tmp_obo__passage_event_derived_data_details;
--CREATE TABLE public.obo__passage_event_derived_data_details (
--    pedd_id                              BIGINT                      not null,
--    passage_event_timestamp              timestamp without time zone not null,    -- new column
--    obu_present                          boolean                     not null,    -- new column
--    applied_scheme_liability_category_id smallint                    not null,    -- new column
--    applied_axle_tariff_category_id      SMALLINT                    not null,
--    applied_euro_emission_class_id       SMALLINT                    not null,
--    applied_lpn_country                  character varying(2)        null,
--    applied_lpn_number                   character varying(14)       null,        -- new column
--    applied_payment_means_pan            character varying(19)       null,        -- new column
--    applied_obuid                        character varying(15)       null,        -- new column
--    base_rate_total                      INTEGER                     not null,
--    last_updated_on                      TIMESTAMP                   not null,
--    etl_batch_id_insert                  BIGINT                      not null,
--    etl_batch_id_last_update             BIGINT                      null
--);
--ALTER TABLE ONLY public.obo__passage_event_derived_data_details ADD CONSTRAINT pk_obo__passage_event_derived_data_details PRIMARY KEY (pedd_id);
--INSERT INTO public.obo__passage_event_derived_data_details (
--    pedd_id,
--    passage_event_timestamp,                 -- new column
--    obu_present,                             -- new column
--    applied_scheme_liability_category_id,    -- new column
--    applied_axle_tariff_category_id,
--    applied_euro_emission_class_id,
--    applied_lpn_country,
--    applied_lpn_number,                       -- new column
--    applied_payment_means_pan,                -- new column
--    applied_obuid,                            -- new column
--    base_rate_total,
--    last_updated_on,
--    etl_batch_id_insert,
--    etl_batch_id_last_update
--)
--SELECT
--   pedd_id,
--   null,                                     -- new column
--   null,                                     -- new column
--   null,                                     -- new column
--   applied_axle_tariff_category_id,
--   applied_euro_emission_class_id,
--   applied_lpn_country,
--   null,                                     -- new column
--   null,                                     -- new column
--   null,                                     -- new column
--   base_rate_total,
--   last_updated_on,
--   etl_batch_id_insert,
--   etl_batch_id_last_update
--FROM
--    public.tmp_obo__passage_event_derived_data_details;
--CREATE INDEX ix_obo__passage_event_derived_data_details_last_updated_on ON public.obo__passage_event_derived_data_details (last_updated_on);
--SELECT COUNT(*) AS "obo__passage_event_derived_data_details rows (after)" FROM public.obo__passage_event_derived_data_details;
--DROP TABLE public.tmp_obo__passage_event_derived_data_details;  -- should only be executed if there were no errors above


-- New table added to DSA.
CREATE TABLE  public.obo__rate_modification_category (
    rate_modification_category_id SMALLINT             not null,
    enum_name                     VARCHAR(30)          not null,
    description                   VARCHAR(50)          not null,
    etl_batch_id_insert           BIGINT               not null,
    etl_batch_id_last_update      BIGINT               null,
    CONSTRAINT pk_obo__rate_modification_category PRIMARY KEY (rate_modification_category_id)
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
   CONSTRAINT pk_obo__road_section PRIMARY KEY (road_section_id)
);
