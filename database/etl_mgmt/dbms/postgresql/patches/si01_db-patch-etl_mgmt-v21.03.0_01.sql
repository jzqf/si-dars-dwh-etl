-- si01_db-patch-etl_mgmt-v21.03.0_01.sql:

-- -----------------------------------------------------------------------------
-- Correct a problem introduced in the 21.02 release that incorrectly used the
-- incorrect names for the primary columns of the "sid_roles" tables. See:
--
--     https://q-free.atlassian.net/browse/TSDSD-1033
--
SELECT
    tm.source_db_id,
    tm.source_table_name,
    cm.source_column_name,
    tm.target_db_id,
    tm.target_table_name,
    cm.target_column_name
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    cm.source_column_name = 'sid_roles_id' OR cm.target_column_name = 'sid_roles_id';
--
-- This corrects the ETL metadata that is stored in the etl_mgmt database. It
-- updates column names to 'sid_role_id' that are currently named 'sid_roles_id':
UPDATE
    etl.column_meta
SET
    source_column_name = 'sid_role_id',
    target_column_name = 'sid_role_id'
WHERE
    source_column_name = 'sid_roles_id' OR 
    target_column_name = 'sid_roles_id';
--
SELECT
    tm.source_db_id,
    tm.source_table_name,
    cm.source_column_name,
    tm.target_db_id,
    tm.target_table_name,
    cm.target_column_name
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    cm.source_column_name = 'sid_role_id' OR cm.target_column_name = 'sid_role_id';
-- -----------------------------------------------------------------------------



-- PSA:
--
-- -----------------------------------------------------------------------------
-- ETL job for: mon_opr.alarms -> dwh_psa_obo.mon__alarms
--
-- Change ETL algorithm from #6 ("insert-only" table) to #10 ("updateable" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-6"
FROM
    etl.table_meta
WHERE
    source_db_id = 6  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'alarms';
--
-- Update ETL algorithm to #10: "updateable" + delete:
UPDATE 
    etl.table_meta 
