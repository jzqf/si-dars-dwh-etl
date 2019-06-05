-- This file contains patch code in development for the dwh_psa_obo database.
--
-- While the SQL in the file can be executed for testing during development, it
-- must be integrated elsewhere for updating the dwh_psa_obo installation script
-- or upgrade script, e.g., in the scripts:
--
--   si-dars-solution/env-init/dev2/trdci0912/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql
--   si-dars-solution/env-init/prd/si01-prd-08cl/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql
--   si-dars-solution/env-init/qfr/si01-qfr-08cl/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql
--   si-dars-solution/env-init/stg/si01-stg-08cl/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql
--   si-dars-solution/env-init/uat/si01-uat-08cl/postgres/initialise/03.dbms_databases/03.etl_mgmt/003.create-schema-etl_mgmt-postgresql.sql



-- mon_opr:



-- obo_opr:


-- Drop table and then recreate the table with two new columns. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__analysis_detailed_results;
CREATE TABLE public.obo__analysis_detailed_results (
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
   image_is_miscorrelated          BOOLEAN              null,     -- Column added
   etl_batch_id_insert             BIGINT               not null,
   etl_batch_id_last_update        BIGINT               null,
   CONSTRAINT PK_OBO__ANALYSIS_DETAILED_RESU PRIMARY KEY (analysis_detailed_result_id)
);


-- Drop table and then recreate the table with two new columns. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__passage_event_derived_data;
CREATE TABLE public.obo__passage_event_derived_data (
   pedd_id                             BIGINT               not null,
   pedd_status_id                      SMALLINT             not null,
   pedd_status_timestamp               TIMESTAMP            not null,
   derived_data_details_depersonalised BOOLEAN              not null,
   derived_data_details_deleted        BOOLEAN              not null,
   passage_event_id                    BIGINT               not null,
   passage_event_depersonalised        BOOLEAN              not null,
   passage_event_deleted               BOOLEAN              not null,
   passage_event_timestamp             TIMESTAMP            not null,     -- Column added
   external_reference_timestamp        TIMESTAMP            not null,     -- Column added
   created_on                          TIMESTAMP            not null,
   last_updated_on                     TIMESTAMP            not null,
   etl_batch_id_insert                 BIGINT               not null,
   etl_batch_id_last_update            BIGINT               null,
   CONSTRAINT PK_PASSAGE_EVENT_DERIVED_DATA PRIMARY KEY (pedd_id)
);
CREATE INDEX ix_obo__passage_event_derived_data_01 ON obo__passage_event_derived_data (
    last_updated_on
);

DROP TABLE   public.obo__passage_event_derived_data_details;
CREATE TABLE public.obo__passage_event_derived_data_details (
   pedd_id                                     BIGINT               not null,
   pedd_data_authority_id                      SMALLINT             not null,
   created_on                                  TIMESTAMP            not null,
   associated_workflow_id                      BIGINT               null,
   associated_workflow_weawf_id                BIGINT               null,
   associated_compliance_case_id               BIGINT               null,
   identified_as_duplicate                     BOOLEAN              not null,
   identified_as_miscorrelated                 BOOLEAN              null,    -- New column. NOT NULL in obo_opr PDM doc, but will be NULL in _patched_ DB
   derived_data_details_depersonalised         BOOLEAN              not null,
   last_updated_on                             TIMESTAMP            not null,
   passage_event_id                            BIGINT               null,
   passage_event_type_id                       SMALLINT             not null,
   data_arrival_timestamp                      TIMESTAMP            not null,
   external_reference_timestamp                TIMESTAMP            not null,
   passage_event_timestamp                     TIMESTAMP            not null,
   control_point_id                            SMALLINT             not null,
   charged_road_section_id                     BIGINT               not null,
   obu_present                                 BOOLEAN              not null,
   obu_mmi_signaled                            SMALLINT             null,
   vehicle_detected                            BOOLEAN              not null,
   images_captured                             BOOLEAN              not null,
   reclassified_scheme_liability               BOOLEAN              not null,
   reclassified_scheme_compliance              BOOLEAN              not null,
   applied_scheme_liability_category_id        SMALLINT             not null,
   applied_scheme_compliance_category_id       SMALLINT             not null,
   applied_scheme_compliance_sub_category_id   SMALLINT             not null,
   applied_axle_tariff_category_id             SMALLINT             not null,
   applied_euro_emission_class_id              SMALLINT             not null,
   applied_lpn_is_foreign                      BOOLEAN              null,
   applied_lpn_country                         VARCHAR(2)           null,
   applied_lpn_number                          VARCHAR(14)          null,
   applied_payment_means_pan                   VARCHAR(19)          null,
   applied_obuid                               VARCHAR(15)          null,
   applied_tollable_distance                   SMALLINT             not null,
   applied_base_rate_total                     INTEGER              not null,
   rate_is_modified                            BOOLEAN              not null,
   base_rate_total                             INTEGER              not null,
   rate_modification_category_id               SMALLINT             not null,
   rate_modification_reason_id                 SMALLINT             not null,
   event_data_signature_verification_status_id SMALLINT             not null,
   image_data_signature_verification_status_id SMALLINT             not null,
   data_tag                                    VARCHAR(50)          null,
   etl_batch_id_insert                         BIGINT               not null,
   etl_batch_id_last_update                    BIGINT               null,
   CONSTRAINT PK_OBO__PASSAGE_EVENT_DDD PRIMARY KEY (pedd_id)
);
CREATE INDEX ix_obo__passage_event_derived_data_details_01 ON obo__passage_event_derived_data_details (last_updated_on);


-- It does not matter if these constraints were already dropped. "Re-dropping"
-- a constraint that has already been dropped does not trigger an error.
ALTER TABLE public.obo__passage_event_dsrc_data    ALTER COLUMN cdc_timestamp DROP NOT NULL;
ALTER TABLE public.obo__passage_event_vehicle_data ALTER COLUMN cdc_timestamp DROP NOT NULL;
ALTER TABLE public.obo__passage_events             ALTER COLUMN cdc_timestamp DROP NOT NULL;


--odms_opr:

