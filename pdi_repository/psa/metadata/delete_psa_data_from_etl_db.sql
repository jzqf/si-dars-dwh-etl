-- This script deletes all data related to the PSA DB from the ETL DB.
--
-- It should probably be possible to omit the condition:
--
--     tm.source_db_id IN (2, 4, 6)
--
-- everywhere below because the single condition:
--
--     tm.target_db_id=10
--
-- alone should be sufficient. But I include both to be more explicit.
--
-- Version:  1.0
-- Updated:  2018.10.25
-- Author:   Jeffrey Zelt
-- Changes:  Initial version
--
-- Version:  2.0
-- Updated:  2019.09.12
-- Author:   Jeffrey Zelt
-- Changes:  Updated to treat new tables "etl_run" & "target_table_progress", as
--           well as a change in the data model for table "target_table_update".

SELECT COUNT(*) FROM etl.etl_run r WHERE etl_run_id IN (
    SELECT 
        DISTINCT etl_run_id 
    FROM 
        etl.target_table_update ttu 
    INNER JOIN 
        etl.table_meta tm ON tm.table_meta_id=ttu.table_meta_id WHERE                                                      tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10);
SELECT COUNT(*) FROM etl.table_meta tm                                                                               WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.column_meta cm           INNER JOIN etl.table_meta tm ON cm.table_meta_id =tm.table_meta_id WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.table_state ts           INNER JOIN etl.table_meta tm ON ts.table_state_id=tm.table_meta_id WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.target_table_update ttu  INNER JOIN etl.table_meta tm ON ttu.table_meta_id=tm.table_meta_id WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.target_table_compare ttc INNER JOIN etl.table_meta tm ON ttc.table_meta_id=tm.table_meta_id WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.target_table_progress ttp WHERE target_table_update_id IN (
    SELECT 
        target_table_update_id 
    FROM 
        etl.target_table_update ttu 
    INNER JOIN 
        etl.table_meta tm ON tm.table_meta_id=ttu.table_meta_id WHERE                                                      tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10);


-- Delete column_meta rows before table_meta rows:
DELETE FROM etl.column_meta cm USING etl.table_meta tm           WHERE cm.table_meta_id =tm.table_meta_id AND              tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;

-- Delete table_state rows before table_meta rows:
DELETE FROM etl.table_state ts USING etl.table_meta tm           WHERE ts.table_state_id=tm.table_meta_id AND              tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;

---- Delete target_table_progress rows before target_table_update rows:
--DELETE FROM etl.target_table_progress ttp WHERE target_table_update_id IN (
--    SELECT 
--        target_table_update_id 
--    FROM 
--        etl.target_table_update ttu 
--    INNER JOIN 
--        etl.table_meta tm ON tm.table_meta_id=ttu.table_meta_id WHERE                                                      tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10);

-- Delete etl_run rows. This will also delete all related target_table_update & target_table_progress rows:
DELETE FROM etl.etl_run r WHERE etl_run_id IN (
    SELECT 
        DISTINCT etl_run_id 
    FROM 
        etl.target_table_update ttu 
    INNER JOIN 
        etl.table_meta tm ON tm.table_meta_id=ttu.table_meta_id WHERE                                                      tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10);

---- Delete target_table_update rows before table_meta rows:
--DELETE FROM etl.target_table_update ttu USING etl.table_meta tm  WHERE ttu.table_meta_id=tm.table_meta_id AND              tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;

-- Delete target_table_compare rows before table_meta rows:
DELETE FROM etl.target_table_compare ttc USING etl.table_meta tm WHERE ttc.table_meta_id=tm.table_meta_id AND              tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;

-- Delete table_meta rows last:
DELETE FROM etl.table_meta tm                                                                                        WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;


-- These SELECTs should show zero COUNTs:
SELECT COUNT(*) FROM etl.etl_run r WHERE etl_run_id IN (
    SELECT 
        DISTINCT etl_run_id 
    FROM 
        etl.target_table_update ttu 
    INNER JOIN 
        etl.table_meta tm ON tm.table_meta_id=ttu.table_meta_id WHERE                                                      tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10);
SELECT COUNT(*) FROM etl.table_meta tm                                                                               WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.column_meta cm           INNER JOIN etl.table_meta tm ON cm.table_meta_id =tm.table_meta_id WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.table_state ts           INNER JOIN etl.table_meta tm ON ts.table_state_id=tm.table_meta_id WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.target_table_update ttu  INNER JOIN etl.table_meta tm ON ttu.table_meta_id=tm.table_meta_id WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.target_table_compare ttc INNER JOIN etl.table_meta tm ON ttc.table_meta_id=tm.table_meta_id WHERE tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10;
SELECT COUNT(*) FROM etl.target_table_progress ttp WHERE target_table_update_id IN (
    SELECT 
        target_table_update_id 
    FROM 
        etl.target_table_update ttu 
    INNER JOIN 
        etl.table_meta tm ON tm.table_meta_id=ttu.table_meta_id WHERE                                                      tm.source_db_id IN (2, 4, 6) AND tm.target_db_id=10);
