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
DROP TABLE   public.obo__topology_road_section_control_points;
CREATE TABLE public.obo__topology_road_section_control_points (
   toporscp_id              BIGINT               not null,
   road_scheme_id           BIGINT               not null,
   road_section_id          BIGINT               not null,
   control_point_id         SMALLINT             not null,
   distance_on_road_section SMALLINT             not null,    -- New column
   distance_on_road_segment SMALLINT             not null,    -- New column
   etl_batch_id_insert      BIGINT               not null,
   etl_batch_id_last_update BIGINT               null,
   CONSTRAINT PK_OBO__TOPOLOGY_ROAD_SECTION_ PRIMARY KEY (toporscp_id)
);


--odms_opr:

