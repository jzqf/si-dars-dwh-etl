
PLACE ALL SQL CPODE BELOW IN A SEPARATE SCRIPT. IF IT IS NECESSARY, CHECK IT
ALSO IN WHEN i CREATE THE "SCRATCHPAD" JIRA. I.E., BJØRN TORE WILL MERGE IN 
*TWO* SCRIPTS:

	upgrade-schema-dars-etl_mgmt-postgresql.sql
	kyms-QFC-BODARS-3296_etl-cdc-extension-not-merged.sql

Develop and test this SQL after I have finished everything for supporting Kym's
feature branch.
	
--Can I treat this by:
--
--1.	Commenting out patch code that drops and re-creates the 3 tables that have
--	the "cdc_timestamp" columns. This will not be necessary; if it is not
--	commented out, the next run of the ETL job to take a very long time to run.
--
--	Note that the "cdc_timestamp" columns will remain in my local copies of the
--	PSA & DSA DBs, but since I comment out the patch code for these columns, 
--	they will not get created in any copies of the PSA & DSA DBs upgrade by 
--	Bjørn Tore.
--
--	The ETL metadata for these "cdc_timestamp" columns will still be in my local
--	copy of the etl_:mgmt database.
--	
--2.	Write SQL to update column metadata rows so that:
--
--	a1.	The "cdc_timestamp" columns are not mirrored or compared. Write and run 
--		code to set:
--
--			mirror_column=false, 
--			compare_column=false 
--
--		for the 3 "cdc_timestamp" columns for both databases:
--
--		*	dwh_psa_obo
--		*	dwh_dsa_obo
--
--		This means that the etl.colum_meta rows that I have generated for the
--		3 "cdc_timestamp" columns for both databases will be ignored by all ETL
--		jobs so that no errors will occur due to the fact that the new  
--		"cdc_timestamp" columns are not present in either the source or the 
--		target columns.
--
--		Add this SQL code to the end of the scripts:
--	
--			create-schema-dars-etl_mgmt-postgresql.sql
--			upgrade-schema-dars-etl_mgmt-postgresql.sql ,
--
--		but comment it out for now?
--
--	a2.	The tables that have the "cdc_timestamp" columns should be treated with 
--		ETL algorithm #1 (not 6). This is necessary because the "cdc_timestamp" 
--		columns are defined to be the "last updated on" columns for these tables.
--
--	b.	Write and execute SQL so that the *source* column name for the 
--		"svc_lvl_event_register" table in the svc_lvl_event_register table is:
--
--			registered_by_suid
--	
--		not:
--	
--			registered_by_sid .
--
--		"registered_by_suid" is the old, incorrectly spelled name for this column
--		that my patch code corrects to "registered_by_sid" because Kym did that in
--		his feature branch. But double check that this change really does not 
--		make it into the new release - Kym may merge this one small change into 
--		the 19.3 release. This change is currently in Kym's feature branch, but 
--		it is not in dars-pdm-obo-opr-1.13.2-database.zip.
--
--		If this fix is necessary because it did not make it into the new obo_opr
--		database, only the metadata for the PSA needs to be "fixed". Te metadata
--		for the DSA should be OK, right, because I do not revert the name of this
--		column in either the PSA or DSA?
--	
--		It might be possible to place this SQL in the appropriate "adjustment"
--		SQL script(s), but I need to be sure that it is removed for the next 
--		release, so think carefully before doing this.
--
--3.	Delete the SQL for creating the indexes for the following columns:
--
--		obo__passage_event_dsrc_data (cdc_timestamp)
--		obo__passage_event_vehicle_data (cdc_timestamp)
--		obo__passage_events (cdc_timestamp)
--		
--
--	of the two databases:
--
--	*	dwh_psa_obo
--	*	dwh_dsa_obo
--
--4.	Reverse the changes I made to the .pdm documents where I added the columns:
--
--		obo__passage_event_dsrc_data (cdc_timestamp)
--		obo__passage_event_vehicle_data (cdc_timestamp)
--		obo__passage_events (cdc_timestamp)
--
--	for the two databases:
--
--	*	dwh_psa_obo
--	*	dwh_dsa_obo

Perhaps I can treat some of the above by working with two separate git branches for the "si-dars-pdm-dwh" git project.

*	19.3-without-kyms-feature-branch	<- create first and perform changes here. Then commit and create the next feature branch (not using git flow)
*	19.3-with-kyms-feature-branch
