-- ------------------------------------------------------
-- Telekom ETL Simulator
--
-- Date:   2021.09.29
-- Author: Jeffrey Zelt
-- ------------------------------------------------------


-- Validate that Script is run as correct PostgreSQL role in correct DB
DO LANGUAGE plpgsql
$$
BEGIN

    IF current_user != 'postgres' OR current_database() != 'dwh_dsa_obo' THEN
        RAISE WARNING 'Incorrect User/DB. Expected (postgres)/(dwh_dsa_obo) but is (%)/(%).', current_user, current_database();
        SELECT pg_terminate_backend(pg_backend_pid());
    END IF;

END;
$$;

-- ------------------------------------------------------------------------------------------------

DO LANGUAGE plpgsql
$$
  
DECLARE

    v_proc_name                         TEXT                := 'telekom_etl_simulator.sql';
    v_proc_start                        TIMESTAMP           := clock_timestamp();
    v_elapsed_time_sec                  Double precision    := null;
    
BEGIN

    RAISE INFO '-------------------------------------------------------------------------------------------------------------';
    RAISE INFO '%/% - START', TO_CHAR(clock_timestamp(), 'YYYY-MM-DD HH:MI:SS:MS'), v_proc_name;
    RAISE INFO '-------------------------------------------------------------------------------------------------------------';


