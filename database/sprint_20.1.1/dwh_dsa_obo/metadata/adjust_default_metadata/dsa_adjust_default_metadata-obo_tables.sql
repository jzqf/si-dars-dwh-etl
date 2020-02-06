-- This SQL script contains the appropriate DML that must be run on the 
-- "etl_mgmt" database *after* the default metatdata is generated by the 
-- PDI job:
--
--     /dsa/jb_dsa-repopulate_metadata_tables.kjb .
--
-- This file contains adjustment SQL commands only for tables associated with
-- the "obo" tables in the PSA DB. If there are tables in the PSA DB that are
-- associated with other databases, the adjustment commands will be found in
-- other files in the same directory where this file is stored. All such 
-- adjustment scripts must be executed if the PDI job generates default metadata
-- for tables that original in all of these databases.
--
-- This SQL should be executed in a transaction in case syntax errors or any
-- other types of errors are introduced.


--------------------------------------------------------------------------------
-- Create rows for the metadata tables that cannot be created automagically by 
-- the PDI job:
--
--     /dsa/jb_dsa-repopulate_metadata_tables.kjb
--
-- These rows will generally be associated with tables that are maintained by
-- *custom* ETL code.
--
--
-- THIS BLOCK OF COMMENTED-OUT CODE CAN BE DELETED, AS THE obo__passage_event_derived_data_with_rating TABLE HAS BEEN REMOVED FROM THE DSA:

-- Target table: DSA.passage_event_derived_data_with_rating:
-- POSTGRESQL-SPECIFIC (ON CONFLICT):
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                               -- source_column_name
--        'applied_axle_tariff_category_id',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                              -- source_column_name
--        'applied_euro_emission_class_id',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                        -- source_column_name
--        'applied_lpn_country_code',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,               -- source_column_name
--        'base_rate_total',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                          -- source_column_name
--        'applied_infrastructure_fee',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                         -- source_column_name
--        'applied_infrastructure_vat',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                 -- source_column_name
--        'applied_surcharge',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                     -- source_column_name
--        'applied_surcharge_vat',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                          -- source_column_name
--        'applied_external_fee_noise',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                              -- source_column_name
--        'applied_external_fee_noise_vat',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                        -- source_column_name
--        'applied_external_fee_air',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                            -- source_column_name
--        'applied_external_fee_air_vat',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                -- source_column_name
--        'peddd_created_on',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--INSERT INTO etl.column_meta (column_meta_id, table_meta_id, source_column_name, target_column_name, is_updatable_column, mirror_column, compare_column)
--VALUES (
--    (SELECT MAX(column_meta_id)+1 FROM etl.column_meta),
--    (SELECT table_meta_id         FROM etl.table_meta WHERE 
--        source_db_id=10 AND source_schema_name='public' AND source_table_name='obo__passage_event_derived_data' AND            -- PSA source table
--        target_db_id=20 AND target_schema_name='public' AND target_table_name='obo__passage_event_derived_data_with_rating'),  -- DSA target table
--        NULL,                     -- source_column_name
--        'peddd_last_updated_on',  -- target_column_name
--        true,  -- is_updatable_column: Value is irrelevant because it will not be used by the custom update algorithm
--        true,  -- mirror_column:       Value is irrelevant because it will not be used by the custom update algorithm
--        false  -- compare_column:      Do not try to "compare" the column because there is no source column to compare with
--) ON CONFLICT (table_meta_id, target_column_name) DO NOTHING;  -- No error if we try to insert the same column a second time
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Specify target column names that are not the same as the source column name:
--
-- If incorrect details are specified here, they will probably be caught when 
-- the ETL code runs because errors will be triggered if the column names are
-- wrong.
--
-- Source table: road_scheme_validity:
UPDATE etl.column_meta cm SET target_column_name='valid_from' FROM etl.table_meta tm WHERE 
    tm.source_table_name='obo__road_scheme_validity' AND cm.source_column_name='tz_based_valid_from' AND 
    cm.table_meta_id=tm.table_meta_id AND 
    tm.source_db_id=10 AND tm.source_schema_name='public' AND tm.target_db_id=20 AND tm.target_schema_name='public';  -- PSA -> DSA
