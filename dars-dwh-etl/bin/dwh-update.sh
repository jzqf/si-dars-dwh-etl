#!/bin/bash
#
# This script updates the TDP data warehouse (DWH). 
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
#
# Version history:
#
# Version:  1.0
# Updated:  2017.05.29
# Author:   Jeffrey Zelt
# Changes:  Initial version

$DWH_HOME/bin/kitchen.sh /dwh_tdp/jb_dwh-update.kjb
