#!/bin/bash
#
# This is a wrapper script for executing whatever scripts are necessary for 
# comparing the "data warehouse" databases with their source databases.
#
# This script should be scheduled to run according to a sensible periodic
# schedule. Although any scheduler can be used for this purpose, the simplest is
# to used the built-in "cron" utility, which is provided by all flavors of 
# Linux. For example, to run this script daily at 2 a.m., use the following
# entry in the "${app.user}" user's crontab:
#
# 0 2 * * * . $HOME/.profile; $DWH_HOME/bin/dwh-compare.sh
#
# This script can also be run manually from a bash shell. Be sure that this is
# done under the "${app.user}" Linux account because this script expects certain 
# environment variables to be defined appropriately, which will be done 
# for you when logging into the "${app.user}" account.
#
# Version history:
#
# Version:  1.0
# Updated:  2018.05.15
# Author:   Jeffrey Zelt
# Changes:  Initial version

# Check if the first arguments exists. If so, it represents the maximum number 
# of rows to compare per table.
max_num_compare_rows=0    # Compare *all rows of each table
if [ ! -z "$1" ]; then
    # TODO: I should also check that $1 contains an integer value.
    max_num_compare_rows=$1
    echo "A maximum number of $max_num_compare_rows rows will be compared per table"
fi

/opt/qfree/dwh_etl/data-integration/kitchen.sh -file="$DWH_HOME/pdi_repository/psa/jb_psa-compare.kjb" -rep=DWH -logfile=$DWH_LOGDIR/dwh-etl.log -level=Minimal -param:PARAM_MAX_NUM_COMPARE_ROWS=$max_num_compare_rows
/opt/qfree/dwh_etl/data-integration/kitchen.sh -file="$DWH_HOME/pdi_repository/dsa/jb_dsa-compare.kjb" -rep=DWH -logfile=$DWH_LOGDIR/dwh-etl.log -level=Minimal -param:PARAM_MAX_NUM_COMPARE_ROWS=$max_num_compare_rows
