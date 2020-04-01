#!/bin/bash
#
# This shell script executes the PDI job to compare the content of a selection 
# og passage-related tables in a specified target database to their matching 
# tables in one or more source databases. The block passages to compare are 
# specified with "from" and "to" timestamps. Rows of passage-related tables to 
# are specified by performing one or more SQL JOIN operations with the passages
# that are selected by the specified timestamps.
#
# This script can also be run manually from a bash shell. Be sure that this is
# done under the "${app.user}" Linux account. For example:
#
#   sudo su -l -s /bin/bash dwh_etl -c "/opt/qfree/dwh_etl/bin/dwh-compare_target_passage_related_tables.sh 10 '2020-01-01 00:00:00' '2020-02-01 00:00:00' Minimal"
#
# or:
#
#   sudo su -l -s /bin/bash dwh_etl
#   cd /opt/qfree/dwh_etl/bin/
#   ./dwh-compare_target_passage_related_tables.sh 10 '2020-01-01 00:00:00' '2020-02-01 00:00:00' Minimal
#
# Version history:
#
# Version:  1.0
# Updated:  2020.03.13
# Author:   Jeffrey Zelt
# Changes:  Initial version

# Default argument values.
target_db_id=10
passage_timestamp_from='2020-01-01 00:00:00'
passage_timestamp_to='2020-01-02 00:00:00'
log_level=Minimal

# Check if the first argument exists. If so, it represents the id of the target
# database that contains the passage-related tables to compare with their
# corresponding tablein a source database.
if [ ! -z "$1" ]; then
    target_db_id=$1
#else
#    echo "A target database id is required"
#    exit 1
fi

# Check if the second argument exists. If so, it represents the "from" timestamp
# for selecting passage rows and passage-related rows to compare.
if [ ! -z "$2" ]; then
    passage_timestamp_from=$2
#else
#    echo "A \"from\" timestamp is required"
#    exit 1
fi

# Check if the third argument exists. If so, it represents the "to" timestamp
# for selecting passage rows and passage-related rows to compare.
if [ ! -z "$3" ]; then
    passage_timestamp_to=$3
#else
#    echo "A \"to\" timestamp is required"
#    exit 1
fi

# Check if the fourth argument exists. If so, it represents the PDI logging 
# level.
if [ ! -z "$4" ]; then
    log_level=$4
fi

# Set environment variables.
source ${app.rootDir}/${app.user}/bin/${app.name}-env.sh

# Start the PDI compare job.
$DWH_HOME/data-integration/kitchen.sh -rep=DWH -dir="/generic/target_compare" -job="jb_compare_target_passage_related_tables" -logfile=$DWH_LOGDIR/${app.name}.log -level=$log_level \
-param:PARAM_TARGET_DB_ID=$target_db_id \
-param:PARAM_PASSAGE_TIMESTAMP_FROM="$passage_timestamp_from" \
-param:PARAM_PASSAGE_TIMESTAMP_TO="$passage_timestamp_to"
