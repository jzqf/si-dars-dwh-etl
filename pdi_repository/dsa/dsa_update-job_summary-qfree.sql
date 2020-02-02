SELECT
    tm.table_meta_id AS "tblId",
    tm.source_db_id AS "src",
    tm.source_schema_name AS "srcSch",
    tm.source_table_name AS "srcTable",
    tm.target_db_id AS "tgt",
    tm.target_schema_name AS "tgtSch",
    tm.target_table_name AS "tgtTable",
    tm.update_target_table AS "mir",
    ts.target_last_updated_algorithm_id AS "alg",
    ts.target_last_updated_on AS "target_last_updated_on",
    ts.target_last_updated_num_rows_processed AS "r",
    ts.target_last_updated_num_inserts AS "i",
    ts.target_last_updated_num_updates AS "u",
    ts.target_last_updated_elapsed_time_millis AS "millis",
    ts.target_last_updated_num_rows_processed_per_sec AS "r/s",
    ts.target_last_updated_insert_id_colname AS "iIdCol",
    ts.target_last_updated_insert_id_maxvalue AS "max_iId",
    ts.target_last_updated_last_updated_on_colname AS "luoCol",
    ts.target_last_updated_last_updated_on_maxvalue AS "max_luo"
FROM
    etl.table_meta tm
INNER JOIN
    etl.table_state ts ON ts.table_state_id=tm.table_meta_id
WHERE
        tm.target_db_id=20           -- DSA DB
    AND tm.update_target_table=true  -- Only show data for tables that were just updated
ORDER BY
    tm.target_db_id,
    tm.source_db_id,
    tm.source_schema_name,
    tm.source_table_name