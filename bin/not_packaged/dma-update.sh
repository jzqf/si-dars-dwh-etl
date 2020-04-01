#!/bin/bash
#
# This script updates the tables in the data mart that is maintained by this
# project.
#
# This script should be scheduled to run according to a sensible periodic
# schedule. Although any scheduler can be used for this purpose, the simplest is
# to used the built-in "cron" utility, which is provided by all flavors of 
# Linux. For example, to run this script daily at 2 a.m., use the following
# entry in the "${app.user}" Linux account's crontab:
#
# 0 2 * * * . $HOME/.profile; $DWH_HOME/bin/dma-update.sh
#
# This script can also be run manually from a bash shell. Be sure that this is
# done under the "${app.user}" Linux account.
#
# Version history:
#
# Version:  1.0
# Updated:  2017.05.29
# Author:   Jeffrey Zelt
# Changes:  Initial version

# Include environment variables
source ${app.rootDir}/${app.user}/bin/${app.name}-env.sh

$DWH_HOME/bin/kitchen.sh /data_mart jb_dma-update
