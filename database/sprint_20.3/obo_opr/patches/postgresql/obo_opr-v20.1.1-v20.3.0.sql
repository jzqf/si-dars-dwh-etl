
-- This is so that the "deleter" application does not delete any rows from 
-- these tables until they are loaded again the next time that the ETL job 
-- runs, or it is because tables have been removed from the PSA so that their
-- dwh_etl_state_register rows are no longer needed:

DELETE FROM
    dwh_etl_state_register
WHERE
    schema_name='public' AND 
    table_name IN
    (
       'obo__svc_lvl_impact_domain',
       'obo__svc_lvl_event_impact_register'
    );
