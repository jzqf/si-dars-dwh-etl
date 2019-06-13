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



-- obo_opr:


-- New table added to DSA:
CREATE TABLE IF NOT EXISTS public.obo__analysis_detailed_results (
   analysis_detailed_result_id     BIGINT               not null,
   analysis_result_id              BIGINT               not null,
   licence_plate_is_visible        BOOLEAN              null,
   licence_plate_is_human_readable BOOLEAN              null,
   licence_plate_is_obscured       BOOLEAN              null,
   licence_plate_is_missing        BOOLEAN              null,
   licence_plate_is_tampered       BOOLEAN              null,
   licence_plate_is_dirty          BOOLEAN              null,
   licence_plate_is_bad_condition  BOOLEAN              null,
   image_is_poor_quality           BOOLEAN              null,
   image_is_weather_affected       BOOLEAN              null,
   image_is_mispositioned          BOOLEAN              null,
   image_is_miscorrelated          BOOLEAN              null,
   etl_batch_id_insert             BIGINT               not null,
   etl_batch_id_last_update        BIGINT               null,
   CONSTRAINT PK_OBO__ANALYSIS_DETAILED_RESU PRIMARY KEY (analysis_detailed_result_id)
);


-- New table added to DSA:
CREATE TABLE IF NOT EXISTS public.obo__image (
   image_id                 BIGINT               not null,
   image_type_id            SMALLINT             not null,
   vehicle_image_id         BIGINT               not null,
   image_encoding_type_id   SMALLINT             not null,
   image_width              SMALLINT             not null,
   image_height             SMALLINT             not null,
   image_data_size          BIGINT               not null,
   file_id                  BIGINT               not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   CONSTRAINT PK_OBO__IMAGE PRIMARY KEY (image_id)
);


-- New table added to DSA:
CREATE TABLE IF NOT EXISTS public.obo__image_view (
   image_view_id            SMALLINT             not null,
   enum_name                VARCHAR(30)          not null,
   description              VARCHAR(50)          not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   CONSTRAINT PK_OBO__IMAGE_VIEW PRIMARY KEY (image_view_id)
);


-- New table added to DSA:
CREATE TABLE IF NOT EXISTS public.obo__passage_event_image_data (
   peid_id                        BIGINT               not null,
   pe_vehicle_data_id             BIGINT               not null,
   passage_event_id               BIGINT               not null,
   data_sequence_id               SMALLINT             not null,
   camera_id                      BIGINT               not null,
   capture_timestamp              TIMESTAMP            not null,
   captured_vehicle_image_view_id SMALLINT             not null,
   etl_batch_id_insert            BIGINT               not null,
   etl_batch_id_last_update       BIGINT               null,
   CONSTRAINT PK_OBO__PASSAGE_EVENT_IMAGE_DA PRIMARY KEY (peid_id)
);


-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__analysis_queue;
CREATE TABLE public.obo__analysis_queue (
   analysis_queue_id        BIGINT               not null,
   analysis_queue_status_id SMALLINT             null,             -- new column
   analysis_queue_type_id   SMALLINT             null,
   analysis_request_id      BIGINT               null,
   pedd_id                  BIGINT               null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   CONSTRAINT PK_OBO__ANALYSIS_QUEUE PRIMARY KEY (analysis_queue_id)
);


-- Drop table and then recreate the table with two new columns. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__analysis_results;
CREATE TABLE public.obo__analysis_results (
   analysis_result_id            BIGINT               not null,
   analysis_result_type_id       SMALLINT             not null,
   analysis_result_status_id     SMALLINT             not null,    -- new column
   passage_event_id              BIGINT               not null,
   pedd_id                       BIGINT               null,
   licence_plate_country_code    VARCHAR(2)           null,
   licence_plate_number          VARCHAR(14)          null,
   scheme_liability_category_id  SMALLINT             null,
   scheme_compliance_category_id SMALLINT             null,        -- new column
   axle_tariff_category_id       SMALLINT             null,
   last_updated_on               TIMESTAMP            not null,
   etl_batch_id_insert           BIGINT               not null,
   etl_batch_id_last_update      BIGINT               null,
   CONSTRAINT PK_OBO__ANALYSIS_RESULTS PRIMARY KEY (analysis_result_id)
);
CREATE INDEX ix_obo__analysis_results_01 ON obo__analysis_results (
    last_updated_on
);
CREATE INDEX ix_obo__analysis_results_02 ON obo__analysis_results (
    analysis_result_type_id,
    scheme_liability_category_id
);
CREATE INDEX ix_obo__analysis_results_03 ON obo__analysis_results (
    passage_event_id
);


-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__obu_register;
CREATE TABLE public.obo__obu_register (
   obu_register_id          BIGINT               not null,
   obu_register_status_id   SMALLINT             not null,
   manufacturer_id          INTEGER              not null,
   equipment_obu_id         BIGINT               null,           -- Column added
   first_seen_on            TIMESTAMP            not null,
   last_seen_on             TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   CONSTRAINT PK_OBO__OBU_REGISTER PRIMARY KEY (obu_register_id)
);
CREATE INDEX ix_obo__obu_register_01 ON obo__obu_register (
    last_seen_on
);


