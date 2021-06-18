-- etl_mgmt upgrade patch for feature branch:
--
--     TSDSD-2/TSDSD-434/TSDSD-438_TG-04_Add-DBApp-Changes-for-ETL-InsertUpdate-Detection-Capability
--
--
-- =============================================================================
-- dwh_psa_obo: ================================================================
-- =============================================================================

--------------------------------------------------------------------------------
--create table mon__alarms (
--   alarm_id             BIGINT               not null,
--   alarm_status_id      SMALLINT             not null,
--   alarm_priority_id    SMALLINT             not null,
--   managed_object_id    BIGINT               not null,
--   activated            TIMESTAMP            not null,
--   threshold_id         BIGINT               not null,
--   last_event_description VARCHAR(1024)        not null,
--   error_code           BIGINT               not null,
--   
--   last_updated_on      TIMESTAMP            not null,							<- Column added:	Patch:	1.	Create column_meta row:
--   																													source_column_name='last_updated_on'
--   																													target_column_name='last_updated_on'
--   																													is_last_updated_on_column=true
--   																											2.	ETL algorithm: 1 -> 6 (updateable)
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   constraint PK_MON__ALARMS primary key (alarm_id)
--);
--------------------------------------------------------------------------------

-- Insert column_meta row for new "last_updated_on" timestamp column of PSA table 'mon__alarms':
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=10 AND target_table_name='mon__alarms'),    -- 10: PSA
    'last_updated_on',
    'last_updated_on',
    false,   -- is_primary_key_column
    NULL,    -- primary_key_column_order
    false,   -- is_insert_id_column
    false,
    true,    -- is_last_updated_on_column
    false,
    false,
    true,    -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column

-- Change ETL algorithm from #1 ("insert-only" table) to #6 ("updateable" table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-1"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'mon__alarms';
--
UPDATE
    etl.table_meta
SET
    update_target_table_algorithm_id = 6  -- "Updateable table"
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'mon__alarms';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-6"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'mon__alarms';


--------------------------------------------------------------------------------
--create table mon__sid_roles (
--   sid_roles_id         BIGINT               not null,							<- Column added:	Patch:	1.	Create column_meta row as single column primary key:
--   																													source_column_name='sid_roles_id'
--   																													target_column_name='sid_roles_id'
--   																													is_primary_key_column=true
--   																													primary_key_column_order=1
--   																													is_insert_id_column=true
--   																											2.	Previous primary key was (sid, security_realm_id, security_role_id). 
--   																												Update the *existing* column_meta columns for these columns by setting: 
--   																												is_primary_key_column=false, primary_key_column_order=NULL
--   																											3.	ETL algorithm: 4 -> 1 (insert-only)
--   sid                  BIGINT               not null,
--   security_realm_id    SMALLINT             not null,
--   security_role_id     SMALLINT             not null,
--   created_by           BIGINT               not null,
--   created_on           TIMESTAMP            not null,
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   constraint PK_MON__SECURITYLOGIN3 primary key (sid_roles_id)
--);
--------------------------------------------------------------------------------

-- The previous primary key was: (sid, security_realm_id, security_role_id).
-- This deletes the previous primary key details for these columns:
--
-- Before: 
SELECT
    cm.target_column_name       AS "target_column_name-BEFORE",
    cm.is_primary_key_column    AS "is_primary_key_column-BEFORE",
    cm.primary_key_column_order AS "primary_key_column_order-BEFORE",
    cm.is_updatable_column      AS "is_updatable_column-BEFORE"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='mon__sid_roles' AND
    cm.target_column_name IN ('sid', 'security_realm_id', 'security_role_id')
ORDER BY
    cm.target_column_name;
--
UPDATE
    etl.column_meta
SET
    is_primary_key_column    = false,
    primary_key_column_order = NULL,
    is_updatable_column      = true
WHERE
    table_meta_id = (SELECT tm.table_meta_id FROM etl.table_meta tm WHERE tm.target_db_id=10 AND tm.target_table_name='mon__sid_roles') AND    -- PSA
    target_column_name IN ('sid', 'security_realm_id', 'security_role_id');
--
-- After: 
SELECT
    cm.target_column_name       AS "target_column_name-AFTER",
    cm.is_primary_key_column    AS "is_primary_key_column-AFTER",
    cm.primary_key_column_order AS "primary_key_column_order-AFTER",
    cm.is_updatable_column      AS "is_updatable_column-AFTER"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND     -- PSA
    tm.target_table_name='mon__sid_roles' AND
    cm.target_column_name IN ('sid', 'security_realm_id', 'security_role_id')