--SELECT * FROM dwh_etl_state_register_source ORDER BY table_name;

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','mon__alarm','alarm_id','last_updated_on',(SELECT MAX(alarm_id) FROM public.mon__alarm),(SELECT MAX(last_updated_on) FROM public.mon__alarm),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','mon__alarm','alarm_id','last_updated_on',(SELECT MAX(alarm_id) FROM public.mon__alarm),(SELECT MAX(last_updated_on) FROM public.mon__alarm),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','mon__alarm_actions','alarm_action_id',NULL,(SELECT MAX(alarm_action_id) FROM public.mon__alarm_actions),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','mon__alarm_actions','alarm_action_id',NULL,(SELECT MAX(alarm_action_id) FROM public.mon__alarm_actions),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','mon__data_collection_source','dcs_id','last_updated_on',(SELECT MAX(dcs_id) FROM public.mon__data_collection_source),(SELECT MAX(last_updated_on) FROM public.mon__data_collection_source),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','mon__data_collection_source','dcs_id','last_updated_on',(SELECT MAX(dcs_id) FROM public.mon__data_collection_source),(SELECT MAX(last_updated_on) FROM public.mon__data_collection_source),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','mon__managed_objects','managed_object_id','last_updated_on',(SELECT MAX(managed_object_id) FROM public.mon__managed_objects),(SELECT MAX(last_updated_on) FROM public.mon__managed_objects),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','mon__managed_objects','managed_object_id','last_updated_on',(SELECT MAX(managed_object_id) FROM public.mon__managed_objects),(SELECT MAX(last_updated_on) FROM public.mon__managed_objects),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__analysis_detailed_results','analysis_detailed_result_id',NULL,(SELECT MAX(analysis_detailed_result_id) FROM public.obo__analysis_detailed_results),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__analysis_detailed_results','analysis_detailed_result_id',NULL,(SELECT MAX(analysis_detailed_result_id) FROM public.obo__analysis_detailed_results),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__analysis_request','analysis_request_id','analysis_request_status_timestamp',(SELECT MAX(analysis_request_id) FROM public.obo__analysis_request),(SELECT MAX(analysis_request_status_timestamp) FROM public.obo__analysis_request),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__analysis_request','analysis_request_id','analysis_request_status_timestamp',(SELECT MAX(analysis_request_id) FROM public.obo__analysis_request),(SELECT MAX(analysis_request_status_timestamp) FROM public.obo__analysis_request),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__analysis_results','analysis_result_id','last_updated_on',(SELECT MAX(analysis_result_id) FROM public.obo__analysis_results),(SELECT MAX(last_updated_on) FROM public.obo__analysis_results),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__analysis_results','analysis_result_id','last_updated_on',(SELECT MAX(analysis_result_id) FROM public.obo__analysis_results),(SELECT MAX(last_updated_on) FROM public.obo__analysis_results),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__applied_rating_detail_data','ardd_id',NULL,(SELECT MAX(ardd_id) FROM public.obo__applied_rating_detail_data),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__applied_rating_detail_data','ardd_id',NULL,(SELECT MAX(ardd_id) FROM public.obo__applied_rating_detail_data),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__compliance_case_passage_event_map','ccpem_id',NULL,(SELECT MAX(ccpem_id) FROM public.obo__compliance_case_passage_event_map),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__compliance_case_passage_event_map','ccpem_id',NULL,(SELECT MAX(ccpem_id) FROM public.obo__compliance_case_passage_event_map),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__compliance_case_register','compliance_case_id','last_updated_on',(SELECT MAX(compliance_case_id) FROM public.obo__compliance_case_register),(SELECT MAX(last_updated_on) FROM public.obo__compliance_case_register),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__compliance_case_register','compliance_case_id','last_updated_on',(SELECT MAX(compliance_case_id) FROM public.obo__compliance_case_register),(SELECT MAX(last_updated_on) FROM public.obo__compliance_case_register),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__control_points','control_point_id','last_updated_on',(SELECT MAX(control_point_id) FROM public.obo__control_points),(SELECT MAX(last_updated_on) FROM public.obo__control_points),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__control_points','control_point_id','last_updated_on',(SELECT MAX(control_point_id) FROM public.obo__control_points),(SELECT MAX(last_updated_on) FROM public.obo__control_points),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__control_sites','control_site_id',NULL,(SELECT MAX(control_site_id) FROM public.obo__control_sites),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__control_sites','control_site_id',NULL,(SELECT MAX(control_site_id) FROM public.obo__control_sites),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__dsrc_data_receipt','ddr_id',NULL,(SELECT MAX(ddr_id) FROM public.obo__dsrc_data_receipt),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__dsrc_data_receipt','ddr_id',NULL,(SELECT MAX(ddr_id) FROM public.obo__dsrc_data_receipt),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__image','image_id',NULL,(SELECT MAX(image_id) FROM public.obo__image),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__image','image_id',NULL,(SELECT MAX(image_id) FROM public.obo__image),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__obu_register','obu_register_id','last_seen_on',(SELECT MAX(obu_register_id) FROM public.obo__obu_register),(SELECT MAX(last_seen_on) FROM public.obo__obu_register),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__obu_register','obu_register_id','last_seen_on',(SELECT MAX(obu_register_id) FROM public.obo__obu_register),(SELECT MAX(last_seen_on) FROM public.obo__obu_register),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__passage_event','passage_event_id','cdc_timestamp',(SELECT MAX(passage_event_id) FROM public.obo__passage_event),(SELECT MAX(cdc_timestamp) FROM public.obo__passage_event),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__passage_event','passage_event_id','cdc_timestamp',(SELECT MAX(passage_event_id) FROM public.obo__passage_event),(SELECT MAX(cdc_timestamp) FROM public.obo__passage_event),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__passage_event_derived_data','pedd_id','last_updated_on',(SELECT MAX(pedd_id) FROM public.obo__passage_event_derived_data),(SELECT MAX(last_updated_on) FROM public.obo__passage_event_derived_data),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__passage_event_derived_data','pedd_id','last_updated_on',(SELECT MAX(pedd_id) FROM public.obo__passage_event_derived_data),(SELECT MAX(last_updated_on) FROM public.obo__passage_event_derived_data),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__passage_event_derived_data_details','pedd_id','last_updated_on',(SELECT MAX(pedd_id) FROM public.obo__passage_event_derived_data_details),(SELECT MAX(last_updated_on) FROM public.obo__passage_event_derived_data_details),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__passage_event_derived_data_details','pedd_id','last_updated_on',(SELECT MAX(pedd_id) FROM public.obo__passage_event_derived_data_details),(SELECT MAX(last_updated_on) FROM public.obo__passage_event_derived_data_details),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__passage_event_dsrc_data','pe_dsrc_data_id','cdc_timestamp',(SELECT MAX(pe_dsrc_data_id) FROM public.obo__passage_event_dsrc_data),(SELECT MAX(cdc_timestamp) FROM public.obo__passage_event_dsrc_data),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__passage_event_dsrc_data','pe_dsrc_data_id','cdc_timestamp',(SELECT MAX(pe_dsrc_data_id) FROM public.obo__passage_event_dsrc_data),(SELECT MAX(cdc_timestamp) FROM public.obo__passage_event_dsrc_data),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__passage_event_image_data','peid_id',NULL,(SELECT MAX(peid_id) FROM public.obo__passage_event_image_data),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__passage_event_image_data','peid_id',NULL,(SELECT MAX(peid_id) FROM public.obo__passage_event_image_data),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__passage_event_rse_logic_data','perseld_id',NULL,(SELECT MAX(perseld_id) FROM public.obo__passage_event_rse_logic_data),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__passage_event_rse_logic_data','perseld_id',NULL,(SELECT MAX(perseld_id) FROM public.obo__passage_event_rse_logic_data),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__passage_event_vehicle_data','pe_vehicle_data_id','cdc_timestamp',(SELECT MAX(pe_vehicle_data_id) FROM public.obo__passage_event_vehicle_data),(SELECT MAX(cdc_timestamp) FROM public.obo__passage_event_vehicle_data),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__passage_event_vehicle_data','pe_vehicle_data_id','cdc_timestamp',(SELECT MAX(pe_vehicle_data_id) FROM public.obo__passage_event_vehicle_data),(SELECT MAX(cdc_timestamp) FROM public.obo__passage_event_vehicle_data),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__roads','road_id',NULL,(SELECT MAX(road_id) FROM public.obo__roads),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__roads','road_id',NULL,(SELECT MAX(road_id) FROM public.obo__roads),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__road_scheme_validity','road_scheme_validity_id','last_updated_on',(SELECT MAX(road_scheme_validity_id) FROM public.obo__road_scheme_validity),(SELECT MAX(last_updated_on) FROM public.obo__road_scheme_validity),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__road_scheme_validity','road_scheme_validity_id','last_updated_on',(SELECT MAX(road_scheme_validity_id) FROM public.obo__road_scheme_validity),(SELECT MAX(last_updated_on) FROM public.obo__road_scheme_validity),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__road_section','road_section_id',NULL,(SELECT MAX(road_section_id) FROM public.obo__road_section),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__road_section','road_section_id',NULL,(SELECT MAX(road_section_id) FROM public.obo__road_section),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__road_segments','road_segment_id',NULL,(SELECT MAX(road_segment_id) FROM public.obo__road_segments),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__road_segments','road_segment_id',NULL,(SELECT MAX(road_segment_id) FROM public.obo__road_segments),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__svc_lvl_event_impact_map','sleim_id',NULL,(SELECT MAX(sleim_id) FROM public.obo__svc_lvl_event_impact_map),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__svc_lvl_event_impact_map','sleim_id',NULL,(SELECT MAX(sleim_id) FROM public.obo__svc_lvl_event_impact_map),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__svc_lvl_event_log','slelog_id',NULL,(SELECT MAX(slelog_id) FROM public.obo__svc_lvl_event_log),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__svc_lvl_event_log','slelog_id',NULL,(SELECT MAX(slelog_id) FROM public.obo__svc_lvl_event_log),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__svc_lvl_event_register','svc_lvl_event_id','last_updated_on',(SELECT MAX(svc_lvl_event_id) FROM public.obo__svc_lvl_event_register),(SELECT MAX(last_updated_on) FROM public.obo__svc_lvl_event_register),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__svc_lvl_event_register','svc_lvl_event_id','last_updated_on',(SELECT MAX(svc_lvl_event_id) FROM public.obo__svc_lvl_event_register),(SELECT MAX(last_updated_on) FROM public.obo__svc_lvl_event_register),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__svc_lvl_impact_details','slid_id',NULL,(SELECT MAX(slid_id) FROM public.obo__svc_lvl_impact_details),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__svc_lvl_impact_details','slid_id',NULL,(SELECT MAX(slid_id) FROM public.obo__svc_lvl_impact_details),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__svc_lvl_impact_register','svc_lvl_impact_id','last_updated_on',(SELECT MAX(svc_lvl_impact_id) FROM public.obo__svc_lvl_impact_register),(SELECT MAX(last_updated_on) FROM public.obo__svc_lvl_impact_register),1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__svc_lvl_impact_register','svc_lvl_impact_id','last_updated_on',(SELECT MAX(svc_lvl_impact_id) FROM public.obo__svc_lvl_impact_register),(SELECT MAX(last_updated_on) FROM public.obo__svc_lvl_impact_register),dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__topology_road_section_control_points','toporscp_id',NULL,(SELECT MAX(toporscp_id) FROM public.obo__topology_road_section_control_points),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__topology_road_section_control_points','toporscp_id',NULL,(SELECT MAX(toporscp_id) FROM public.obo__topology_road_section_control_points),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__topology_road_sections','toporsec_id',NULL,(SELECT MAX(toporsec_id) FROM public.obo__topology_road_sections),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__topology_road_sections','toporsec_id',NULL,(SELECT MAX(toporsec_id) FROM public.obo__topology_road_sections),NULL,dwh_etl_state_register_source.etl_job_id+1);

