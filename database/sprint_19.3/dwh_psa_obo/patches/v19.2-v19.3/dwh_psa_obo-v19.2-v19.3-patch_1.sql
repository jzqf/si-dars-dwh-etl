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

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.mon__datamodel_version_tracking;
CREATE TABLE public.mon__datamodel_version_tracking (
   dmvt_id                  BIGINT               not null,
   datamodel_id             SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_mon__datamodel_version_tracking primary key (dmvt_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.mon__history_datamodel_version_tracking;
CREATE TABLE public.mon__history_datamodel_version_tracking (
   history_event_id         BIGINT               not null,
   history_event_type_id    SMALLINT             not null,
   history_event_timestamp  TIMESTAMP            not null,
   dmvt_id                  BIGINT               not null,
   datamodel_id             SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_mon__history_datamodel_version_t primary key (history_event_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.mon__history_managed_process_versions;
CREATE TABLE public.mon__history_managed_process_versions (
   history_event_id         BIGINT               not null,
   history_event_type_id    SMALLINT             not null,
   history_event_timestamp  TIMESTAMP            not null,
   mpv_id                   BIGINT               not null,
   managed_process_id       SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   build_number             SMALLINT             null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_mon__history_managed_process_ver primary key (history_event_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.mon__managed_process_versions;
CREATE TABLE public.mon__managed_process_versions (
   mpv_id                   BIGINT               not null,
   managed_process_id       SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_mon__managed_process_versions primary key (mpv_id)
);



-- obo_opr:

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__svc_lvl_event_impact_register;
CREATE TABLE public.obo__svc_lvl_event_impact_register (
   sleir_id                 BIGINT               not null,
   svc_lvl_event_id         BIGINT               not null,
   svc_lvl_impact_type_id   SMALLINT             not null,
   svc_lvl_impact_domain_id SMALLINT             not null,    -- new column
   control_point_id         SMALLINT             null,
   road_section_id          BIGINT               null,
   service_name             VARCHAR(50)          null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_obo__svc_lvl_event_impact_r primary key (sleir_id)
);
--ALTER TABLE ONLY public.obo__svc_lvl_event_impact_register ADD CONSTRAINT pk_obo__svc_lvl_event_impact_register PRIMARY KEY (sleir_id);

-- New table added to PSA:
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

-- Drop table and then recreate the table with two new columns. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__svc_lvl_event_register;
CREATE TABLE public.obo__svc_lvl_event_register (
   svc_lvl_event_id               BIGINT               not null,
   svc_lvl_event_type_id          SMALLINT             not null,
   svc_lvl_event_status_id        SMALLINT             not null,
   svc_lvl_event_status_timestamp TIMESTAMP            not null,
   svc_lvl_event_category_id      SMALLINT             not null,
   event_start_timestamp          TIMESTAMP            not null,
   event_end_timestamp            TIMESTAMP            null,
   external_reference_link        VARCHAR(60)          null,     -- Column added
   registered_by_sid              BIGINT               not null, -- Column name modified: registered_by_suid -> registered_by_sid
   registered_by_euid             VARCHAR(20)          null,
   registered_on                  TIMESTAMP            not null,
   last_updated_by_sid            BIGINT               not null,
   last_updated_by_euid           VARCHAR(20)          null,
   last_updated_on                TIMESTAMP            not null,
   etl_batch_id_insert            BIGINT               not null,
   etl_batch_id_last_update       BIGINT               null,
   constraint pk_obo__svc_lvl_event_register primary key (svc_lvl_event_id)
);
CREATE INDEX IF NOT EXISTS ix_obo__svc_lvl_event_reg_01 ON public.obo__svc_lvl_event_register (last_updated_on);

-- New table added to PSA:
CREATE TABLE public.obo__svc_lvl_impact_domain (
   svc_lvl_impact_domain_id  SMALLINT             not null,
   enum_name                 VARCHAR(30)          not null,
   description               VARCHAR(50)          not null,
   etl_batch_id_insert       BIGINT               not null,
   etl_batch_id_last_update  BIGINT               null,
   constraint pk_obo__svc_lvl_impact_domain primary key (svc_lvl_impact_domain_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__datamodel_version_tracking;
CREATE TABLE public.obo__datamodel_version_tracking (
   dmvt_id                  BIGINT               not null,
   datamodel_id             SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_obo__datamodel_version_tracking primary key (dmvt_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__history_datamodel_version_tracking;
CREATE TABLE public.obo__history_datamodel_version_tracking (
   history_event_id         BIGINT               not null,
   history_event_type_id    SMALLINT             not null,
   history_event_timestamp  TIMESTAMP            not null,
   dmvt_id                  BIGINT               not null,
   datamodel_id             SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_obo__history_datamodel_version_t primary key (history_event_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__history_managed_process_versions;
CREATE TABLE public.obo__history_managed_process_versions (
   history_event_id         BIGINT               not null,
   history_event_type_id    SMALLINT             not null,
   history_event_timestamp  TIMESTAMP            not null,
   mpv_id                   BIGINT               not null,
   managed_process_id       SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   build_number             SMALLINT             null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_obo__history_managed_process_ver primary key (history_event_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__managed_process_versions;
CREATE TABLE public.obo__managed_process_versions (
   mpv_id                   BIGINT               not null,
   managed_process_id       SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_obo__managed_process_versions primary key (mpv_id)
);

-- This should not be necessary if the latest version of the dwh_psa_obo 
-- database is installed where this patch code is executed. But in older 
-- versions of the dwh_psa_obo this column is NOT NULL. So this line may not be
-- necessary, but it is safe to execute even if the NOT NULL constrainthas 
-- already been dropped, and it can properly upgrade a very old data model.
ALTER TABLE public.obo__image_data_signatures ALTER COLUMN nounce DROP NOT NULL;

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__passage_event_dsrc_data;
CREATE TABLE public.obo__passage_event_dsrc_data (
   pe_dsrc_data_id               BIGINT               not null,
   passage_event_id              BIGINT               not null,
   obu_register_id               BIGINT               not null,
   data_sequence_id              SMALLINT             not null,
   passage_event_timestamp       TIMESTAMP            not null,
   control_point_id              SMALLINT             not null,
   dsrc_txn_status               SMALLINT             null,
   dsrc_txn_timestamp            TIMESTAMP            null,
   dsrc_txn_result               VARCHAR(50)          null,
   dsrc_txn_set_mmi_rq           SMALLINT             null,
   dsrc_txn_seq_no               BIGINT               null,
   dsrc_txn_model_name           VARCHAR(50)          null,
   dsrc_txn_lid                  INTEGER              null,
   dsrc_pos_max_timestamp        TIMESTAMP            null,
   dsrc_pos_max_x                INTEGER              null,
   dsrc_pos_max_y                INTEGER              null,
   dsrc_pos_max_z                INTEGER              null,
   dsrc_pos_last_timestamp       TIMESTAMP            null,
   dsrc_pos_last_x               INTEGER              null,
   dsrc_pos_last_y               INTEGER              null,
   dsrc_pos_last_z               INTEGER              null,
   dsrc_vst_timestamp            TIMESTAMP            null,
   context_mark_provider         VARCHAR(7)           null,
   context_mark_type_of_contract INTEGER              null,
   context_version               SMALLINT             null,
   equipment_class               SMALLINT             null,
   manufacturer_id               INTEGER              null,
   obe_status                    INTEGER              null,
   equipment_obu_id              BIGINT               null,
   equipment_status_local_use    SMALLINT             null,
   equipment_transaction_counter SMALLINT             null,
   payment_means_pan             VARCHAR(19)          null,
   payment_means_expiry_date     DATE                 null,
   payment_means_usage_control   SMALLINT             null,
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
   vehicle_register_id        BIGINT               null,
   passage_event_timestamp    TIMESTAMP            not null,
   control_point_id           SMALLINT             not null,
   vehicle_length             SMALLINT             not null,
   vehicle_height             SMALLINT             not null,
   vehicle_width              SMALLINT             not null,
   vehicle_speed              SMALLINT             not null,
   trailer_present            BOOLEAN              not null,
   lateral_position           SMALLINT             not null,
   rse_alpr_status_id         SMALLINT             not null,
   licence_plate_country_code VARCHAR(2)           null,
   licence_plate_number       VARCHAR(14)          null,
   axle_tariff_category       SMALLINT             not null,
   vehicle_image_count        SMALLINT             not null,
   cdc_timestamp              TIMESTAMP            not null,    -- new column
   etl_batch_id_insert        BIGINT               not null,
   etl_batch_id_last_update    BIGINT               null,
   constraint pk_obo__passage_event_vehicle_data primary key (pe_vehicle_data_id)
);
CREATE INDEX IF NOT EXISTS ix_obo__passage_event_vehicle_d_01 ON public.obo__passage_event_vehicle_data (cdc_timestamp);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__passage_events;
CREATE TABLE public.obo__passage_events (
   passage_event_id                        BIGINT               not null,
   passage_event_type_id                   SMALLINT             not null,
   passage_event_depersonalised            BOOLEAN              not null,
   external_reference_id                   BIGINT               not null,
   data_arrival_timestamp                  TIMESTAMP            not null,
   passage_event_timestamp                 TIMESTAMP            not null,
   control_point_id                        SMALLINT             not null,
   control_point_event_sequence_number     BIGINT               not null,
   control_point_event_info_flags          SMALLINT             not null,
   control_point_event_capture_category_id SMALLINT             not null,
   charged_road_section_id                 BIGINT               not null,
   obu_present                             BOOLEAN              not null,
   obu_count                               SMALLINT             not null,
   vehicle_detected                        BOOLEAN              not null,
   vehicle_image_count                     SMALLINT             not null,
   logical_lane_id                         SMALLINT             not null,
   wrong_way_driving                       BOOLEAN              not null,
   detected_scheme_liability_category_id   SMALLINT             not null,
   detected_scheme_compliance_category_id  SMALLINT             not null,
   scheme_compliance_sub_category_id       SMALLINT             not null,
   detected_axle_tariff_category_id        SMALLINT             null,
   detected_lpn_is_foreign                 BOOLEAN              null,
   detected_lpn_country_code               VARCHAR(2)           null,
   detected_lpn_number                     VARCHAR(14)          null,
   declared_axle_tariff_category_id        SMALLINT             null,
   declared_euro_emission_class_id         SMALLINT             null,
   declared_lpn_country_code               VARCHAR(2)           null,
   declared_lpn_number                     VARCHAR(14)          null,
   data_tag                                VARCHAR(50)          null,
   cdc_timestamp                           TIMESTAMP            not null,    -- new column
   etl_batch_id_insert                     BIGINT               not null,
   etl_batch_id_last_update                BIGINT               null,
   constraint pk_obo__passage_events primary key (passage_event_id)
);
CREATE INDEX IF NOT EXISTS ix_obo__passage_events_01 ON public.obo__passage_events (cdc_timestamp);



--odms_opr:


-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.odms__datamodel_version_tracking;
CREATE TABLE public.odms__datamodel_version_tracking (
   dmvt_id                  BIGINT               not null,
   datamodel_id             SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_odms__datamodel_version_tracking primary key (dmvt_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.odms__history_datamodel_version_tracking;
CREATE TABLE public.odms__history_datamodel_version_tracking (
   history_event_id         BIGINT               not null,
   history_event_type_id    SMALLINT             not null,
   history_event_timestamp  TIMESTAMP            not null,
   dmvt_id                  BIGINT               not null,
   datamodel_id             SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_odms__history_datamodel_version_t primary key (history_event_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.odms__history_managed_process_versions;
CREATE TABLE public.odms__history_managed_process_versions (
   history_event_id         BIGINT               not null,
   history_event_type_id    SMALLINT             not null,
   history_event_timestamp  TIMESTAMP            not null,
   mpv_id                   BIGINT               not null,
   managed_process_id       SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   build_number             SMALLINT             null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_odms__history_managed_process_ver primary key (history_event_id)
);

-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.odms__managed_process_versions;
CREATE TABLE public.odms__managed_process_versions (
   mpv_id                   BIGINT               not null,
   managed_process_id       SMALLINT             not null,
   variant                  VARCHAR(4)           not null,     -- Column added
   major_version            SMALLINT             not null,
   minor_version            SMALLINT             not null,
   incremental_version      SMALLINT             not null,
   qualifier                VARCHAR(50)          null,
   last_updated_by          BIGINT               not null,
   last_updated_on          TIMESTAMP            not null,
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   constraint pk_odms__managed_process_versions primary key (mpv_id)
);