ORDER BY
    cm.target_column_name;

-- Insert column_meta row for new "sid_roles_id" timestamp column of PSA table 'mon__sid_roles'
-- and make this column the primary key for the table:
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=10 AND target_table_name='mon__sid_roles'),    -- 10: PSA
    'sid_roles_id',
    'sid_roles_id',
    true,    -- is_primary_key_column
    1,       -- primary_key_column_order
    true,    -- is_insert_id_column
    false,
    false,   -- is_last_updated_on_column
    false,
    false,
    false,   -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column
--
-- Check that we set the primary key details correct for table 'mon__sid_roles':
SELECT
    cm.target_column_name       AS "target_column_name-PRIMARY_KEY",
    cm.is_primary_key_column    AS "is_primary_key_column-PRIMARY_KEY",
    cm.primary_key_column_order AS "primary_key_column_order-PRIMARY_KEY",
    cm.is_updatable_column      AS "is_updatable_column-PRIMARY_KEY"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='mon__sid_roles' AND
    cm.is_primary_key_column=true
ORDER BY
    cm.target_column_name;

-- Change ETL algorithm from #4 ("truncate-reload") to #1 ("insert-only" table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-4"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'mon__sid_roles';
--
UPDATE
    etl.table_meta
SET
    update_target_table_algorithm_id = 1  -- "Insert-only table"
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'mon__sid_roles';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-1"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'mon__sid_roles';


--------------------------------------------------------------------------------
--create table obo__compliance_case_passage_event_map (
--   ccpem_id             BIGINT               not null,							<- Column added:	Patch:	1.	Create column_meta row as single column primary key:
--   																													source_column_name='ccpem_id'
--   																													target_column_name='ccpem_id'
--   																													is_primary_key_column=true
--   																													primary_key_column_order=1
--   																													is_insert_id_column=true
--   																											2.	Previous primary key was (compliance_case_id, pedd_id). 
--   																												Update the *existing* column_meta columns for these columns by setting: 
--   																												is_primary_key_column=false, primary_key_column_order=NULL
--   																											3.	ETL algorithm: 4 -> 1 (insert-only)
--   compliance_case_id   BIGINT               not null,
--   pedd_id              BIGINT               not null,
--   linked_on            TIMESTAMP            not null,
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   constraint PK_OBO__COMPLIANCE_CASE_PASSAG primary key (ccpem_id)
--);
--------------------------------------------------------------------------------

-- The previous primary key was: (compliance_case_id, pedd_id).
-- This deletes the previous primary key details for these columns:
--
-- Before: 
SELECT
    cm.target_column_name       AS "target_column_name-BEFORE",
    cm.is_primary_key_column    AS "is_primary_key_column-BEFORE",
    cm.primary_key_column_order AS "primary_key_column_order-BEFORE",
    cm.is_updatable_column      AS "is_updatable_column-BEFORE"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='obo__compliance_case_passage_event_map' AND
    cm.target_column_name IN ('compliance_case_id', 'pedd_id')
ORDER BY
    cm.target_column_name;
--
UPDATE
    etl.column_meta
SET
    is_primary_key_column    = false,
    primary_key_column_order = NULL,
    is_updatable_column      = true
WHERE
    table_meta_id = (SELECT tm.table_meta_id FROM etl.table_meta tm WHERE tm.target_db_id=10 AND tm.target_table_name='obo__compliance_case_passage_event_map') AND    -- PSA
    target_column_name IN ('compliance_case_id', 'pedd_id');
--
-- After: 
SELECT
    cm.target_column_name       AS "target_column_name-AFTER",
    cm.is_primary_key_column    AS "is_primary_key_column-AFTER",
    cm.primary_key_column_order AS "primary_key_column_order-AFTER",
    cm.is_updatable_column      AS "is_updatable_column-AFTER"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='obo__compliance_case_passage_event_map' AND
    cm.target_column_name IN ('compliance_case_id', 'pedd_id')
ORDER BY
    cm.target_column_name;

-- Insert column_meta row for new "ccpem_id" timestamp column of PSA table 'obo__compliance_case_passage_event_map'
-- and make this column the primary key for the table:
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=10 AND target_table_name='obo__compliance_case_passage_event_map'),    -- 10: PSA
    'ccpem_id',
    'ccpem_id',
    true,    -- is_primary_key_column
    1,       -- primary_key_column_order
    true,    -- is_insert_id_column
    false,
    false,   -- is_last_updated_on_column
    false,
    false,
    false,   -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column
