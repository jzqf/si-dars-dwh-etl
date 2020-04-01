#!/bin/bash
#
# This script marks for deletion rows of tables in the OBO database that have 
# been archived/mirrored to the PSA database. If rows of the OBO table can be
# updated by the OBO application, the row will not be marked for deletion until
# it reaches a final state and the row has been updated in the PSA to reflect
# this final state. The PSA database is updated by the script:
#
#     psa-update.sh
#
# This script should be scheduled to run according to a sensible periodic
# schedule. Although any scheduler can be used for this purpose, the simplest is
# to used the built-in "cron" utility, which is provided by all flavors of 
# Linux. For example, to run this script daily at 2 a.m., use the following
# entry in the "${app.user}" user's crontab:
#
# 0 2 * * * . $HOME/.profile; $DWH_HOME/bin/psa-mark_rows_for_deletion.sh
#
# This script can also be run manually from a bash shell. Be sure that this is
# done under the "${app.user}" Linux account.
#
# Version history:
#
# Version:  1.0
# Updated:  2017.08.14
# Author:   Jeffrey Zelt
# Changes:  Initial version

# Include environment variables
source ${app.rootDir}/${app.user}/bin/${app.name}-env.sh

$DWH_HOME/bin/kitchen.sh /psa jb_psa-mark_rows_for_deletion
