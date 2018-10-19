-- This SQL script contains the appropriate DML that must be run on the 
-- "dars_dwh_etl_db" database *after* the default metatdata is generated by the 
-- PDI job:
--
--     /psa/jb_psa-populate_metadata_tables.kjb .
--
-- This file contains adjustment SQL commands only for tables associated with
-- the "core" tables in the PSA DB. If there are tables in the PSA DB that are
-- associated with other databases, the adjustment commands will be found in
-- other files in the same directory where this file is stored. All such 
-- adjustment scripts must be executed if the PDI job generates default metadata
-- for tables that original in all of these databases.
--
-- This SQL should be executed in a transaction in case syntax errors or any
-- other types of errors are introduced.


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

