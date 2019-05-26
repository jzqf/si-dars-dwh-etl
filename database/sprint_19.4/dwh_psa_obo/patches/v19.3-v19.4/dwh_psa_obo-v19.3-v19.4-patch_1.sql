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
   constraint PK_PASSAGE_EVENT_DERIVED_DATA primary key (pedd_id)
);
CREATE INDEX ix_obo__passage_event_derived_data_01 ON obo__passage_event_derived_data (
    last_updated_on
);


-- It does not matter if these constraints were already dropped. "Re-dropping"
-- a constraint that has already been dropped does not trigger an error.
ALTER TABLE public.obo__passage_event_dsrc_data    ALTER COLUMN cdc_timestamp DROP NOT NULL;
ALTER TABLE public.obo__passage_event_vehicle_data ALTER COLUMN cdc_timestamp DROP NOT NULL;
ALTER TABLE public.obo__passage_events             ALTER COLUMN cdc_timestamp DROP NOT NULL;


--odms_opr:

