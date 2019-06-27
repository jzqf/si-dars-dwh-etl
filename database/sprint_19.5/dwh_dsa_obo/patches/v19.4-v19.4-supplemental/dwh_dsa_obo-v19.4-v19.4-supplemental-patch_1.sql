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


-- Drop table and then recreate the table with one new column. 
-- This table will be refilled the next time the ETL job runs:
DROP TABLE   public.obo__analysis_queue;
CREATE TABLE public.obo__analysis_queue (
   analysis_queue_id                BIGINT               not null,
   analysis_queue_status_id         SMALLINT             null,
   analysis_queue_type_id           SMALLINT             null,
   analysis_request_id              BIGINT               null,
   pedd_id                          BIGINT               null,
   cdc_timestamp                    TIMESTAMP            null,    -- New column
   etl_batch_id_insert              BIGINT               not null,
   etl_batch_id_last_update         BIGINT               null,
   CONSTRAINT PK_OBO__ANALYSIS_QUEUE primary key (analysis_queue_id)
);
CREATE INDEX ix_obo__analysis_queue_01 ON obo__analysis_queue (cdc_timestamp);