--
-- Check that we set the primary key details correct for table 'obo__compliance_case_passage_event_map':
SELECT
    cm.target_column_name       AS "target_column_name-PRIMARY_KEY",
    cm.is_primary_key_column    AS "is_primary_key_column-PRIMARY_KEY",
    cm.primary_key_column_order AS "primary_key_column_order-PRIMARY_KEY",
    cm.is_updatable_column      AS "is_updatable_column-PRIMARY_KEY"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='obo__compliance_case_passage_event_map' AND
    cm.is_primary_key_column=true
ORDER BY
    cm.target_column_name;

-- Change ETL algorithm from #4 ("truncate-reload") to #1 ("insert-only" table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-4"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'obo__compliance_case_passage_event_map';
--
UPDATE
    etl.table_meta
SET
    update_target_table_algorithm_id = 1  -- "Insert-only table"
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'obo__compliance_case_passage_event_map';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-1"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'obo__compliance_case_passage_event_map';


--------------------------------------------------------------------------------
--create table obo__history_compliance_case_pe_map (
--   history_event_id     BIGINT               not null,
--   history_event_type_id SMALLINT             not null,
--   history_event_timestamp TIMESTAMP            not null,
--   ccpem_id             BIGINT               null,								<- Column added:	Patch:	1.	Create column_meta row for new column:
--   																													source_column_name='ccpem_id'
--   																													target_column_name='ccpem_id'
--   compliance_case_id   BIGINT               null,
--   pedd_id              BIGINT               null,
--   linked_on            TIMESTAMP            null,
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   constraint PK_OBO__HISTORY_COMPLIANCE_CAS primary key (history_event_id)
--);
--------------------------------------------------------------------------------

-- Insert column_meta row for new "ccpem_id" bigint column of PSA table 'obo__history_compliance_case_pe_map':
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=10 AND target_table_name='obo__history_compliance_case_pe_map'),    -- 10: PSA
    'ccpem_id',
    'ccpem_id',
    false,    -- is_primary_key_column
    NULL,       -- primary_key_column_order
    false,    -- is_insert_id_column
    false,
    false,   -- is_last_updated_on_column
    false,
    false,
    true,    -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column


--------------------------------------------------------------------------------
--create table obo__sid_roles (
--   sid_roles_id         BIGINT               not null,							<- Column added:	Patch:	1.	Create column_meta row as single column primary key:
--   																													source_column_name='sid_roles_id'
--   																													target_column_name='sid_roles_id'
--   																													is_primary_key_column=true
--   																													primary_key_column_order=1
--   																													is_insert_id_column=true
--   																											2.	Previous primary key was (sid, security_realm_id, security_role_id). 
--   																												Update the *existing* column_meta columns for these columns by setting: 
--   																												is_primary_key_column=false, primary_key_column_order=NULL
--   																											3.	ETL algorithm: 4 -> 1 (insert-only)
--   sid                  BIGINT               not null,
--   security_realm_id    SMALLINT             not null,
--   security_role_id     SMALLINT             not null,
--   created_by           BIGINT               not null,
--   created_on           TIMESTAMP            not null,
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   constraint PK_OBO__SECURITYLOGIN3 primary key (sid_roles_id)
--);
--------------------------------------------------------------------------------

-- The previous primary key was: (sid, security_realm_id, security_role_id).
-- This deletes the previous primary key details for these columns:
--
-- Before: 
SELECT
    cm.target_column_name       AS "target_column_name-BEFORE",
    cm.is_primary_key_column    AS "is_primary_key_column-BEFORE",
    cm.primary_key_column_order AS "primary_key_column_order-BEFORE",
    cm.is_updatable_column      AS "is_updatable_column-BEFORE"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='obo__sid_roles' AND
    cm.target_column_name IN ('sid', 'security_realm_id', 'security_role_id')
ORDER BY
    cm.target_column_name;
--
UPDATE
    etl.column_meta
SET
    is_primary_key_column    = false,
    primary_key_column_order = NULL,
    is_updatable_column      = true
WHERE
    table_meta_id = (SELECT tm.table_meta_id FROM etl.table_meta tm WHERE tm.target_db_id=10 AND tm.target_table_name='obo__sid_roles') AND    -- PSA
    target_column_name IN ('sid', 'security_realm_id', 'security_role_id');
