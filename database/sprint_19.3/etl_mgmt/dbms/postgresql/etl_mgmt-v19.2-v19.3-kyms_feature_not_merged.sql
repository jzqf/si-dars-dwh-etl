-- These details must be addressed if Kym does not merge his git feature branch:
--
--     feature/QFC-BODARS-3296_etl-cdc-extension
--
-- in project:
--
--     si-dars-pdm-obo
--
-- Kym's feature branch renamed a column of table:
--
--     obo_opr.svc_lvl_event_register
-- 
-- registered_by_suid -> registered_by_sid . We can keep the new name of this 
-- column in the dwh_psa_obo database as long as we specify the correct column
-- name in thre obo_opr database, which will be the "old", incorrect column 
-- name:
THIS MUST BE TESTED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
WITH tm AS (
    SELECT
        table_meta_id
    FROM
        etl.table_meta
    WHERE
        source_db_id=2           -- obo_opr
        AND target_db_id = 10    -- PSA
        AND source_table_name='svc_lvl_event_register'
)
UPDATE 
    etl.column_meta cm
SET 
    source_column_name='registered_by_suid'        -- "Old" column name to revert to
WHERE 
    cm.table_meta_id = tm.table_meta_id
    AND cm.source_column_name='registered_by_sid'  -- "New" column name to revert to old