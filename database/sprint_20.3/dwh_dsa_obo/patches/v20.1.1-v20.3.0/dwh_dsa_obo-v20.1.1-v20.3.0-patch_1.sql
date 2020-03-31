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

DROP TABLE IF EXISTS public.obo__svc_lvl_impact_domain CASCADE;                 -- Table renamed to obo__svc_lvl_domain (created below)
DROP TABLE IF EXISTS public.obo__svc_lvl_event_impact_register CASCADE;         -- Table renamed to obo__svc_lvl_impact_register (created below)

-- New tables and columns added to DSA tables:

-- The following columns were added to table obo__svc_lvl_event_register:
-- 
--     origin_domain_id
--     origin_control_point_id
--     origin_road_section_id
DROP TABLE IF EXISTS public.obo__svc_lvl_event_register CASCADE;
CREATE TABLE IF NOT EXISTS public.obo__svc_lvl_event_register (
   svc_lvl_event_id               BIGINT               not null,
   svc_lvl_event_type_id          SMALLINT             not null,
   svc_lvl_event_status_id        SMALLINT             not null,
   svc_lvl_event_status_timestamp TIMESTAMP            not null,
   svc_lvl_event_category_id      SMALLINT             not null,
   event_start_timestamp          TIMESTAMP            not null,
   event_end_timestamp            TIMESTAMP            null,
   external_reference_link        VARCHAR(60)          null,
   origin_domain_id               SMALLINT             null,                    -- new column
   origin_control_point_id        SMALLINT             null,                    -- new column
   origin_road_section_id         BIGINT               null,                    -- new column
   registered_by_sid              BIGINT               not null,
   registered_by_euid             VARCHAR(20)          null,
   registered_on                  TIMESTAMP            not null,
   last_updated_by_sid            BIGINT               not null,
   last_updated_by_euid           VARCHAR(20)          null,
   last_updated_on                TIMESTAMP            not null,
   etl_batch_id_insert            BIGINT               not null,
   etl_batch_id_last_update       BIGINT               null,
   constraint PK_OBO__SVC_LVL_EVENT_REGISTER PRIMARY KEY (svc_lvl_event_id)
);
CREATE INDEX ix_obo__svc_lvl_event_register_01 ON obo__svc_lvl_event_register (last_updated_on);
CREATE INDEX ix_obo__svc_lvl_event_register_02 ON obo__svc_lvl_event_register (event_start_timestamp);
CREATE INDEX ix_obo__svc_lvl_event_register_03 ON obo__svc_lvl_event_register (event_end_timestamp);


CREATE TABLE IF NOT EXISTS public.obo__kpi_impact_type(
    kpi_impact_type_id smallint NOT NULL,
    enum_name character varying(30) NOT NULL,
    description character varying(50) NOT NULL,
    etl_batch_id_insert bigint NOT NULL,
    etl_batch_id_last_update bigint,
    CONSTRAINT pk_obo__kpi_impact_type PRIMARY KEY (kpi_impact_type_id),
    CONSTRAINT ak_name_kpi_reg UNIQUE (enum_name)
);

CREATE TABLE IF NOT EXISTS public.obo__svc_lvl_domain(
    svc_lvl_domain_id smallint NOT NULL,
    enum_name character varying(30) NOT NULL,
    description character varying(50) NOT NULL,
    etl_batch_id_insert bigint NOT NULL,
    etl_batch_id_last_update bigint,
    CONSTRAINT pk_obo__svc_lvl_domain PRIMARY KEY (svc_lvl_domain_id),
    CONSTRAINT ak_enum_name_sle_dom UNIQUE (enum_name)
);

CREATE TABLE IF NOT EXISTS public.obo__svc_lvl_event_impact_map(
    svc_lvl_event_id bigint NOT NULL,
    svc_lvl_impact_id bigint NOT NULL,
    linked_on timestamp NOT NULL,
    etl_batch_id_insert bigint NOT NULL,
    etl_batch_id_last_update bigint,
    CONSTRAINT pk_obo__svc_lvl_event_impact_m PRIMARY KEY (svc_lvl_event_id,svc_lvl_impact_id)
);

CREATE TABLE IF NOT EXISTS public.obo__svc_lvl_impact_details(
    slid_id bigint NOT NULL,
    svc_lvl_impact_id bigint NOT NULL,
    kpi_impact_type_id smallint NOT NULL,
    etl_batch_id_insert bigint NOT NULL,
    etl_batch_id_last_update bigint,
    CONSTRAINT pk_obo__svc_lvl_impact_details PRIMARY KEY (slid_id)
);

CREATE TABLE IF NOT EXISTS public.obo__svc_lvl_impact_register(
    svc_lvl_impact_id bigint NOT NULL,
    svc_lvl_impact_type_id smallint NOT NULL,
    svc_lvl_impact_status_id smallint NOT NULL,
    svc_lvl_impact_status_timestamp timestamp NOT NULL,
    svc_lvl_impact_domain_id smallint NOT NULL,
    event_start_timestamp timestamp NOT NULL,
    event_end_timestamp timestamp,
    impacted_control_point_id smallint,
    impacted_road_section_id bigint,
    impacted_service_name character varying(50),
    registered_by_sid bigint NOT NULL,
    registered_by_euid character varying(20),
    registered_on timestamp NOT NULL,
    last_updated_by_sid bigint NOT NULL,
    last_updated_by_euid character varying(20),
    last_updated_on timestamp NOT NULL,
    etl_batch_id_insert bigint NOT NULL,
    etl_batch_id_last_update bigint,
    CONSTRAINT pk_obo__svc_lvl_impact_registe PRIMARY KEY (svc_lvl_impact_id)
);

CREATE TABLE IF NOT EXISTS public.obo__svc_lvl_impact_status(
    svc_lvl_impact_status_id smallint NOT NULL,
    enum_name character varying(30) NOT NULL,
    description character varying(50) NOT NULL,
    etl_batch_id_insert bigint NOT NULL,
    etl_batch_id_last_update bigint,
    CONSTRAINT pk_obo__svc_lvl_impact_status PRIMARY KEY (svc_lvl_impact_status_id),
    CONSTRAINT ak_enum_name_sli_st UNIQUE (enum_name)
);