--
-- After: 
SELECT
    cm.target_column_name       AS "target_column_name-AFTER",
    cm.is_primary_key_column    AS "is_primary_key_column-AFTER",
    cm.primary_key_column_order AS "primary_key_column_order-AFTER",
    cm.is_updatable_column      AS "is_updatable_column-AFTER"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='obo__sid_roles' AND
    cm.target_column_name IN ('sid', 'security_realm_id', 'security_role_id')
ORDER BY
    cm.target_column_name;

-- Insert column_meta row for new "sid_roles_id" timestamp column of PSA table 'obo__sid_roles'
-- and make this column the primary key for the table:
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=10 AND target_table_name='obo__sid_roles'),    -- 10: PSA
    'sid_roles_id',
    'sid_roles_id',
    true,    -- is_primary_key_column
    1,       -- primary_key_column_order
    true,    -- is_insert_id_column
    false,
    false,   -- is_last_updated_on_column
    false,
    false,
    false,   -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column
--
-- Check that we set the primary key details correct for table 'obo__sid_roles':
SELECT
    cm.target_column_name       AS "target_column_name-PRIMARY_KEY",
    cm.is_primary_key_column    AS "is_primary_key_column-PRIMARY_KEY",
    cm.primary_key_column_order AS "primary_key_column_order-PRIMARY_KEY",
    cm.is_updatable_column      AS "is_updatable_column-PRIMARY_KEY"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='obo__sid_roles' AND
    cm.is_primary_key_column=true
ORDER BY
    cm.target_column_name;

-- Change ETL algorithm from #4 ("truncate-reload") to #1 ("insert-only" table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-4"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'obo__sid_roles';
--
UPDATE
    etl.table_meta
SET
    update_target_table_algorithm_id = 1  -- "Insert-only table"
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'obo__sid_roles';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-1"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'obo__sid_roles';


--------------------------------------------------------------------------------
--create table obo__svc_lvl_event_impact_map (
--   sleim_id             BIGINT               not null,							<- Column added:	Patch:	1.	Create column_meta row as single column primary key:
--   																													source_column_name='sleim_id'
--   																													target_column_name='sleim_id'
--   																													is_primary_key_column=true
--   																													primary_key_column_order=1
--   																													is_insert_id_column=true
--   																											2.	Previous primary key was (svc_lvl_event_id, svc_lvl_impact_id). 
--   																												Update the *existing* column_meta columns for these columns by setting: 
--   																												is_primary_key_column=false, primary_key_column_order=NULL
--   																											3.	ETL algorithm: 4 -> 1 (insert-only)
--   svc_lvl_event_id     BIGINT               not null,
--   svc_lvl_impact_id    BIGINT               not null,
--   linked_on            TIMESTAMP            not null,
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   constraint PK_OBO__SVC_LVL_EVENT_IMPACT_M primary key (sleim_id)
--);
--------------------------------------------------------------------------------

-- The previous primary key was: (svc_lvl_event_id, svc_lvl_impact_id).
-- This deletes the previous primary key details for these columns:
--
-- Before: 
SELECT
    cm.target_column_name       AS "target_column_name-BEFORE",
    cm.is_primary_key_column    AS "is_primary_key_column-BEFORE",
    cm.primary_key_column_order AS "primary_key_column_order-BEFORE",
    cm.is_updatable_column      AS "is_updatable_column-BEFORE"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='obo__svc_lvl_event_impact_map' AND
    cm.target_column_name IN ('svc_lvl_event_id', 'svc_lvl_impact_id')
ORDER BY
    cm.target_column_name;
--
UPDATE
    etl.column_meta
SET
    is_primary_key_column    = false,
    primary_key_column_order = NULL,
    is_updatable_column      = true
WHERE
    table_meta_id = (SELECT tm.table_meta_id FROM etl.table_meta tm WHERE tm.target_db_id=10 AND tm.target_table_name='obo__svc_lvl_event_impact_map') AND    -- PSA
    target_column_name IN ('svc_lvl_event_id', 'svc_lvl_impact_id');
--
-- After: 
SELECT
    cm.target_column_name       AS "target_column_name-AFTER",
    cm.is_primary_key_column    AS "is_primary_key_column-AFTER",
    cm.primary_key_column_order AS "primary_key_column_order-AFTER",
    cm.is_updatable_column      AS "is_updatable_column-AFTER"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='obo__svc_lvl_event_impact_map' AND
    cm.target_column_name IN ('svc_lvl_event_id', 'svc_lvl_impact_id')
ORDER BY
    cm.target_column_name;