-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__passage_event;
CREATE TABLE public.obo__passage_event (
   passage_event_id                           BIGINT               not null,
   passage_event_type_id                      SMALLINT             not null,
   data_arrival_timestamp                     TIMESTAMP            not null,
   passage_event_timestamp                    TIMESTAMP            not null,
   control_point_id                           SMALLINT             not null,
   control_point_event_capture_category_id    SMALLINT             not null,
   charged_road_section_id                    BIGINT               not null,
   obu_present                                BOOLEAN              not null,    -- new column
   obu_count                                  SMALLINT             not null,
   vehicle_image_count                        SMALLINT             not null,
   detected_scheme_liability_category_id      SMALLINT             not null,
   detected_scheme_compliance_category_id     SMALLINT             not null,
   detected_scheme_compliance_sub_category_id SMALLINT             not null,
   detected_axle_tariff_category_id           SMALLINT             null,
   detected_lpn_country_code                  VARCHAR(2)           null,
   detected_lpn_number                        VARCHAR(14)          null,
   declared_axle_tariff_category_id           SMALLINT             null,
   declared_euro_emission_class_id            SMALLINT             null,
   declared_lpn_country_code                  VARCHAR(2)           null,
   declared_lpn_number                        VARCHAR(14)          null,
   cdc_timestamp                              TIMESTAMP            null,
   etl_batch_id_insert                        BIGINT               not null,
   etl_batch_id_last_update                   BIGINT               null,
   CONSTRAINT pk_obo__passage_event PRIMARY KEY (passage_event_id)
);
CREATE INDEX ix_obo__passage_event_01 ON public.obo__passage_event (passage_event_timestamp);
CREATE INDEX ix_obo__passage_event_02 ON public.obo__passage_event (cdc_timestamp);
CREATE INDEX ix_obo__passage_event_03 ON obo__passage_event (control_point_id);

-- Drop table and then recreate the table with two new columns. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__passage_event_derived_data;
CREATE TABLE public.obo__passage_event_derived_data (
   pedd_id                      BIGINT               not null,
   pedd_status_id               SMALLINT             not null,
   passage_event_id             BIGINT               not null,
   passage_event_timestamp      TIMESTAMP            not null,   -- Column added
   external_reference_timestamp TIMESTAMP            not null,   -- Column added
   created_on                   TIMESTAMP            not null,
   last_updated_on              TIMESTAMP            not null,
   etl_batch_id_insert          BIGINT               not null,
   etl_batch_id_last_update     BIGINT               null,
   CONSTRAINT PK_OBO__PASSAGE_EVENT_DERIVED_ PRIMARY KEY (pedd_id)
);
CREATE INDEX ix_obo__passage_event_derived_data_01 ON obo__passage_event_derived_data (
    last_updated_on
);
CREATE INDEX ix_obo__passage_event_derived_data_02 ON obo__passage_event_derived_data (
    passage_event_id
);

-- Drop table and then recreate the table with three new columns. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__passage_event_derived_data_details;
CREATE TABLE public.obo__passage_event_derived_data_details (
   pedd_id                              BIGINT               not null,
   created_on                           TIMESTAMP            not null,
   identified_as_duplicate              BOOLEAN              not null,   -- new column
   identified_as_miscorrelated          BOOLEAN              null,       -- New column. NOT NULL in obo_opr PDM doc, but will be NULL in _patched_ DB
   last_updated_on                      TIMESTAMP            not null,
   passage_event_id                     BIGINT               null,       -- new column
   passage_event_type_id                SMALLINT             not null,
   passage_event_timestamp              TIMESTAMP            not null,
   control_point_id                     SMALLINT             not null,
   obu_present                          BOOLEAN              not null,
   applied_scheme_liability_category_id SMALLINT             not null,
   applied_axle_tariff_category_id      SMALLINT             not null,
   applied_euro_emission_class_id       SMALLINT             not null,
   applied_lpn_country                  VARCHAR(2)           null,
   applied_lpn_number                   VARCHAR(14)          null,
   applied_payment_means_pan            VARCHAR(19)          null,
   applied_obuid                        VARCHAR(15)          null,
   base_rate_total                      INTEGER              not null,
   rate_modification_category_id        SMALLINT             not null,   -- new column
   etl_batch_id_insert                  BIGINT               not null,
   etl_batch_id_last_update             BIGINT               null,
   CONSTRAINT PK_OBO__PE_DERIVED_DD PRIMARY KEY (pedd_id)
);
CREATE INDEX ix_obo__passage_event_derived_data_details_01 ON obo__passage_event_derived_data_details (last_updated_on);


-- Drop table and then recreate the table with three new columns. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__passage_event_rse_logic_data;
CREATE TABLE public.obo__passage_event_rse_logic_data (
   perseld_id                          BIGINT               not null,
   passage_event_id                    BIGINT               not null,
   rse_passage_type_id                 SMALLINT             null,
   rse_compliance_check_dsrc_check_id  SMALLINT             null,   -- new column
   rse_compliance_check_axles_check_id SMALLINT             null,
   etl_batch_id_insert                 BIGINT               not null,
   etl_batch_id_last_update            BIGINT               null,
   CONSTRAINT PK_OBO__PASSAGE_EVENT_RSE_LOGI PRIMARY KEY (perseld_id)
);
CREATE INDEX ix_obo__passage_event_rse_logic_data_01 ON obo__passage_event_rse_logic_data (rse_compliance_check_axles_check_id);
CREATE INDEX ix_obo__passage_event_rse_logic_data_02 ON obo__passage_event_rse_logic_data (passage_event_id);


-- It does not matter if these constraints were already dropped. "Re-dropping"
-- a constraint that has already been dropped does not trigger an error.
ALTER TABLE public.obo__passage_event_dsrc_data    ALTER COLUMN cdc_timestamp DROP NOT NULL;
ALTER TABLE public.obo__passage_event_vehicle_data ALTER COLUMN cdc_timestamp DROP NOT NULL;
ALTER TABLE public.obo__passage_event              ALTER COLUMN cdc_timestamp DROP NOT NULL;