UPDATE etl.column_meta cm SET target_column_name='valid_to' FROM etl.table_meta tm WHERE 
    tm.source_table_name='obo__road_scheme_validity' AND cm.source_column_name='tz_based_valid_to' AND
    cm.table_meta_id=tm.table_meta_id AND 
    tm.source_db_id=10 AND tm.source_schema_name='public' AND tm.target_db_id=20 AND tm.target_schema_name='public';  -- PSA -> DSA
--
-- Rename "road_scheme_id" *target* columns for all tables to "road_scheme_validity_id".
-- This is DML to just update the metadata appropriately; the appropriate DDL must also be
-- written to *generate* the target tables with columns named "road_scheme_validity_id".
UPDATE etl.column_meta cm SET target_column_name='road_scheme_validity_id' FROM etl.table_meta tm WHERE 
    cm.source_column_name='road_scheme_id' AND
    cm.table_meta_id=tm.table_meta_id AND 
    tm.source_db_id=10 AND tm.source_schema_name='public' AND tm.target_db_id=20 AND tm.target_schema_name='public';  -- PSA -> DSA
--
-- Table-specific adjustments:
--
-- obo__passage_events:
--
-- Both the obo_opr & dwh_psa_db databases have a column named 
-- "scheme_compliance_sub_category_id", where it should have been named
-- "detected_scheme_compliance_sub_category_id". The DSA uses the "correct" 
-- name.
UPDATE etl.column_meta cm SET target_column_name='detected_scheme_compliance_sub_category_id' FROM etl.table_meta tm WHERE 
    cm.table_meta_id=tm.table_meta_id AND 
    tm.source_table_name='obo__passage_events' AND cm.source_column_name='scheme_compliance_sub_category_id' AND
    tm.source_db_id=10 AND tm.source_schema_name='public' AND tm.target_db_id=20 AND tm.target_schema_name='public';  -- PSA -> DSA
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Specify columns of source tables to *not* mirror and *not* compare:
UPDATE etl.column_meta cm SET mirror_column=false, compare_column=false FROM etl.table_meta tm 
WHERE 
    cm.table_meta_id=tm.table_meta_id AND 
    tm.source_db_id=10 AND tm.source_schema_name='public' AND tm.target_db_id=20 AND tm.target_schema_name='public' AND  -- PSA -> DSA
    
    -- These conditions list all of the columns of each source table that *shall* be mirrored and compared.
    -- The "NOT IN" operator is then used to update all of the *remaining* column_meta rows to specify 
    -- that they will *not* be mirrored or compared. The "source" column names are used here, in case
    -- the target column names change. This should reduce the number of changes necessary if the target 
    -- column names change and, therefore, make this code less brittle when such changes are introduced.
    --
    -- Tables that are not explicitly listed here will have *all* columns mirrored and compared.
    (
        tm.source_table_name='obo__analysis_detailed_results' AND cm.source_column_name NOT IN (
            'analysis_detailed_result_id', 
            'analysis_result_id', 
            'licence_plate_is_visible', 
            'licence_plate_is_human_readable', 
            'licence_plate_is_obscured', 
            'licence_plate_is_missing', 
            'licence_plate_is_tampered', 
            'licence_plate_is_dirty', 
            'licence_plate_is_bad_condition', 
            'image_is_poor_quality', 
            'image_is_weather_affected', 
            'image_is_mispositioned', 
            'image_is_miscorrelated')
-- THIS BLOCK OF COMMENTED-OUT CODE CAN BE DELETED, AS THE obo__analysis_queue TABLE HAS BEEN REMOVED FROM THE DSA:
--    OR  tm.source_table_name='obo__analysis_queue' AND cm.source_column_name NOT IN (
--            'analysis_queue_id', 
--            'analysis_queue_status_id',
--            'analysis_queue_type_id', 
--            'analysis_request_id', 
--            'pedd_id',
--            'cdc_timestamp')
     OR tm.source_table_name='obo__analysis_request' AND cm.source_column_name NOT IN (
            'analysis_request_id', 
            'passage_event_id', 
            'pedd_id',
            'analysis_request_type_id',                  -- new column
            'analysis_request_status_id',                -- new column
            'analysis_request_status_timestamp',         -- new column
            'analysis_result_id bigint')                 -- new column
     OR tm.source_table_name='obo__analysis_request_status' AND cm.source_column_name NOT IN (
            'analysis_request_status_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__analysis_request_type' AND cm.source_column_name NOT IN (
            'analysis_request_type_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__analysis_results' AND cm.source_column_name NOT IN (
            'analysis_result_id', 
            'analysis_result_type_id', 
            'analysis_result_status_id', 
            'analysis_result_status_timestamp', 
            'passage_event_id', 
            'pedd_id', 
            'licence_plate_country_code',
            'licence_plate_number', 
            'scheme_liability_category_id',
            'scheme_compliance_category_id', 
            'axle_tariff_category_id',
            'last_updated_on')
     OR tm.source_table_name='obo__analysis_result_status' AND cm.source_column_name NOT IN (
            'analysis_result_status_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__analysis_result_type' AND cm.source_column_name NOT IN (
            'analysis_result_type_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__applied_rating_detail_data' AND cm.source_column_name NOT IN (
            'ardd_id', 
            'pedd_id', 
            'rate_component_fee_type_id', 
            'rate_component_fee_category_id', 
            'rate_component_fee_amount', 
            'rate_component_vat', 
            'rate_component_fee_code')
     OR tm.source_table_name='obo__axle_tariff_category' AND cm.source_column_name NOT IN (
            'axle_tariff_category_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__compliance_case_passage_event_map' AND cm.source_column_name NOT IN (
            'compliance_case_id', 
            'pedd_id', 
            'linked_on')
     OR tm.source_table_name='obo__compliance_case_register' AND cm.source_column_name NOT IN (
            'compliance_case_id', 
            'compliance_case_type_id', 
            'compliance_case_status_id', 
            'registered_on',
            'last_updated_on')
     OR tm.source_table_name='obo__control_point_event_capture_category' AND cm.source_column_name NOT IN (
            'control_point_event_capture_category_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__control_point_status' AND cm.source_column_name NOT IN (
            'control_point_status_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__control_point_type' AND cm.source_column_name NOT IN (
            'control_point_type_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__control_points' AND cm.source_column_name NOT IN (
            'control_point_id', 
            'control_point_type_id', 
            'control_point_status_id', 
            'control_point_identifier', 
            'latitude', 
            'longitude', 
            'control_site_id',
            'last_updated_on')
     OR tm.source_table_name='obo__control_sites' AND cm.source_column_name NOT IN (
            'control_site_id', 
            'control_site_identifier')
     OR tm.source_table_name='obo__country' AND cm.source_column_name NOT IN (
            'country_id', 
            'enum_name', 
            'iso2_code', 
            'iso3_code', 
            'un_vehicle_sign', 
            'ita2_number_mirror', 
            'description')
     OR tm.source_table_name='obo__data_authorities' AND cm.source_column_name NOT IN (
            'data_authority_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__dsrc_data_receipt' AND cm.source_column_name NOT IN (
            'ddr_id', 
            'pe_dsrc_data_id', 
            'data_sequence_id', 
            'session_time', 
            'session_service_provider', 
            'session_location_of_station', 
            'session_location_logical_lane', 
            'session_location_travel_direction', 
            'session_type', 
            'session_result', 
            'session_tariff_class', 
            'session_claimed_class', 
            'session_fee', 
            'session_contract_provider', 
            'session_type_of_contract')
     OR tm.source_table_name='obo__euro_emissions_class' AND cm.source_column_name NOT IN (
            'euro_emissions_class_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__image' AND cm.source_column_name NOT IN (
            'image_id', 
            'image_type_id', 
            'vehicle_image_id', 
            'image_encoding_type_id', 
            'image_width', 
            'image_height', 
            'image_data_size', 
            'file_id')
     OR tm.source_table_name='obo__image_view' AND cm.source_column_name NOT IN (
            'image_view_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__obu_register' AND cm.source_column_name NOT IN (
            'obu_register_id', 
            'obu_register_status_id', 
            'manufacturer_id', 
            'equipment_obu_id', 
            'first_seen_on', 
            'last_seen_on')
     OR tm.source_table_name='obo__obu_register_status' AND cm.source_column_name NOT IN (
            'obu_register_status_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__passage_events' AND cm.source_column_name NOT IN (
            'passage_event_id', 
            'passage_event_type_id', 
            'data_arrival_timestamp', 
            'passage_event_timestamp', 
            'control_point_id',
            'control_point_event_capture_category_id', 
            'charged_road_section_id', 
            'obu_present',
            'obu_count',
            'vehicle_image_count',
            'detected_scheme_liability_category_id', 
            'detected_scheme_compliance_category_id', 
            'scheme_compliance_sub_category_id',    -- This column is named "detected_scheme_compliance_sub_category_id" in the DSA
            'detected_axle_tariff_category_id',
            'detected_lpn_country_code',
            'detected_lpn_number',
            'declared_axle_tariff_category_id',
            'declared_euro_emission_class_id',
            'declared_lpn_country_code',
            'declared_lpn_number',
            'cdc_timestamp'
            )
-- THIS BLOCK OF COMMENTED-OUT CODE CAN BE DELETED, AS THE obo__passage_event_derived_data_with_rating TABLE HAS BEEN REMOVED FROM THE DSA:
--     OR tm.source_table_name='obo__passage_event_derived_data' AND tm.target_table_name='obo__passage_event_derived_data_with_rating' AND cm.source_column_name NOT IN (
--            -- Many additional etl.column_meta rows are created above for "custom" 
--            -- (de-normalized) columns of this target table.
--            'pedd_id', 
--            'pedd_status_id', 
--            'created_on', 
--            'last_updated_on')
     OR tm.source_table_name='obo__passage_event_derived_data' AND tm.target_table_name='obo__passage_event_derived_data' AND cm.source_column_name NOT IN (
            'pedd_id', 
            'pedd_status_id', 
            'passage_event_id', 
            'passage_event_timestamp', 
            'external_reference_timestamp', 
            'created_on', 
            'last_updated_on')
     OR tm.source_table_name='obo__passage_event_derived_data_details' AND cm.source_column_name NOT IN (
            'pedd_id', 
            'created_on', 
            'identified_as_duplicate', 
            'identified_as_miscorrelated',
            'last_updated_on', 
            'passage_event_id', 
            'passage_event_type_id', 
            'passage_event_timestamp', 
            'control_point_id', 
            'obu_present',
            'applied_scheme_liability_category_id',
            'applied_scheme_compliance_category_id',
            'applied_scheme_compliance_sub_category_id',
            'applied_axle_tariff_category_id', 
            'applied_euro_emission_class_id', 
            'applied_lpn_country', 
            'applied_lpn_number',
            'applied_payment_means_pan',
            'applied_obuid',
            'base_rate_total',
            'rate_modification_category_id')
     OR tm.source_table_name='obo__passage_event_dsrc_data' AND cm.source_column_name NOT IN (
            'pe_dsrc_data_id', 
            'passage_event_id', 
            'obe_status', 
            'equipment_obu_id',
            'payment_means_pan',
            'cdc_timestamp')
     OR tm.source_table_name='obo__passage_event_image_data' AND cm.source_column_name NOT IN (
            'peid_id', 
            'pe_vehicle_data_id', 
            'passage_event_id', 
            'data_sequence_id', 
            'camera_id', 
            'capture_timestamp', 
            'captured_vehicle_image_view_id')
     OR tm.source_table_name='obo__passage_event_rse_logic_data' AND cm.source_column_name NOT IN (
            'perseld_id', 
            'passage_event_id', 
            'rse_passage_type_id', 
            'rse_compliance_check_dsrc_check_id',
            'rse_compliance_check_axles_check_id')
     OR tm.source_table_name='obo__passage_event_type' AND cm.source_column_name NOT IN (
            'passage_event_type_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__passage_event_vehicle_data' AND cm.source_column_name NOT IN (
            'pe_vehicle_data_id', 
            'passage_event_id', 
            'passage_event_timestamp', 
            'control_point_id', 
            'vehicle_length', 
            'vehicle_height', 
            'vehicle_width', 
            'vehicle_speed',
            'cdc_timestamp')
     OR tm.source_table_name='obo__pedd_status' AND cm.source_column_name NOT IN (
            'pedd_status_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__rate_component_fee_category' AND cm.source_column_name NOT IN (
            'rate_component_fee_category_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__rate_component_fee_type' AND cm.source_column_name NOT IN (
            'rate_component_fee_type_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__rate_modification_category' AND cm.source_column_name NOT IN (
            'rate_modification_category_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__road_scheme_status' AND cm.source_column_name NOT IN (
            'road_scheme_status_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__road_scheme_validity' AND cm.source_column_name NOT IN (
            'road_scheme_id', 
            'road_scheme_status_id', 
            'tz_based_valid_from', 
            'tz_based_valid_to',
            'last_updated_on')
     OR tm.source_table_name='obo__road_sections' AND cm.source_column_name NOT IN (
            'road_section_id', 
            'road_segment_id', 
            'road_scheme_id', 
            'road_section_identifier', 
            'description', 
            'tollable_distance', 
            'charged_object_identifier',
            'alternative_identifier')
     OR tm.source_table_name='obo__road_segments' AND cm.source_column_name NOT IN (
            'road_segment_id', 
            'road_id', 
            'road_scheme_id', 
            'road_segment_identifier', 
            'description', 
            'tollable_distance', 
            'charged_object_identifier')
     OR tm.source_table_name='obo__roads' AND cm.source_column_name NOT IN (
            'road_id', 
            'road_scheme_id', 
            'road_identifier', 
            'description')
     OR tm.source_table_name='obo__scheme_compliance_category' AND cm.source_column_name NOT IN (
            'scheme_compliance_category_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__scheme_compliance_sub_category' AND cm.source_column_name NOT IN (
            'scheme_compliance_sub_category_id', 
            'scheme_compliance_category_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__scheme_liability_category' AND cm.source_column_name NOT IN (
            'scheme_liability_category_id', 
            'enum_name', 
            'description')
     OR tm.source_table_name='obo__topology_road_section_control_points' AND cm.source_column_name NOT IN (
            'toporscp_id', 
            'road_scheme_id', 
            'road_section_id', 
            'control_point_id',
            'distance_on_road_section',
            'distance_on_road_segment')
     OR tm.source_table_name='obo__topology_road_sections' AND cm.source_column_name NOT IN (
            'toporsec_id', 
            'road_scheme_id', 
            'road_section_id', 
            'from_section_id', 
            'to_section_id', 
            'alternative_routes_exist')
     OR tm.source_table_name='obo__topology_road_segments' AND cm.source_column_name NOT IN (
            'toporseg_id', 
            'road_scheme_id', 
            'road_segment_id', 
            'from_segment_id', 
            'to_segment_id', 
            'alternative_routes_exist')
--     OR tm.source_table_name='obo__XXXXXX' AND cm.source_column_name NOT IN (
--            'XXXXXX_id', 
--            'enum_name', 
--            'description')
--     OR tm.source_table_name='obo__' AND cm.source_column_name NOT IN (
--            '', 
--            '', 
--            '', 
--            '', 
--            '')
    );
--------------------------------------------------------------------------------

