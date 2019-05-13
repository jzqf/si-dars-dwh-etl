
-- Kym should handle the cration of these indexes. These three commented-out SQL
-- commands are here only as a reminder that this should be performed as part
-- of the 19.3 release.
--CREATE INDEX CONCURRENTLY IF NOT EXISTS ix_passage_event_dsrc_data_03    ON passage_event_dsrc_data (cdc_timestamp);
--CREATE INDEX CONCURRENTLY IF NOT EXISTS ix_passage_event_vehicle_data_02 ON passage_event_vehicle_data (cdc_timestamp);
--CREATE INDEX CONCURRENTLY IF NOT EXISTS ix_passage_events_03             ON passage_events (cdc_timestamp);

-- This is so that the "deleter" application does not delete any rows from 
-- these tables until they are loaded again the next time that the ETL job 
-- runs:
UPDATE 
	dwh_etl_state_register 
SET 
	dwh_last_updated_insert_id_colname        = NULL, 
	dwh_last_updated_insert_id_maxvalue       = NULL, 
	dwh_last_updated_last_updated_on_colname  = NULL, 
	dwh_last_updated_last_updated_on_maxvalue = NULL, 
	etl_job_id                                = 0
WHERE
	schema_name='public' AND 
	(
	    table_name='obo__passage_event_dsrc_data'    OR 
	    table_name='obo__passage_event_vehicle_data' OR 
	    table_name='obo__passage_events'             OR
	    table_name='svc_lvl_event_impact_register'   OR
	    table_name='svc_lvl_event_register'
	);
