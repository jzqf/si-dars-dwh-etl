-- This script deletes all data related to the DSA DB from the ETL DB.
--
-- It should probably be possible to omit the condition:
--
--     WHERE tm.source_db_id=10
--
-- everywhere below because the single condition:
--
--     tm.target_db_id=20
--
-- alone should be sufficient. But I include both to be more explicit.
--
-- Version:  1.0
-- Updated:  2018.10.30
-- Author:   Jeffrey Zelt
-- Changes:  Initial version

SELECT COUNT(*) FROM etl.table_meta tm                                                                               WHERE tm.source_db_id=10 AND tm.target_db_id=20;
SELECT COUNT(*) FROM etl.column_meta cm INNER JOIN etl.table_meta tm ON   cm.table_meta_id=tm.table_meta_id          WHERE tm.source_db_id=10 AND tm.target_db_id=20;
SELECT tm.source_schema_name, tm.source_table_name, tm.target_schema_name, tm.target_table_name 
                FROM etl.table_meta tm                                                                               WHERE tm.source_db_id=10 AND tm.target_db_id=20;
SELECT COUNT(*) FROM etl.target_table_update ttu  INNER JOIN etl.table_meta tm ON ttu.table_meta_id=tm.table_meta_id WHERE tm.source_db_id=10 AND tm.target_db_id=20;
SELECT COUNT(*) FROM etl.target_table_compare ttc INNER JOIN etl.table_meta tm ON ttc.table_meta_id=tm.table_meta_id WHERE tm.source_db_id=10 AND tm.target_db_id=20;

-- Delete column_meta rows before table_meta rows:
DELETE FROM etl.column_meta cm USING etl.table_meta tm WHERE cm.table_meta_id=tm.table_meta_id AND                         tm.source_db_id=10 AND tm.target_db_id=20;

-- Delete table_state rows before table_meta rows:
DELETE FROM etl.table_state ts USING etl.table_meta tm WHERE ts.table_state_id=tm.table_meta_id AND                        tm.source_db_id=10 AND tm.target_db_id=20;

-- Delete target_table_update rows before table_meta rows:
DELETE FROM etl.target_table_update ttu USING etl.table_meta tm  WHERE ttu.table_meta_id=tm.table_meta_id AND              tm.source_db_id=10 AND tm.target_db_id=20;

-- Delete target_table_compare rows before table_meta rows:
DELETE FROM etl.target_table_compare ttc USING etl.table_meta tm WHERE ttc.table_meta_id=tm.table_meta_id AND              tm.source_db_id=10 AND tm.target_db_id=20;

-- Delete table_meta rows last:
DELETE FROM etl.table_meta tm                                                                                        WHERE tm.source_db_id=10 AND tm.target_db_id=20;

SELECT COUNT(*) FROM etl.table_meta tm                                                                               WHERE tm.source_db_id=10 AND tm.target_db_id=20;
SELECT COUNT(*) FROM etl.column_meta cm INNER JOIN etl.table_meta tm ON   cm.table_meta_id=tm.table_meta_id          WHERE tm.source_db_id=10 AND tm.target_db_id=20;
SELECT tm.source_schema_name, tm.source_table_name, tm.target_schema_name, tm.target_table_name 
                FROM etl.table_meta tm                                                                               WHERE tm.source_db_id=10 AND tm.target_db_id=20;
SELECT COUNT(*) FROM etl.target_table_update ttu  INNER JOIN etl.table_meta tm ON ttu.table_meta_id=tm.table_meta_id WHERE tm.source_db_id=10 AND tm.target_db_id=20;
SELECT COUNT(*) FROM etl.target_table_compare ttc INNER JOIN etl.table_meta tm ON ttc.table_meta_id=tm.table_meta_id WHERE tm.source_db_id=10 AND tm.target_db_id=20;