#!/bin/bash
# Last update:  11/20/2015 (AJK)
#
#    This script requires superuser priveleges (default) for some operations.
#
#
cur_dir=`pwd`

echo ========= Updating Startup Script and app ==========
# Now fix startup sequence
echo "Updating Boot-up scripts...."
cd /etc/init.d
# remove old startup scripts so we can rearrange them
sudo update-rc.d xrdp defaults
#sudo update-rc.d lc4500_startup.sh defaults

