#!/bin/bash
#
# This is a wrapper script for:
#
#   dwh-compare_target_passage_related_tables.sh
#
# This script assumes that the passage related tables in the PSA will be 
# compared to their source tables in the "obo_opr" database; hence, this script
# does not include a parameter to specify the target database.
#
# This script can also be run manually from a bash shell. Be sure that this is
# done under the "${app.user}" Linux account. For example:
#
#   sudo su -l -s /bin/bash dwh_etl -c "/opt/qfree/dwh_etl/bin/psa-compare_passage_related_tables.sh '2020-01-01 00:00:00' '2020-02-01 00:00:00' Minimal"
#
# or:
#
#   sudo su -l -s /bin/bash dwh_etl
#   cd /opt/qfree/dwh_etl/bin/
#   ./psa-compare_passage_related_tables.sh '2020-01-01 00:00:00' '2020-02-01 00:00:00' Minimal"
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

# Check if the first argument exists. If so, it represents the "from" timestamp
# for selecting passage rows and passage-related rows to compare.
if [ ! -z "$1" ]; then
    passage_timestamp_from=$1
#else
#    echo "A \"from\" timestamp is required"
#    exit 1
fi

# Check if the second argument exists. If so, it represents the "to" timestamp
# for selecting passage rows and passage-related rows to compare.
if [ ! -z "$2" ]; then
    passage_timestamp_to=$2
#else
#    echo "A \"to\" timestamp is required"
#    exit 1
fi

# Check if the third argument exists. If so, it represents the PDI logging 
# level.
if [ ! -z "$3" ]; then
    log_level=$3
fi

# Set environment variables.
source ${app.rootDir}/${app.user}/bin/${app.name}-env.sh

# Start the PDI compare job.
$DWH_HOME/data-integration/kitchen.sh -rep=DWH -dir="/generic/target_compare" -job="jb_compare_target_passage_related_tables" -logfile=$DWH_LOGDIR/${app.name}.log -level=$log_level \
-param:PARAM_TARGET_DB_ID=$target_db_id \
-param:PARAM_PASSAGE_TIMESTAMP_FROM="$passage_timestamp_from" \
-param:PARAM_PASSAGE_TIMESTAMP_TO="$passage_timestamp_to"