-- Insert column_meta row for new "sleim_id" timestamp column of PSA table 'obo__svc_lvl_event_impact_map'
-- and make this column the primary key for the table:
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=10 AND target_table_name='obo__svc_lvl_event_impact_map'),    -- 10: PSA
    'sleim_id',
    'sleim_id',
    true,    -- is_primary_key_column
    1,       -- primary_key_column_order
    true,    -- is_insert_id_column
    false,
    false,   -- is_last_updated_on_column
    false,
    false,
    false,   -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column
--
-- Check that we set the primary key details correct for table 'obo__svc_lvl_event_impact_map':
SELECT
    cm.target_column_name       AS "target_column_name-PRIMARY_KEY",
    cm.is_primary_key_column    AS "is_primary_key_column-PRIMARY_KEY",
    cm.primary_key_column_order AS "primary_key_column_order-PRIMARY_KEY",
    cm.is_updatable_column      AS "is_updatable_column-PRIMARY_KEY"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='obo__svc_lvl_event_impact_map' AND
    cm.is_primary_key_column=true
ORDER BY
    cm.target_column_name;

-- Change ETL algorithm from #4 ("truncate-reload") to #1 ("insert-only" table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-4"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'obo__svc_lvl_event_impact_map';
--
UPDATE
    etl.table_meta
SET
    update_target_table_algorithm_id = 1  -- "Insert-only table"
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'obo__svc_lvl_event_impact_map';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-1"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'obo__svc_lvl_event_impact_map';


--------------------------------------------------------------------------------
--create table odms__sid_roles (
--   sid_roles_id         BIGINT               not null,							<- Column added:	Patch:	1.	Create column_meta row as single column primary key:
--   																													source_column_name='sid_roles_id'
--   																													target_column_name='sid_roles_id'
--   																													is_primary_key_column=true
--   																													primary_key_column_order=1
--   																													is_insert_id_column=true
--   																											2.	Previous primary key was (sid, security_realm_id, security_role_id). 
--   																												Update the *existing* column_meta columns for these columns by setting: 
--   																												is_primary_key_column=false, primary_key_column_order=NULL
--   																											3.	ETL algorithm: 4 -> 1 (insert-only)
--   sid                  BIGINT               not null,
--   security_realm_id    SMALLINT             not null,
--   security_role_id     SMALLINT             not null,
--   created_by           BIGINT               not null,
--   created_on           TIMESTAMP            not null,
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   constraint PK_ODMS__SECURITYLOGIN3 primary key (sid_roles_id)
--);
--------------------------------------------------------------------------------

-- The previous primary key was: (sid, security_realm_id, security_role_id).
-- This deletes the previous primary key details for these columns:
--
-- Before: 
SELECT
    cm.target_column_name       AS "target_column_name-BEFORE",
    cm.is_primary_key_column    AS "is_primary_key_column-BEFORE",
    cm.primary_key_column_order AS "primary_key_column_order-BEFORE",
    cm.is_updatable_column      AS "is_updatable_column-BEFORE"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='odms__sid_roles' AND
    cm.target_column_name IN ('sid', 'security_realm_id', 'security_role_id')
ORDER BY
    cm.target_column_name;
--
UPDATE
    etl.column_meta
SET
    is_primary_key_column    = false,
    primary_key_column_order = NULL,
    is_updatable_column      = true
WHERE
    table_meta_id = (SELECT tm.table_meta_id FROM etl.table_meta tm WHERE tm.target_db_id=10 AND tm.target_table_name='odms__sid_roles') AND    -- PSA
    target_column_name IN ('sid', 'security_realm_id', 'security_role_id');
--
-- After: 
SELECT
    cm.target_column_name       AS "target_column_name-AFTER",
    cm.is_primary_key_column    AS "is_primary_key_column-AFTER",
    cm.primary_key_column_order AS "primary_key_column_order-AFTER",
    cm.is_updatable_column      AS "is_updatable_column-AFTER"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='odms__sid_roles' AND
    cm.target_column_name IN ('sid', 'security_realm_id', 'security_role_id')
ORDER BY
    cm.target_column_name;

-- Insert column_meta row for new "sid_roles_id" timestamp column of PSA table 'odms__sid_roles'
-- and make this column the primary key for the table:
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=10 AND target_table_name='odms__sid_roles'),    -- 10: PSA
    'sid_roles_id',
    'sid_roles_id',
    true,    -- is_primary_key_column
    1,       -- primary_key_column_order
    true,    -- is_insert_id_column
    false,
    false,   -- is_last_updated_on_column
    false,
    false,
    false,   -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column
