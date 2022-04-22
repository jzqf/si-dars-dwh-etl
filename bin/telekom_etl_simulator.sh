#!/bin/bash

# telekom_etl_simulator.sh:
#
# Check that the Linux username is correct. This script is expected to be run as 
# user "postgres" so that no PostgreSQL password is required (which would be
# environment-specific).
#
# To execute this script manually on the DSA server, use:
#
#     sudo -iu postgres /opt/qfree/bin/telekom_etl_simulator.sh dwh_dsa_obo
#
# This script contains code written by KymF for the script:
#
#     /opt/qfree/dwh_etl/bin/dwh-update.sh
#
# that implements a "quiet period" to avoid running SQL queries on the target 
# database while pg_dump may be running to backup the database. This is done to
# avoid the potential for database locks that could block the backup by pg_dump.
#
# Date:   2021.09.30
# Author: Jeffrey Zelt

PATH=/opt/qfree/bin:/usr/local/bin:/usr/bin:/bin

if [ "$(whoami)" != "postgres" ]; then
    echo "Script must be run as user: postgres"
    exit -1
fi

DATABASE=$1

# Check input parameter for DATABASE.
if [[ -z "$DATABASE" ]]; then
    echo "Script must have database name as argument"
    echo "  Example:  sudo -iu postgres /opt/qfree/bin/telekom_etl_simulator.sh dwh_dsa_obo"
    exit -2
fi

# Current time
current_time=$(date --utc --iso-8601=seconds)
current_time_epocsecs=$(date --date "${current_time}" +%s)

# Defined window we should not execute in. Basically OBO & DWH Backup Window
# We define a window whose span is expected to be fully "within the current day", e.g. 00:10-06:10
midnight_today_epocsecs=$(date --date "${midnight_today}" +%s)

no_run_window_start_time=$(date --date "00:10" --iso-8601=seconds)
no_run_window_start_time_epocsecs=$(date --date "${no_run_window_start_time}" +%s)

no_run_window_end_time=$(date --date "06:10" --iso-8601=seconds)
no_run_window_end_time_epocsecs=$(date --date "${no_run_window_end_time}" +%s)

# Boolean
dont_run=0;

debug_msg="ct(${current_time})) nrw_st(${no_run_window_start_time}) nrw_et(${no_run_window_end_time})";

# Actual time compares
if [ $current_time_epocsecs -ge $no_run_window_start_time_epocsecs ] && [ $current_time_epocsecs -lt $no_run_window_end_time_epocsecs ];
then
    # Currently In Window
    debug_msg="CinW ${debug_msg}"
    dont_run=1;
else
    # OK
    debug_msg="Ok   ${debug_msg}"
fi;

# Log some info
# DEBUG echo "${debug_msg}"
/usr/bin/logger -t telekom_etl_simulator.sh "${debug_msg}"

if [ $dont_run -eq 1 ];
then
    exit 0
fi;

# Otherwise run as normal.
#
# If you want to echo the content of the SQL script to the log, 
# use the option:  --echo-queries
psql --echo-all --echo-errors --set ON_ERROR_STOP=on --set AUTOCOMMIT=on --set ON_ERROR_ROLLBACK=on -d $DATABASE -f "/opt/qfree/bin/telekom_etl_simulator.sql"

