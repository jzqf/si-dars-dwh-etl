
-- Add columns to etl.table:meta table to support new table:
-- dwh_etl_state_register_target. These statements must be incorporated into
-- script upgrade-schema-dars-etl_mgmt-postgresql.sql.
ALTER TABLE etl.table_meta ADD COLUMN target_db_etl_state_register_schema_name character varying(80);
ALTER TABLE etl.table_meta ADD COLUMN target_db_etl_state_register_table_name character varying(80);
