-- etl_mgmt:
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
