
-- Add columns that will be used for storing CDC state between ETL runs for "updateable" tables.
ALTER TABLE etl.table_state ADD COLUMN target_synced_to_insert_id                   BIGINT    NULL;
ALTER TABLE etl.table_state ADD COLUMN target_synced_to_last_updated_on             TIMESTAMP NULL;
ALTER TABLE etl.table_state ADD COLUMN target_unsynced_inserts_from_last_updated_on TIMESTAMP NULL;

