#!/bin/bash
# Last update:  11/30/2015 
#
#    This script is designed to be ran on the BB from the directory where the install files are located.
# This means that the user has already pulled a copy of the install files (including this script)
# onto the BB either through git or some other means.  
#
#
#    This script requires superuser priveleges (default) for some operations.
#
#    It should be ran on a clean Debian build (Debian Image 2015-03-01 was used originally). 
#
#    When run, it will perform several "install" operations for the following components:
# - Links will be created for the startup script using update-rc.d command in /etc/init.d/lc4500_startup.sh
# - compile the cape manager overlays (DTS) into DTBO files and place them into the cape manager folder
# - update apt-get and install various libraries required by the application
#
#
cur_dir=`pwd`

echo ========= Installing Startup Script and app ==========
# Now fix startup sequence
echo "Updating Boot-up scripts...."
cd /etc/init.d
# remove old startup scripts so we can rearrange them
sudo update-rc.d apache2 remove
sudo update-rc.d xrdp remove
# copy new versions with new priorities
cp $cur_dir/StartupScripts/cron .
cp $cur_dir/StartupScripts/dbus .
cp $cur_dir/StartupScripts/rsync .
cp $cur_dir/StartupScripts/udhcpd .
cp $cur_dir/StartupScripts/lc4500-pem.sh .
sudo update-rc.d lc4500-pem.sh start 10 1 2 3 4 5 . stop 0 0 6 .

echo ========= Installing Device Tree Overlays  =============
echo "Updating Device Tree Overlay files...."
cd /lib/firmware
sudo cp $cur_dir/BB-BONE-LC4500-00A0.dts .
# compile device tree overlay functions (SPI, HDMI etc.)
dtc -O dtb -o BB-BONE-LC4500-00A0.dtbo -b 0 -@ BB-BONE-LC4500-00A0.dts
echo ============= Updating the Cape Manager ================
cd /etc/default
cp $cur_dir/capemgr .

echo ============= Check uEnv.txt boot parameters ================
echo "Updating uEnv.txt file. Previous version saved in /boot/uEnv.old.txt"
cd $cur_dir
cp /boot/uEnv.txt /boot/uEnv.old.txt
cp /boot/uEnv.txt ./uEnv.old
if [ -s uEnv.old ]; then
  echo "Using saved uEnv file"
  cat uEnv.old | sed  '/cmdline/s/quiet/quiet text/g' |  sed  '/BB-BONELT-HDMI,BB-BONELT-HDMIN/s/#cape_disable/cape_disable/g' | sed '/BB-BONE-EMMC-2G/s/cape_disable/#cape_disable/g' | awk '/uname/{print "optargs=\"consoleblank=0\""}1' > /boot/uEnv.txt
else
  cat /boot/uEnv.txt  | sed  '/cmdline/s/quiet/quiet text/g' |  sed  '/BB-BONELT-HDMI,BB-BONELT-HDMIN/s/#cape_disable/cape_disable/g' | sed '/BB-BONE-EMMC-2G/s/cape_disable/#cape_disable/g' | awk '/uname/{print "optargs=\"consoleblank=0\""}1' > /boot/uEnv.txt
fi

echo ============= Check Network config ================
#echo Check /etc/network/interfaces to be sure the IP address is correct for this board
echo Check /etc/hostname to be sure the network name is correct:
echo "Type the new network hostname you want to use [you have 30 seconds or default will be automatically used]:"

newhostname="lc4500-pem"
read -t 30 newhostname
if [ $newhostname == ""] ; then
   echo "Default network ID used: lc4500-pem. Be careful if you have multiple units on your network!"
   sudo echo "lc4500-pem" > /etc/hostname
else
   echo "OK, changing network ID to:" $newhostname
   sudo echo $newhostname > /etc/hostname
fi

echo "Updating Debitian libraries..."
sudo apt-get update
sudo apt-get install libdrm2
sudo apt-get install libudev-dev
sudo apt-get install libdrm-dev

echo "Building PEM application..."
cd $cur_dir
#Need to add xf86drm.h and other headers to system path to build locally
cp headers/*.h /usr/include

# Build application
cd objs 
make
if [ -s /etc/init.d/lc45000-pem.sh ] ; then
   echo "Stopping exisitng PEM application..."
   sudo service lc4500-pem.sh stop
   echo "done. Copying new build"
fi

sudo cp lc4500_main /usr/bin
if [ -d /opt/lc4500pem ] ; then
    echo "Solution directory exits"
else
    sudo mkdir /opt/lc4500pem
fi

if [ -s /usr/bin/lc4500_main ] ; then
   echo "Installation Successfull. Rebooting ..."
   reboot
else
   echo "Installation script failed!"
fi
