
-- Add columns that will be used for storing CDC state between ETL runs for "updateable" tables.
ALTER TABLE etl.table_state ADD COLUMN target_synced_to_insert_id                   BIGINT    NULL;
ALTER TABLE etl.table_state ADD COLUMN target_synced_to_last_updated_on             TIMESTAMP NULL;
ALTER TABLE etl.table_state ADD COLUMN target_unsynced_inserts_from_last_updated_on TIMESTAMP NULL;

-- Update the etl_mgmt database version number to 13.
INSERT INTO etl.configuration (
    configuration_id, 
    boolean_value, 
    bytea_value, 
    created_on, 
    date_value, 
    datetime_value, 
    double_value, 
    float_value, 
    integer_value, 
    long_value, 
    param_name, 
    param_type, 
    string_value, 
    text_value, 
    time_value, 
    role_id) 
VALUES (
    '3aaa6ca9-1f23-4a40-8b95-007dcadc4637', 
    NULL, 
    NULL, 
    current_timestamp, 
    NULL, 
    NULL, 
    NULL, 
    NULL, 
    13, 
    NULL, 
    'DB_VERSION', 
    'INTEGER', 
    '13', 
    NULL, 
    NULL, 
    NULL) 
ON CONFLICT (configuration_id) DO UPDATE SET (created_on, integer_value, string_value) = (current_timestamp, 13, '13');