INSERT INTO public.dwh_etl_state_register_source 
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) VALUES
('public','obo__topology_road_segments','toporseg_id',NULL,(SELECT MAX(toporseg_id) FROM public.obo__topology_road_segments),NULL,1)
ON CONFLICT (schema_name, table_name) DO UPDATE SET
(schema_name,table_name,dwh_last_updated_insert_id_colname,dwh_last_updated_last_updated_on_colname,dwh_last_updated_insert_id_maxvalue,dwh_last_updated_last_updated_on_maxvalue,etl_job_id) =
('public','obo__topology_road_segments','toporseg_id',NULL,(SELECT MAX(toporseg_id) FROM public.obo__topology_road_segments),NULL,dwh_etl_state_register_source.etl_job_id+1);

--SELECT * FROM dwh_etl_state_register_source ORDER BY table_name;


    v_elapsed_time_sec := extract(epoch from clock_timestamp() - v_proc_start);

    RAISE INFO '-------------------------------------------------------------------------------------------------------------';
    RAISE INFO '%/% - END, elapsed_time=% sec', TO_CHAR(clock_timestamp(), 'YYYY-MM-DD HH:MI:SS:MS'), v_proc_name, v_elapsed_time_sec;
    RAISE INFO '-------------------------------------------------------------------------------------------------------------';

END;
$$;

