-- etl_mgmt upgrade patch for feature branch:
--
--     TSDSD-2/TSDSD-434/TSDSD-439_TG-05_Add-New-ETL-Algorithm
--
--
-- =============================================================================
-- dwh_psa_obo: ================================================================
-- =============================================================================

-- Source DB = obo_opr:

-- -----------------------------------------------------------------------------
--create table etl_cdc_applied_rating_detail_data (								<- Table added. PSA table obo__applied_rating_detail_data will support row deletion.
--   cdc_id               BIGSERIAL not null,
--   cdc_type             CHAR(1)              not null,
--   cdc_key_id           BIGINT               not null,
--   cdc_timestamp        TIMESTAMP            not null,
--   constraint PK_ETL_CDC_APPLIED_RATING_DETA primary key (cdc_id)
--);
-- -----------------------------------------------------------------------------

-- Change ETL algorithm from #1 ("insert-only" table) to #9 ("insert-only" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-1"
FROM
    etl.table_meta
WHERE
    source_db_id = 2  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'applied_rating_detail_data';
--
-- Update ETL algorithm to #9: Insert-only + delete:
UPDATE 
    etl.table_meta 
SET
    update_target_table_algorithm_id = 9     -- Insert-only + delete
--    update_target_table_algorithm_id = 10    -- Updateable  + delete
WHERE 
    source_db_id = 2  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'applied_rating_detail_data';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-9"
FROM
    etl.table_meta
WHERE
    source_db_id = 2  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'applied_rating_detail_data';


-- -----------------------------------------------------------------------------
--create table etl_cdc_compliance_case_passage_event_map (						<- Table added. PSA table obo__compliance_case_passage_event_map will support row deletion.
--   cdc_id               BIGSERIAL not null,
--   cdc_type             CHAR(1)              not null,
--   cdc_key_id           BIGINT               not null,
--   cdc_timestamp        TIMESTAMP            not null,
--   constraint PK_ETL_CDC_COMPLIANCE_CASE_PAS primary key (cdc_id)
--);
-- -----------------------------------------------------------------------------

-- Change ETL algorithm from #4 ("truncate-reload") to #9 ("insert-only" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-4"
FROM
    etl.table_meta
WHERE
    source_db_id = 2  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'compliance_case_passage_event_map';
--
-- Update ETL algorithm to #9: Insert-only + delete:
UPDATE 
    etl.table_meta 
SET
    update_target_table_algorithm_id = 9     -- Insert-only + delete
--    update_target_table_algorithm_id = 10    -- Updateable  + delete
WHERE 
    source_db_id = 2  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'compliance_case_passage_event_map';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-9"
FROM
    etl.table_meta
WHERE
    source_db_id = 2  AND    -- 2: obo_opr, 4: odms_opr, 6: mon_opr
    target_db_id = 10 AND    -- 10: PSA
    source_table_name = 'compliance_case_passage_event_map';



-- =============================================================================
-- dwh_dsa_obo: ================================================================
-- =============================================================================

-- -----------------------------------------------------------------------------
--create table etl_cdc_obo__applied_rating_detail_data (							<- Table added. DSA table obo__applied_rating_detail_data will support row deletion.
--   cdc_id               BIGSERIAL not null,
--   cdc_type             CHAR(1)              not null,
--   cdc_key_id           BIGINT               not null,
--   cdc_timestamp        TIMESTAMP            not null,
--   constraint PK_ETL_CDC_OBO__APPLIED_RATING primary key (cdc_id)
--);
-- -----------------------------------------------------------------------------

-- Change ETL algorithm from #1 ("insert-only" table) to #9 ("insert-only" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-1"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND     -- 10: PSA
    target_db_id = 20 AND     -- 20: DSA
    source_table_name = 'obo__applied_rating_detail_data';
--
-- Update ETL algorithm to #9: Insert-only + delete:
UPDATE 
    etl.table_meta 
SET
    update_target_table_algorithm_id = 9     -- Insert-only + delete
--    update_target_table_algorithm_id = 10    -- Updateable  + delete
WHERE 
    source_db_id = 10 AND     -- 10: PSA
    target_db_id = 20 AND     -- 20: DSA
    source_table_name = 'obo__applied_rating_detail_data';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-9"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND     -- 10: PSA
    target_db_id = 20 AND     -- 20: DSA
    source_table_name = 'obo__applied_rating_detail_data';


-- -----------------------------------------------------------------------------
--create table etl_cdc_obo__compliance_case_passage_event_map (					<- Table added. DSA table obo__compliance_case_passage_event_map will support row deletion.
--   cdc_id               BIGSERIAL not null,
--   cdc_type             CHAR(1)              not null,
--   cdc_key_id           BIGINT               not null,
--   cdc_timestamp        TIMESTAMP            not null,
--   constraint PK_ETL_CDC_OBO__COMPLIANCE_CAS primary key (cdc_id)
--);
-- -----------------------------------------------------------------------------

-- Change ETL algorithm from #4 ("truncate-reload") to #9 ("insert-only" + delete):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-4"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND     -- 10: PSA
    target_db_id = 20 AND     -- 20: DSA
    source_table_name = 'obo__compliance_case_passage_event_map';
--
-- Update ETL algorithm to #9: Insert-only + delete:
UPDATE 
    etl.table_meta 
SET
    update_target_table_algorithm_id = 9     -- Insert-only + delete
--    update_target_table_algorithm_id = 10    -- Updateable  + delete
WHERE 
    source_db_id = 10 AND     -- 10: PSA
    target_db_id = 20 AND     -- 20: DSA
    source_table_name = 'obo__compliance_case_passage_event_map';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-9"
FROM
    etl.table_meta
WHERE
    source_db_id = 10 AND     -- 10: PSA
    target_db_id = 20 AND     -- 20: DSA
    source_table_name = 'obo__compliance_case_passage_event_map';



-- Increment the value for DB_VERSION:
--
-- The value used for feature branch:
--
--     TSDSD-2/TSDSD-434/TSDSD-438_TG-04_Add-DBApp-Changes-for-ETL-InsertUpdate-Detection-Capability
-- 
-- was "19"; hence, "20" is used here, since the feature branch for TG-05 is
-- dependedent on the feature branch for TG-04. This means that the the feature 
-- branch for TG-04 may be merged in and released without the feature branch for 
-- TG-05 being released, but not the other way around.
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
    20, 
    NULL, 
    'DB_VERSION', 
    'INTEGER', 
    '20', 
    NULL, 
    NULL, 
    NULL) 
ON CONFLICT (configuration_id) DO UPDATE SET (created_on, integer_value, string_value) = (current_timestamp, 20, '20');
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