SET
--    update_target_table_algorithm_id = 9   -- Insert-only + delete (deletes via etl_cdc_xxxxx table)
    update_target_table_algorithm_id = 10    -- Updateable  + delete (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 11  -- Updateable  + delete (updates & deletes via etl_cdc_xxxxx table)
WHERE 
    source_db_id = 6  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'alarms';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-10"
FROM
    etl.table_meta
WHERE
    source_db_id = 6  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'alarms';
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- ETL job for: mon_opr.alarm_actions -> dwh_psa_obo.mon__alarm_actions
--
-- Change ETL algorithm from #1 ("insert-only" table) to #9 ("insert-only" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-1"
FROM
    etl.table_meta
WHERE
    source_db_id = 6  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'alarm_actions';
--
-- Update ETL algorithm to #9: Insert-only + delete:
UPDATE 
    etl.table_meta 
SET
    update_target_table_algorithm_id = 9     -- Insert-only + delete   (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 10    -- Updateable  + delete (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 11    -- Updateable  + delete (updates & deletes via etl_cdc_xxxxx table)
WHERE 
    source_db_id = 6  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'alarm_actions';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-9"
FROM
    etl.table_meta
WHERE
    source_db_id = 6  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'alarm_actions';
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- ETL job for: mon_opr.data_collection_source -> dwh_psa_obo.mon__data_collection_source
--
-- Change ETL algorithm from #6 ("insert-only" table) to #10 ("updateable" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-6"
FROM
    etl.table_meta
WHERE
    source_db_id = 6  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'data_collection_source';
--
-- Update ETL algorithm to #10: "updateable" + delete:
UPDATE 
    etl.table_meta 
SET
--    update_target_table_algorithm_id = 9   -- Insert-only + delete (deletes via etl_cdc_xxxxx table)
    update_target_table_algorithm_id = 10    -- Updateable  + delete (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 11  -- Updateable  + delete (updates & deletes via etl_cdc_xxxxx table)
WHERE 
    source_db_id = 6  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'data_collection_source';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-10"
FROM
    etl.table_meta
WHERE
    source_db_id = 6  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'data_collection_source';
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- ETL job for: obo_opr.applied_rating_detail_data -> dwh_psa_obo.obo__applied_rating_detail_data
--
-- Change ETL algorithm from #9 ("insert-only" + delete) to #11 ("updateable" + delete (updates & deletes via etl_cdc_xxxxx table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-9"
FROM
    etl.table_meta
WHERE
    source_db_id = 2  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'applied_rating_detail_data';
--
-- Update ETL algorithm to #11 ("updateable" + delete (updates & deletes via etl_cdc_xxxxx table):
UPDATE 
    etl.table_meta 
SET
--    update_target_table_algorithm_id = 9   -- Insert-only + delete (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 10  -- Updateable  + delete (deletes via etl_cdc_xxxxx table)
    update_target_table_algorithm_id = 11    -- Updateable  + delete (updates & deletes via etl_cdc_xxxxx table)
WHERE 
    source_db_id = 2  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'applied_rating_detail_data';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-11"
FROM
    etl.table_meta
WHERE
    source_db_id = 2  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'applied_rating_detail_data';
-- -----------------------------------------------------------------------------



-- DSA:
--
-- -----------------------------------------------------------------------------
-- ETL job for:  dwh_psa_obo.mon__alarms -> dwh_dsa_obo.mon__alarm
--
-- Change ETL algorithm from #6 ("insert-only" table) to #10 ("updateable" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-6"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'mon__alarms';
--
-- Update ETL algorithm to #10: "updateable" + delete:
UPDATE 
    etl.table_meta 
SET
--    update_target_table_algorithm_id = 9   -- Insert-only + delete (deletes via etl_cdc_xxxxx table)
    update_target_table_algorithm_id = 10    -- Updateable  + delete (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 11  -- Updateable  + delete (updates & deletes via etl_cdc_xxxxx table)
WHERE 
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'mon__alarms';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-10"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'mon__alarms';
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- ETL job for: dwh_psa_obo.mon__alarm_actions -> dwh_dsa_obo.mon__alarm_actions
--
-- Change ETL algorithm from #1 ("insert-only" table) to #9 ("insert-only" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-1"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'mon__alarm_actions';
--
-- Update ETL algorithm to #9: Insert-only + delete:
UPDATE 
    etl.table_meta 
SET
    update_target_table_algorithm_id = 9     -- Insert-only + delete   (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 10    -- Updateable  + delete (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 11    -- Updateable  + delete (updates & deletes via etl_cdc_xxxxx table)
WHERE 
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'mon__alarm_actions';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-9"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'mon__alarm_actions';
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- ETL job for: dwh_psa_obo.mon__data_collection_source -> dwh_dsa_obo.mon__data_collection_source
--
-- Change ETL algorithm from #6 ("insert-only" table) to #10 ("updateable" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-6"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'mon__data_collection_source';
--
-- Update ETL algorithm to #10: "updateable" + delete:
UPDATE 
    etl.table_meta 
SET
--    update_target_table_algorithm_id = 9   -- Insert-only + delete (deletes via etl_cdc_xxxxx table)
    update_target_table_algorithm_id = 10    -- Updateable  + delete (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 11  -- Updateable  + delete (updates & deletes via etl_cdc_xxxxx table)
WHERE 
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'mon__data_collection_source';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-10"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'mon__data_collection_source';
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- ETL job for: dwh_psa_obo.obo__applied_rating_detail_data -> dwh_dsa_obo.obo__applied_rating_detail_data
--
-- Change ETL algorithm from #9 ("insert-only" + delete) to #11 ("updateable" + delete (updates & deletes via etl_cdc_xxxxx table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-9"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'obo__applied_rating_detail_data';
--
-- Update ETL algorithm to #11 ("updateable" + delete (updates & deletes via etl_cdc_xxxxx table):
UPDATE 
    etl.table_meta 
SET
--    update_target_table_algorithm_id = 9   -- Insert-only + delete (deletes via etl_cdc_xxxxx table)
--    update_target_table_algorithm_id = 10  -- Updateable  + delete (deletes via etl_cdc_xxxxx table)
    update_target_table_algorithm_id = 11    -- Updateable  + delete (updates & deletes via etl_cdc_xxxxx table)
WHERE 
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'obo__applied_rating_detail_data';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-11"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND    -- 10: PSA
    target_db_id = 20 AND    -- 20: DSA
    source_table_name = 'obo__applied_rating_detail_data';
-- -----------------------------------------------------------------------------



-- Increment the value for DB_VERSION:
--
-- The value used for feature branch:
--
--     TSDSD-2/TSDSD-434/TSDSD-439_TG-05_Add-New-ETL-Algorithm
-- 
-- was "20"; hence, "21" is used here.
--
-- Before:
SELECT
    param_name,
    created_on    AS "created_on-BEFORE", 
    integer_value AS "integer_value-BEFORE", 
    string_value  AS "string_value-BEFORE"
FROM 
    etl.configuration
WHERE
    configuration_id='3aaa6ca9-1f23-4a40-8b95-007dcadc4637';
--
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
    21, 
    NULL, 
    'DB_VERSION', 
    'INTEGER', 
    '21', 
    NULL, 
    NULL, 
    NULL) 
ON CONFLICT (configuration_id) DO UPDATE SET (created_on, integer_value, string_value) = (current_timestamp, 21, '21');
--
-- After:
SELECT
    param_name,
    created_on    AS "created_on-AFTER", 
    integer_value AS "integer_value-AFTER", 
    string_value  AS "string_value-AFTER"
FROM 
    etl.configuration
WHERE
    configuration_id='3aaa6ca9-1f23-4a40-8b95-007dcadc4637';



-- -----------------------------------------------------------------------------
-- This patch code must come *after* I have updated the ETL algorithm ids for
-- tables.
--
-- Set all columns of tables to be "updateable for the non-primary key columns 
-- of tables where the ETL algorithm treats the source & target tables as
-- "updateable".

UPDATE
    etl.column_meta
SET
    is_updatable_column = true
WHERE
    column_meta_id IN (
        SELECT
            cm.column_meta_id
        FROM
            etl.column_meta cm
        INNER JOIN
             etl.table_meta tm ON tm.table_meta_id = cm.table_meta_id
        WHERE
            tm.update_target_table_algorithm_id IN (2, 5, 6, 7, 10, 11) AND
            cm.is_primary_key_column = false AND
            cm.is_updatable_column   = false
    );
-- -----------------------------------------------------------------------------