--
-- Check that we set the primary key details correct for table 'odms__sid_roles':
SELECT
    cm.target_column_name       AS "target_column_name-PRIMARY_KEY",
    cm.is_primary_key_column    AS "is_primary_key_column-PRIMARY_KEY",
    cm.primary_key_column_order AS "primary_key_column_order-PRIMARY_KEY",
    cm.is_updatable_column      AS "is_updatable_column-PRIMARY_KEY"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=10 AND    -- PSA
    tm.target_table_name='odms__sid_roles' AND
    cm.is_primary_key_column=true
ORDER BY
    cm.target_column_name;

-- Change ETL algorithm from #4 ("truncate-reload") to #1 ("insert-only" table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-4"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'odms__sid_roles';
--
UPDATE
    etl.table_meta
SET
    update_target_table_algorithm_id = 1  -- "Insert-only table"
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'odms__sid_roles';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-1"
FROM
    etl.table_meta
WHERE
    target_db_id      = 10 AND    -- PSA
    target_table_name = 'odms__sid_roles';



-- =============================================================================
-- dwh_dsa_obo: ================================================================
-- =============================================================================

--------------------------------------------------------------------------------
--create table mon__alarm (
--   alarm_id             BIGINT               not null,
--   managed_object_id    BIGINT               not null,
--   last_event_description VARCHAR(1024)        not null,
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   last_updated_on      TIMESTAMP            not null,							<- Column added:	Patch:	1.	Create column_meta row:
--   																													source_column_name='last_updated_on'
--   																													target_column_name='last_updated_on'
--   																													is_last_updated_on_column=true
--   																											2.	ETL algorithm: 1 -> 6 (updateable)
--   constraint PK_MON__ALARM primary key (alarm_id)
--);
--------------------------------------------------------------------------------

-- Note: In the DSA this table is "mon__alarm"; in the PSA it is "mon__alarms".
--
-- Insert column_meta row for new "last_updated_on" timestamp column of DSA table 'mon__alarm':
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=20 AND target_table_name='mon__alarm'),  -- 20: DSA
    'last_updated_on',
    'last_updated_on',
    false,   -- is_primary_key_column
    NULL,    -- primary_key_column_order
    false,   -- is_insert_id_column
    false,
    true,    -- is_last_updated_on_column
    false,
    false,
    true,    -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column

-- Change ETL algorithm from #1 ("insert-only" table) to #6 ("updateable" table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-1"
FROM
    etl.table_meta
WHERE
    target_db_id      = 20 AND    -- DSA
    target_table_name = 'mon__alarm';
--
UPDATE
    etl.table_meta
SET
    update_target_table_algorithm_id = 6  -- "Updateable table"
WHERE
    target_db_id      = 20 AND    -- DSA
    target_table_name = 'mon__alarm';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-6"
FROM
    etl.table_meta
WHERE
    target_db_id      = 20 AND    -- DSA
    target_table_name = 'mon__alarm';


--------------------------------------------------------------------------------
--create table obo__compliance_case_passage_event_map (
--   ccpem_id             BIGINT               not null,							<- Column added:	Patch:	1.	Create column_meta row as single column primary key:
--   																													source_column_name='ccpem_id'
--   																													target_column_name='ccpem_id'
--   																													is_primary_key_column=true
--   																													primary_key_column_order=1
--   																													is_insert_id_column=true
--   																											2.	Previous primary key was (compliance_case_id, pedd_id). 
--   																												Update the *existing* column_meta columns for these columns by setting: 
--   																												is_primary_key_column=false, primary_key_column_order=NULL
--   																											3.	ETL algorithm: 4 -> 1 (insert-only)
--   compliance_case_id   BIGINT               not null,
--   pedd_id              BIGINT               not null,
--   linked_on            TIMESTAMP            not null,
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   constraint PK_OBO__COMPLIANCE_CASE_PASSAG primary key (ccpem_id)
--);
--------------------------------------------------------------------------------

-- The previous primary key was: (compliance_case_id, pedd_id).
-- This deletes the previous primary key details for these columns:
--
-- Before: 
SELECT
    cm.target_column_name       AS "target_column_name-BEFORE",
    cm.is_primary_key_column    AS "is_primary_key_column-BEFORE",
    cm.primary_key_column_order AS "primary_key_column_order-BEFORE",
    cm.is_updatable_column      AS "is_updatable_column-BEFORE"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=20 AND    -- DSA
    tm.target_table_name='obo__compliance_case_passage_event_map' AND
    cm.target_column_name IN ('compliance_case_id', 'pedd_id')
