
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
	    table_name='obo__topology_road_section_control_points'
	);
