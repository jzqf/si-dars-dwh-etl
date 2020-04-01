#!/bin/bash
#
# This shell script executes the PDI job to compare the content of a single 
# table in a target database to its matching table in a source database. "From"
# and "to" values for the "insert id" column must be specified to limit the 
# compare to a specific block of database rows.
#
# This script can also be run manually from a bash shell. Be sure that this is
# done under the "${app.user}" Linux account. For example:
#
#   sudo su -l -s /bin/bash dwh_etl -c "/opt/qfree/dwh_etl/bin/dwh-compare_target_table.sh 10 public obo__passage_events 10250184 102400560 Basic"
#
# or:
#
#   sudo su -l -s /bin/bash dwh_etl
#   cd /opt/qfree/dwh_etl/bin/
#   ./dwh-compare_target_table.sh 10 public obo__passage_events 10250184 102400560 Basic
#
# Version history:
#
# Version:  1.0
# Updated:  2020.03.10
# Author:   Jeffrey Zelt
# Changes:  Initial version

# Default argument values.
target_db_id=0
target_schema_name=
target_table_name=
insert_id_from=-1
insert_id_to=-1
log_level=Minimal

# Check if the first argument exists. If so, it represents the id of the target
# database that contains the specified table to compare with its corresponding
# source table.
if [ ! -z "$1" ]; then
    target_db_id=$1
else
    echo "A target database id is required"
    exit 1
fi

# Check if the second argument exists. If so, it represents the name of the 
# schema containing the target table to compare with its corresponding source 
# table.
if [ ! -z "$2" ]; then
    target_schema_name=$2
else
    echo "A target schema is required"
    exit 1
fi

# Check if the third argument exists. If so, it represents the name of the 
# target table to compare with its corresponding source table.
if [ ! -z "$3" ]; then
    target_table_name=$3
else
    echo "A target table is required"
    exit 1
fi

# Check if the fourth argument exists. If so, it represents the starting value 
# (lower bound) of the "insert id" for the block of rows to compare.
if [ ! -z "$4" ]; then
    insert_id_from=$4
else
    echo "insert_id_from is required"
    exit 1
fi

# Check if the fifth argument exists. If so, it represents the ending value 
# (upper bound) of the "insert id" for the block of rows to compare.
if [ ! -z "$5" ]; then
    insert_id_to=$5
else
    echo "insert_id_to is required"
    exit 1
fi

# Check if the sixth argument exists. If so, it represents the PDI logging 
# level.
if [ ! -z "$6" ]; then
    log_level=$6
fi

# Set environment variables.
source ${app.rootDir}/${app.user}/bin/${app.name}-env.sh

# Start the PDI compare job.
$DWH_HOME/data-integration/kitchen.sh -rep=DWH -dir="/generic/target_compare" -job="jb_compare_target_table" -logfile=$DWH_LOGDIR/${app.name}.log -level=$log_level \
-param:PARAM_TARGET_DB_ID=$target_db_id \
-param:PARAM_TARGET_SCHEMA=$target_schema_name \
-param:PARAM_TARGET_TABLE=$target_table_name \
-param:PARAM_INSERT_ID_FROM=$insert_id_from \
-param:PARAM_INSERT_ID_TO=$insert_id_to