ORDER BY
    cm.target_column_name;
--
UPDATE
    etl.column_meta
SET
    is_primary_key_column    = false,
    primary_key_column_order = NULL,
    is_updatable_column      = true
WHERE
    table_meta_id = (SELECT tm.table_meta_id FROM etl.table_meta tm WHERE tm.target_db_id=20 AND tm.target_table_name='obo__compliance_case_passage_event_map') AND    -- DSA
    target_column_name IN ('compliance_case_id', 'pedd_id');
--
-- After: 
SELECT
    cm.target_column_name       AS "target_column_name-AFTER",
    cm.is_primary_key_column    AS "is_primary_key_column-AFTER",
    cm.primary_key_column_order AS "primary_key_column_order-AFTER",
    cm.is_updatable_column      AS "is_updatable_column-AFTER"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=20 AND    -- DSA
    tm.target_table_name='obo__compliance_case_passage_event_map' AND
    cm.target_column_name IN ('compliance_case_id', 'pedd_id')
ORDER BY
    cm.target_column_name;

-- Insert column_meta row for new "ccpem_id" timestamp column of PSA table 'obo__compliance_case_passage_event_map'
-- and make this column the primary key for the table:
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=20 AND target_table_name='obo__compliance_case_passage_event_map'),    -- DSA
    'ccpem_id',
    'ccpem_id',
    true,    -- is_primary_key_column
    1,       -- primary_key_column_order
    true,    -- is_insert_id_column
    false,
    false,   -- is_last_updated_on_column
    false,
    false,
    false,   -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column
--
-- Check that we set the primary key details correct for table 'obo__compliance_case_passage_event_map':
SELECT
    cm.target_column_name       AS "target_column_name-PRIMARY_KEY",
    cm.is_primary_key_column    AS "is_primary_key_column-PRIMARY_KEY",
    cm.primary_key_column_order AS "primary_key_column_order-PRIMARY_KEY",
    cm.is_updatable_column      AS "is_updatable_column-PRIMARY_KEY"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=20 AND    -- DSA
    tm.target_table_name='obo__compliance_case_passage_event_map' AND
    cm.is_primary_key_column=true
ORDER BY
    cm.target_column_name;

-- Change ETL algorithm from #4 ("truncate-reload") to #1 ("insert-only" table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-4"
FROM
    etl.table_meta
WHERE
    target_db_id      = 20 AND    -- DSA
    target_table_name = 'obo__compliance_case_passage_event_map';
--
UPDATE
    etl.table_meta
SET
    update_target_table_algorithm_id = 1  -- "Insert-only table"
WHERE
    target_db_id      = 20 AND    -- DSA
    target_table_name = 'obo__compliance_case_passage_event_map';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-1"
FROM
    etl.table_meta
WHERE
    target_db_id      =20 AND    -- DSA
    target_table_name = 'obo__compliance_case_passage_event_map';


--------------------------------------------------------------------------------
--create table obo__svc_lvl_event_impact_map (
--   sleim_id             BIGINT               not null,							<- Column added:	Patch:	1.	Create column_meta row as single column primary key:
--   																													source_column_name='sleim_id'
--   																													target_column_name='sleim_id'
--   																													is_primary_key_column=true
--   																													primary_key_column_order=1
--   																													is_insert_id_column=true
--   																											2.	Previous primary key was (svc_lvl_event_id, svc_lvl_impact_id). 
--   																												Update the *existing* column_meta columns for these columns by setting: 
--   																												is_primary_key_column=false, primary_key_column_order=NULL
--   																											3.	ETL algorithm: 4 -> 1 (insert-only)
--   svc_lvl_event_id     BIGINT               not null,
--   svc_lvl_impact_id    BIGINT               not null,
--   linked_on            TIMESTAMP            not null,
--   etl_batch_id_insert  BIGINT               not null,
--   etl_batch_id_last_update BIGINT               null,
--   constraint PK_OBO__SVC_LVL_EVENT_IMPACT_M primary key (sleim_id)
--);
--------------------------------------------------------------------------------

-- The previous primary key was: (svc_lvl_event_id, svc_lvl_impact_id).
-- This deletes the previous primary key details for these columns:
--
-- Before: 
SELECT
    cm.target_column_name       AS "target_column_name-BEFORE",
    cm.is_primary_key_column    AS "is_primary_key_column-BEFORE",
    cm.primary_key_column_order AS "primary_key_column_order-BEFORE",
    cm.is_updatable_column      AS "is_updatable_column-BEFORE"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=20 AND    -- DSA
    tm.target_table_name='obo__svc_lvl_event_impact_map' AND
    cm.target_column_name IN ('svc_lvl_event_id', 'svc_lvl_impact_id')
