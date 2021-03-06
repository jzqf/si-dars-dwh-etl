#!/bin/bash
#
# This runs a job from the PDI repository for this project.
#
# Prerequisites:
#
# The following environment variables should exist when this script executes.
# These should be defined automatically for you when you log into the "${app.user}"
# account. If you want to use different a value here for one of these variables,
# uncomment the the corresponding line below, but be sure to give the variable a
# sensible value - the values displayed here may not be valid in your
# environment.
#
#export DWH_HOME=/opt/qfree/${app.user}
#export DWH_LOGDIR=$DWH_HOME/logs
#export KETTLE_HOME=$DWH_HOME/pdi_config
#
# Version history:
#
# Version:  1.0
# Updated:  2017.05.29
# Author:   Jeffrey Zelt
# Changes:  Initial version

IFS='
'  # explicitly set IFS for security reasons (space, tab, newline)

# PATH will be set, if necessary, in ~${app.user}/.profile
#
#export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

PROGRAM=$(basename $0)
VERSION=1.0
#USAGE="$PROGRAM [OPTIONS] JOB"  <- I plan to add options for this script
USAGE="$PROGRAM JOB"

# Lock directory to ensure only one copy of a DWH script is running at any time.
# Currently, each DARS ETL project should use this same lock directory so that
# no two script from *any* ETL project will run concurrently.
LOCK_DIR="/tmp/dars-qfree-etl.lock"

PDI_REPOSITORY=$DWH_HOME/pdi_repository
JOB_DIR=$PDI_REPOSITORY
LOG_FILE=$DWH_LOGDIR/${app.name}.log

log_error()
{
	printf "$(date +%Y/%m/%d\ %H:%M:%S) - ERROR - $PROGRAM: $*\n" | tee -a "$LOG_FILE" 1>&2  # send msg to both stderr and log file
	usage_and_exit 1
}

log_warning()
{
	printf "$(date +%Y/%m/%d\ %H:%M:%S) - WARN  - $PROGRAM: $*\n" | tee -a "$LOG_FILE" 1>&2  # send msg to both stderr and log file
}

log_info()
{
	printf "$(date +%Y/%m/%d\ %H:%M:%S) - INFO  - $PROGRAM: $*\n" | tee -a "$LOG_FILE" 1>&2  # send msg to both stderr and log file
}

usage_and_exit()
{
	usage
	exit $1
}

usage()
{
	printf "Usage: $USAGE\n"
    #  (Use option -h for help)\n"
}

# Check that a job was specified by the first argument and that it exists.
if [ ! -z "$1" ]; then
    if [ ! -f "$JOB_DIR/$1" ]; then
        log_error "The specified job '$1' does not exist"
    fi
else
    log_error "No job specified"
fi

# The logging level can optionally be passed as the second argument.
LOG_LEVEL=Basic    # default if no logging level specified
if [ -n "$2" ]; then
    LOG_LEVEL=$2
fi

# Remove the lock directory.
#
# Since testing indicates that this function is called multiple times when the
# process is terminated with Control-C, we do not report an error if the lock
# directory does not exist (it may have been deleted on an earlier invocation of
# this function - does this mean that this process actually receives multiple
# signals in sequence?). Neither do we report the "Finished" message because it
#should have been reported on the first invocation when the directory was
# removed.
function cleanup {
	if [ -d $LOCK_DIR ]; then
        if rmdir $LOCK_DIR; then
            log_info "Finished. Lock '$LOCK_DIR' removed."
        else
            log_error "Failed to remove lock directory '$LOCK_DIR'"
        fi
    fi
}

if mkdir "${LOCK_DIR}" &>/dev/null; then

    log_info "Acquired lock, running..."

    # Ensure that the lock directory gets removed.
    #
    # This will be done for:
    #
    # signal = EXIT:    Normal exit
    # signal = SIGHUP:  Hang up detected on controlling terminal or death of controlling process
    # signal = SIGINT:  Issued if the user sends an interrupt signal (Ctrl + C)
    # signal = SIGQUIT: Issued if the user sends a quit signal (Ctrl + D)
    # signal = SIGTERM: Software termination signal (sent by kill by default)
    # signal = ERR:     The command exits with a non-zero status
    trap "cleanup" EXIT SIGHUP SIGINT SIGQUIT SIGTERM ERR

    # Use the PDI Kitchen utility to execute the job:
    /usr/share/pentaho/pdi/pdi-default/kitchen.sh -file="$JOB_DIR/$1" \
        -rep=DWH -logfile=$LOG_FILE -level=$LOG_LEVEL

else
    log_error "Could not create lock directory '$LOCK_DIR'"
fi

exit 0
