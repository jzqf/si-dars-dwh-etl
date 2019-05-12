#!/bin/bash
#
# This is a wrapper script for executing whatever scripts are necessary for
# updating the databases that together form the "data warehouse".
#
# A wrapper script is used, rather than scheduling each wrapped script
# individually, so that these wrapped scripts cannot inadvertently be scheduled
# to run simultaneously. The script $DWH_HOME/bin/kitchen.sh, which is used to
# run each ETL shell script, implements a locking mechanism that allows only a
# single copy of the kitchen.sh script to run at a time. Using a wrapper
# script, as done here, prevents this from occurring.
#
# This script should be scheduled to run according to a sensible periodic
# schedule. Although any scheduler can be used for this purpose, the simplest is
# to used the built-in "cron" utility, which is provided by all flavors of
# Linux. For example, to run this script daily at 2 a.m., use the following
# entry in the "${app.user}" user's crontab:
#
# 0 2 * * * . $HOME/.profile; $DWH_HOME/bin/dwh-update.sh
#
# This script can also be run manually from a bash shell. Be sure that this is
# done under the "${app.user}" Linux account because this script expects certain
# environment variables to be defined appropriately, which will be done
# for you when logging into the "${app.user}" account.

# Include environment variables
source ${app.rootDir}/${app.user}/bin/${app.name}-env.sh

$DWH_HOME/bin/kitchen.sh /psa jb_psa-update Basic
$DWH_HOME/bin/kitchen.sh /dsa jb_dsa-update Basic