ORDER BY
    cm.target_column_name;
--
UPDATE
    etl.column_meta
SET
    is_primary_key_column    = false,
    primary_key_column_order = NULL,
    is_updatable_column      = true
WHERE
    table_meta_id = (SELECT tm.table_meta_id FROM etl.table_meta tm WHERE tm.target_db_id=20 AND tm.target_table_name='obo__svc_lvl_event_impact_map') AND    -- DSA
    target_column_name IN ('svc_lvl_event_id', 'svc_lvl_impact_id');
--
-- After: 
SELECT
    cm.target_column_name       AS "target_column_name-AFTER",
    cm.is_primary_key_column    AS "is_primary_key_column-AFTER",
    cm.primary_key_column_order AS "primary_key_column_order-AFTER",
    cm.is_updatable_column      AS "is_updatable_column-AFTER"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=20 AND    -- DSA
    tm.target_table_name='obo__svc_lvl_event_impact_map' AND
    cm.target_column_name IN ('svc_lvl_event_id', 'svc_lvl_impact_id')
ORDER BY
    cm.target_column_name;

-- Insert column_meta row for new "sleim_id" timestamp column of PSA table 'obo__svc_lvl_event_impact_map'
-- and make this column the primary key for the table:
INSERT INTO etl.column_meta ( 
    column_meta_id,
    table_meta_id,
    source_column_name,
    target_column_name,
    is_primary_key_column,
    primary_key_column_order,
    is_insert_id_column,
    is_inserted_on_column,
    is_last_updated_on_column,
    is_row_can_be_deleted_from_column,
    is_can_delete_row_column,
    is_updatable_column,
    mirror_column,
    compare_column)
VALUES (
    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
    (SELECT table_meta_id FROM etl.table_meta WHERE target_db_id=20 AND target_table_name='obo__svc_lvl_event_impact_map'),    -- DSA
    'sleim_id',
    'sleim_id',
    true,    -- is_primary_key_column
    1,       -- primary_key_column_order
    true,    -- is_insert_id_column
    false,
    false,   -- is_last_updated_on_column
    false,
    false,
    false,   -- is_updatable_column
    true,    -- mirror_column
    true);   -- compare_column
--
-- Check that we set the primary key details correct for table 'obo__svc_lvl_event_impact_map':
SELECT
    cm.target_column_name       AS "target_column_name-PRIMARY_KEY",
    cm.is_primary_key_column    AS "is_primary_key_column-PRIMARY_KEY",
    cm.primary_key_column_order AS "primary_key_column_order-PRIMARY_KEY",
    cm.is_updatable_column      AS "is_updatable_column-PRIMARY_KEY"
FROM
    etl.column_meta cm
INNER JOIN
    etl.table_meta tm ON tm.table_meta_id=cm.table_meta_id
WHERE
    tm.target_db_id=20 AND    -- DSA
    tm.target_table_name='obo__svc_lvl_event_impact_map' AND
    cm.is_primary_key_column=true
ORDER BY
    cm.target_column_name;

-- Change ETL algorithm from #4 ("truncate-reload") to #1 ("insert-only" table):
--
-- Before:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-BEFORE-should-be-4"
FROM
    etl.table_meta
WHERE
    target_db_id      = 20 AND    -- DSA
    target_table_name = 'obo__svc_lvl_event_impact_map';
--
UPDATE
    etl.table_meta
SET
    update_target_table_algorithm_id = 1  -- "Insert-only table"
WHERE
    target_db_id      = 20 AND    -- DSA
    target_table_name = 'obo__svc_lvl_event_impact_map';
--
-- After:
SELECT
    update_target_table_algorithm_id AS "update_target_table_algorithm_id-AFTER-should-be-1"
FROM
    etl.table_meta
WHERE
    target_db_id      = 20 AND    -- DSA
    target_table_name = 'obo__svc_lvl_event_impact_map';



-- Increment the value for DB_VERSION:
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
    19, 
    NULL, 
    'DB_VERSION', 
    'INTEGER', 
    '19', 
    NULL, 
    NULL, 
    NULL) 
ON CONFLICT (configuration_id) DO UPDATE SET (created_on, integer_value, string_value) = (current_timestamp, 19, '19');
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
