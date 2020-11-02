#!/bin/bash
#
# This is a wrapper script called frequently from CRON,
# that tries to make some semi-smart decisions about
# running the DWH ETL jobs. This script can be runs as follows:
#
#	sudo su -l -s /bin/bash dwh_etl
#	/opt/qfree/dwh_etl/bin/dwh-update.sh
#
#	or:
#
#	sudo su -l -s /bin/bash dwh_etl -c "/opt/qfree/dwh_etl/bin/dwh-update.sh"
#
#
# Ideally we whish the continuious running changes to the
# core app to land, but until then, we try a script based
# workaround.
#
# Goals:
#   * be able to be called by cron quite frequently
#   * be able to work out if already running, and not try and run if so
#   * Respect a timewindow in which not to try running (backup window)
#   * Respect trying not to start outside the window, with a run time that would
#     place our completion time in the window
#

# Include environment variables
source ${app.rootDir}/${app.user}/bin/${app.name}-env.sh

# Current time
current_time=$(date --utc --iso-8601=seconds)
current_time_epocsecs=$(date --date "${current_time}" +%s)

# Current Estimated Run Time is 1hr and 20 mins
estimated_executiontime_seconds=4800

# Calculated end time for a run if we ran now
estimated_finish_time=$(date --date "${current_time} +${estimated_executiontime_seconds} sec")
estimated_finish_time_epocsecs=$(date --date "${estimated_finish_time}" +%s)

# Defined window we should not execute in. Basically OBO & DWH Backup Window
no_run_window_start_time=$(date --date "00:10" --iso-8601=seconds)
no_run_window_start_time_epocsecs=$(date --date "${no_run_window_start_time}" +%s)

no_run_window_end_time=$(date --date "05:10" --iso-8601=seconds)
no_run_window_end_time_epocsecs=$(date --date "${no_run_window_end_time}" +%s)

# TEST: Are we currently Running ?
wrapped_scripts_lock_dir="/tmp/dars-qfree-etl.lock"

if [ -d $wrapped_scripts_lock_dir ];
then
    # Yes we are running. For How long have we been running and is it "odd" ?
    lockdir_create_time=$(date --reference="${wrapped_scripts_lock_dir}" --iso-8601=seconds)
    lockdir_create_time_epocsecs=$(date --date="${lockdir_create_time}" +%s)
    active_runtime_seconds=$(( $current_time_epocsecs - $lockdir_create_time_epocsecs ))

    debug_msg="ct(${current_time}) lct(${lockdir_create_time}) ars(${active_runtime_seconds}) ees(${estimated_executiontime_seconds})"

    # Is it unexpectedly long?
    if [ $active_runtime_seconds -gt $estimated_executiontime_seconds ];
    then
        
        debug_msg="CinX WARNING ${debug_msg}"
        # DEBUG echo "${debug_msg}"
        
        /usr/bin/logger -t dwh-update.sh "${debug_msg}"
        exit 0
        
    else
    
        debug_msg="CinX ${debug_msg}"
        # DEBUG echo "${debug_msg}"
        
        /usr/bin/logger -t dwh-update.sh "${debug_msg}"
        exit 0
        
    fi;

fi;

# Not Already Running, so Proceed to next tests

# TESTS for time :
#  (1) If starting now is in the no run window, dont run
#  (2) Else If starting now, our estimated end execution time, places us in no run window, dont run

# Boolean and a standard debug message
dont_run=0;
debug_msg="ct(${current_time}) eft(${estimated_finish_time}) nrw_st(${no_run_window_start_time}) nrw_et(${no_run_window_end_time})";

# Actual time compares
if [ $current_time_epocsecs -ge $no_run_window_start_time_epocsecs ] && [ $current_time_epocsecs -lt $no_run_window_end_time_epocsecs ];
then
    # Currently In Window
    debug_msg="CinW ${debug_msg}"
    dont_run=1;
elif [ $estimated_finish_time_epocsecs -ge $no_run_window_start_time_epocsecs ] && [ $estimated_finish_time_epocsecs -lt $no_run_window_end_time_epocsecs ];
then
    # Would Execute into window
    debug_msg="EinW ${debug_msg}"
    dont_run=1;
else
    # OK
    debug_msg="Ok   ${debug_msg}"
fi;

# Log some info
# DEBUG echo "${debug_msg}"
/usr/bin/logger -t dwh-update.sh "${debug_msg}"

if [ $dont_run -eq 1 ];
then
    exit 0
fi;

# Otherwise run as normal
$DWH_HOME/bin/kitchen.sh / jb_dwh-update Minimal # Minimal Basic Debug
