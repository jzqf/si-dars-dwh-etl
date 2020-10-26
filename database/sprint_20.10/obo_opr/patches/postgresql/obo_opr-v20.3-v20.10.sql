
-- Rename table dwh_etl_state_register to dwh_etl_state_register_source.
-- We do not rename the primary key column of this table.
--
-- Simple rename:
--ALTER TABLE IF EXISTS dwh_etl_state_register        RENAME TO dwh_etl_state_register_source;
--ALTER TABLE IF EXISTS dwh_etl_state_register_source RENAME CONSTRAINT PK_DWH_ETL_STATE_REGISTER TO PK_DWH_ETL_STATE_REGISTER_SRC;
--ALTER TABLE IF EXISTS dwh_etl_state_register_source RENAME CONSTRAINT AK_KEY_2_DWH_ETL_STATE    TO AK_KEY_2_DWH_ETL_STATE_SRC;
--
-- More complex rename:
SELECT COUNT(*)   AS "dwh_etl_state_register rows (before)" FROM public.dwh_etl_state_register;
SELECT last_value AS "dwh_etl_state_register_desr_id_seq (before)" FROM dwh_etl_state_register_desr_id_seq;
CREATE TABLE dwh_etl_state_register_source (
   desrs_id                                   BIGSERIAL            not null,
   schema_name                               VARCHAR(80)          not null,
   table_name                                VARCHAR(80)          not null,
   dwh_last_updated_insert_id_colname        VARCHAR(80)          null,
   dwh_last_updated_insert_id_maxvalue       BIGINT               null,
   dwh_last_updated_last_updated_on_colname  VARCHAR(80)          null,
   dwh_last_updated_last_updated_on_maxvalue TIMESTAMP            null,
   etl_job_id                                INTEGER              not null,
   CONSTRAINT PK_DWH_ETL_STATE_REGISTER_SRC PRIMARY KEY (desrs_id),
   CONSTRAINT AK_KEY_2_DWH_ETL_STATE_SRC UNIQUE (schema_name, table_name)
);
-- Special Per Table Permissions (Be Sure to Try and be SQL Standards compliant here!)
-- NOTE Sequence usage is needed, but granted in the DB level default permissions.
GRANT SELECT, INSERT, UPDATE, DELETE ON dwh_etl_state_register_source TO qfree_bi_rw_role;
INSERT INTO public.dwh_etl_state_register_source (
--  desrs_id,    <-- We do not specify this column so that the sequence associated with this column will get incremented.
   schema_name,
   table_name,
   dwh_last_updated_insert_id_colname,
   dwh_last_updated_insert_id_maxvalue,
   dwh_last_updated_last_updated_on_colname,
   dwh_last_updated_last_updated_on_maxvalue,
   etl_job_id
)
SELECT
--  desr_id,
   schema_name,
   table_name,
   dwh_last_updated_insert_id_colname,
   dwh_last_updated_insert_id_maxvalue,
   dwh_last_updated_last_updated_on_colname,
   dwh_last_updated_last_updated_on_maxvalue,
   etl_job_id
FROM
    public.dwh_etl_state_register;
SELECT COUNT(*) AS "dwh_etl_state_register_source rows (after)" FROM public.dwh_etl_state_register_source;
SELECT last_value AS "dwh_etl_state_register_source_desr_id_seq (after)" FROM dwh_etl_state_register_desr_id_seq;
DROP TABLE public.dwh_etl_state_register;  -- should only be executed if there were no errors above


-- Add table dwh_etl_state_register_target:
-- -----------------------------------------------------------------------------
CREATE TABLE dwh_etl_state_register_target (
   desrt_id                                   BIGSERIAL            not null,
   schema_name                               VARCHAR(80)          not null,
   table_name                                VARCHAR(80)          not null,
   dwh_last_updated_insert_id_colname        VARCHAR(80)          null,
   dwh_last_updated_insert_id_maxvalue       BIGINT               null,
   dwh_last_updated_last_updated_on_colname  VARCHAR(80)          null,
   dwh_last_updated_last_updated_on_maxvalue TIMESTAMP            null,
   etl_job_id                                INTEGER              not null,
   CONSTRAINT PK_DWH_ETL_STATE_REGISTER_TGT PRIMARY KEY (desrt_id),
   CONSTRAINT AK_KEY_2_DWH_ETL_STATE_TGT UNIQUE (schema_name, table_name)
);
-- Special Per Table Permissions (Be Sure to Try and be SQL Standards compliant here!)
-- NOTE Sequence usage is needed, but granted in the DB level default permissions.
GRANT SELECT, INSERT, UPDATE, DELETE ON dwh_etl_state_register_target TO qfree_bi_rw_role;
-- -----------------------------------------------------------------------------


-- This is so that the RDA "deleter" application does not delete any rows from 
-- these tables until they are loaded again the next time that the ETL job 
-- runs, or it is because tables have been removed from the PSA so that their
-- dwh_etl_state_register_source rows are no longer needed:

--DELETE FROM
--    dwh_etl_state_register_source
--WHERE
--    schema_name='public' AND 
--    table_name IN
--    (
--       'obo__svc_lvl_impact_domain',
--       'obo__svc_lvl_event_impact_register',
--       'obo__svc_lvl_event_register'
--    );
