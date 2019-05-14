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
CREATE TABLE public.obo__svc_lvl_event_category (
   svc_lvl_event_category_id SMALLINT             not null,
   enum_name                 VARCHAR(30)          not null,
   description               VARCHAR(50)          not null,
   etl_batch_id_insert       BIGINT               not null,
   etl_batch_id_last_update  BIGINT               null,
   constraint PK_OBO__SVC_LVL_EVENT_CATEGORY primary key (svc_lvl_event_category_id)
);

-- New table added to DSA:
CREATE TABLE public.obo__svc_lvl_event_impact_register (
   sleir_id                 BIGINT               not null,
   svc_lvl_event_id         BIGINT               not null,
   svc_lvl_impact_type_id   SMALLINT             not null,
   svc_lvl_impact_domain_id SMALLINT             not null,
   control_point_id         SMALLINT             null,
   road_section_id          BIGINT               null,
   service_name             VARCHAR(50)          null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint PK_OBO__SVC_LVL_EVENT_IMPACT_R primary key (sleir_id)
);

-- New table added to DSA:
CREATE TABLE public.obo__svc_lvl_event_log (
   slelog_id                BIGINT               not null,
   svc_lvl_event_id         BIGINT               not null,
   registered_by_sid        BIGINT               not null,
   registered_by_euid       VARCHAR(20)          null,
   registered_on            TIMESTAMP            not null,
   log_comment              VARCHAR(1024)        not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_obo__svc_lvl_event_log primary key (slelog_id)
);

-- New table added to DSA:
CREATE TABLE public.obo__svc_lvl_event_register (
   svc_lvl_event_id               BIGINT               not null,
   svc_lvl_event_type_id          SMALLINT             not null,
   svc_lvl_event_status_id        SMALLINT             not null,
   svc_lvl_event_status_timestamp TIMESTAMP            not null,
   svc_lvl_event_category_id      SMALLINT             not null,
   event_start_timestamp          TIMESTAMP            not null,
   event_end_timestamp            TIMESTAMP            null,
   external_reference_link        VARCHAR(60)          null,
   registered_by_sid              BIGINT               not null,
   registered_by_euid             VARCHAR(20)          null,
   registered_on                  TIMESTAMP            not null,
   last_updated_by_sid            BIGINT               not null,
   last_updated_by_euid           VARCHAR(20)          null,
   last_updated_on                TIMESTAMP            not null,
   etl_batch_id_insert            BIGINT               not null,
   etl_batch_id_last_update       BIGINT               null,
   constraint PK_OBO__SVC_LVL_EVENT_REGISTER primary key (svc_lvl_event_id)
);
CREATE INDEX IF NOT EXISTS ix_obo__svc_lvl_event_reg_01 ON public.obo__svc_lvl_event_register (last_updated_on);

-- New table added to DSA:
CREATE TABLE public.obo__svc_lvl_event_status (
   svc_lvl_event_status_id  SMALLINT             not null,
   enum_name                VARCHAR(30)          not null,
   description              VARCHAR(50)          not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint PK_OBO__SVC_LVL_EVENT_STATUS primary key (svc_lvl_event_status_id)
);

-- New table added to DSA:
CREATE TABLE public.obo__svc_lvl_event_type (
   svc_lvl_event_type_id    SMALLINT             not null,
   enum_name                VARCHAR(30)          not null,
   description              VARCHAR(50)          not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint PK_OBO__SVC_LVL_EVENT_TYPE primary key (svc_lvl_event_type_id)
);

-- New table added to DSA:
CREATE TABLE public.obo__svc_lvl_impact_domain (
   svc_lvl_impact_domain_id  SMALLINT             not null,
   enum_name                 VARCHAR(30)          not null,
   description               VARCHAR(50)          not null,
   etl_batch_id_insert       BIGINT               not null,
   etl_batch_id_last_update  BIGINT               null,
   constraint pk_obo__svc_lvl_impact_domain primary key (svc_lvl_impact_domain_id)
);

-- New table added to DSA:
CREATE TABLE public.obo__svc_lvl_impact_type (
   svc_lvl_impact_type_id   SMALLINT             not null,
   enum_name                VARCHAR(30)          not null,
   description              VARCHAR(50)          not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint PK_OBO__SVC_LVL_IMPACT_TYPE primary key (svc_lvl_impact_type_id)
);


-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__passage_event_dsrc_data;
CREATE TABLE public.obo__passage_event_dsrc_data (
   pe_dsrc_data_id               BIGINT               not null,
   passage_event_id              BIGINT               not null,
   obe_status                    INTEGER              null,
   equipment_obu_id              BIGINT               null,
   payment_means_pan             VARCHAR(19)          null,
   cdc_timestamp                 TIMESTAMP            not null,    -- new column
   etl_batch_id_insert           BIGINT               not null,
   etl_batch_id_last_update      BIGINT               null,
   constraint pk_obo__passage_event_dsrc_data primary key (pe_dsrc_data_id)
);
CREATE INDEX IF NOT EXISTS ix_obo__passage_event_dsrc_data_01 ON public.obo__passage_event_dsrc_data (cdc_timestamp);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__passage_event_vehicle_data;
CREATE TABLE public.obo__passage_event_vehicle_data (
   pe_vehicle_data_id         BIGINT               not null,
   passage_event_id           BIGINT               not null,
   passage_event_timestamp    TIMESTAMP            not null,
   control_point_id           SMALLINT             not null,
   vehicle_length             SMALLINT             not null,
   vehicle_height             SMALLINT             not null,
   vehicle_width              SMALLINT             not null,
   vehicle_speed              SMALLINT             not null,
   cdc_timestamp              TIMESTAMP            not null,    -- new column
   etl_batch_id_insert        BIGINT               not null,
   etl_batch_id_last_update   BIGINT               null,
   constraint pk_obo__passage_event_vehicle_data primary key (pe_vehicle_data_id)
);
CREATE INDEX IF NOT EXISTS ix_obo__passage_event_vehicle_d_01 ON public.obo__passage_event_vehicle_data (cdc_timestamp);

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
   cdc_timestamp                              TIMESTAMP            not null,    -- new column
   etl_batch_id_insert                        BIGINT               not null,
   etl_batch_id_last_update                   BIGINT               null,
   constraint pk_obo__passage_event primary key (passage_event_id)
);
CREATE INDEX IF NOT EXISTS ix_obo__passage_event_01 on public.obo__passage_event (passage_event_timestamp);
CREATE INDEX IF NOT EXISTS ix_obo__passage_event_02 ON public.obo__passage_event (cdc_timestamp);
