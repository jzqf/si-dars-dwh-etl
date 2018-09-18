#!/bin/bash
#
# This script compares the content of tables in the Persistent Storage Area 
# (PSA) database with the content of tables in the OBO data base that are 
# mirrored to the PSA. 
#
# This script should be scheduled to run according to a sensible periodic
# schedule. Although any scheduler can be used for this purpose, the simplest is
# to used the built-in "cron" utility, which is provided by all flavors of 
# Linux. For example, to run this script daily at 2 a.m., use the following
# entry in the "${app.user}" user's crontab:
#
# 0 2 * * * . $HOME/.profile; $DWH_HOME/bin/psa-compare.sh
#
# This script can also be run manually from a bash shell. Be sure that this is
# done under the "${app.user}" Linux account because this script expects certain 
# environment variables to be defined appropriately, which will be done 
# for you when logging into the "${app.user}" account.
#
# Version history:
#
# Version:  1.0
# Updated:  2017.06.20
# Author:   Jeffrey Zelt
# Changes:  Initial version

# Include environment variables
source ${app.rootDir}/${app.user}/bin/${app.name}-env.sh

$DWH_HOME/bin/kitchen.sh /psa/jb_psa-compare.kjb Minimal
