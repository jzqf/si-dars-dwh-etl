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


-- Add table dwh_etl_state_register_source:
-- -----------------------------------------------------------------------------
CREATE TABLE dwh_etl_state_register_source (
   desrs_id                                   BIGSERIAL            not null,
   schema_name                               VARCHAR(80)          not null,
   table_name                                VARCHAR(80)          not null,
   dwh_last_updated_insert_id_colname        VARCHAR(80)          null,
   dwh_last_updated_insert_id_maxvalue       BIGINT               null,
   dwh_last_updated_last_updated_on_colname  VARCHAR(80)          null,
   dwh_last_updated_last_updated_on_maxvalue TIMESTAMP            null,
   etl_job_id                                INTEGER              not null,
   CONSTRAINT PK_DWH_ETL_STATE_REGISTER_SRC PRIMARY KEY (desrs_id),
   CONSTRAINT AK_KEY_2_DWH_ETL_STATE_SRC UNIQUE (schema_name, table_name)
);
-- Special Per Table Permissions (Be Sure to Try and be SQL Standards compliant here!)
-- NOTE Sequence usage is needed, but granted in the DB level default permissions.
GRANT SELECT, INSERT, UPDATE, DELETE ON dwh_etl_state_register_source TO qfree_bi_rw_role;
-- -----------------------------------------------------------------------------


-- Add table dwh_etl_state_register_target:
-- -----------------------------------------------------------------------------
CREATE TABLE dwh_etl_state_register_target (
   desrt_id                                   BIGSERIAL            not null,
   schema_name                               VARCHAR(80)          not null,
   table_name                                VARCHAR(80)          not null,
   dwh_last_updated_insert_id_colname        VARCHAR(80)          null,
   dwh_last_updated_insert_id_maxvalue       BIGINT               null,
   dwh_last_updated_last_updated_on_colname  VARCHAR(80)          null,
   dwh_last_updated_last_updated_on_maxvalue TIMESTAMP            null,
   etl_job_id                                INTEGER              not null,
   CONSTRAINT PK_DWH_ETL_STATE_REGISTER_TGT PRIMARY KEY (desrt_id),
   CONSTRAINT AK_KEY_2_DWH_ETL_STATE_TGT UNIQUE (schema_name, table_name)
);
-- Special Per Table Permissions (Be Sure to Try and be SQL Standards compliant here!)
-- NOTE Sequence usage is needed, but granted in the DB level default permissions.
GRANT SELECT, INSERT, UPDATE, DELETE ON dwh_etl_state_register_target TO qfree_bi_rw_role;
-- -----------------------------------------------------------------------------


-- mon_opr:


-- obo_opr:

