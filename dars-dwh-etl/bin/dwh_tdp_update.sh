#!/bin/bash
#
# This script updates the TDP data warehouse (DWH). 
#
# This script should be scheduled to run according to a sensible periodic
# schedule. Although any scheduler can be used for this purpose, the simplest is
# to used the built-in "cron" utility, which is provided by all flavors of 
# Linux. For example, to run this script daily at 2 a.m., use the following
# entry in the "etl" user's crontab:
#
# 0 2 * * * . $HOME/.profile; $DWH_HOME/scripts/dwh_tdp_update.sh
#
# This script can also be run manually from a bash shell. Be sure that this is
# done as the "etl" Linux user because this script expects certain environment
# variables to be defined appropriately, which will be done automatically for 
# you when logging into the "etl" account.
#
# Version history:
#
# Version:  1.0
# Updated:  2016.04.12
# Author:   Jeffrey Zelt
# Changes:  Initial version
#
# Version:  1.1
# Updated:  2016.07.05
# Author:   Jeffrey Zelt
# Changes:  jb_dwh_tdp_update.kjb now also updates TDP data mart

$DWH_HOME/scripts/dwh_tdp_kitchen.sh /dwh_tdp/jb_dwh_tdp_update.kjb
