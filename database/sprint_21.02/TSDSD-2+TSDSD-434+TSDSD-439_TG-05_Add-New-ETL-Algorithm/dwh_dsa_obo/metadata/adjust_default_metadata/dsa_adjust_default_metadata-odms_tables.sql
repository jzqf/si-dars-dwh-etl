-- This SQL script contains the appropriate DML that must be run on the 
-- "etl_mgmt" database *after* the default metatdata is generated by the 
-- PDI job:
--
--     /dsa/jb_dsa-repopulate_metadata_tables.kjb .
--
-- This file contains adjustment SQL commands only for tables associated with
-- the "odms" tables in the DSA DB. If there are tables in the DSA DB that are
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
-- Target table: 
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Specify target column names that are not the same as the source column name:
--
-- If incorrect details are specified here, they will probably be caught when 
-- the ETL code runs because errors will be triggered if the column names are
-- wrong.
--
-- Source table: 
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Specify columns of source tables to *not* mirror and *not* compare:
--------------------------------------------------------------------------------

