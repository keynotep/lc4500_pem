#!/bin/bash
# Last update:  01/21/2016 
#
#    This script is designed to be ran on the BB from the directory where the install files are located.
# This means that the user has already pulled a copy of the install files (including this script)
# onto the BB either through git or some other means.  
#
#
#    Start with a clean Debian build. Debian Image 2015-07-28 was used from the following image:
#       BBB-eMMC-flasher-debian-7.8-ixde-4gb-armhf-2015-07-28-4gb.img
#
#    Load this install script and related files from git using the following command line (public):
#	git clone https://github.com/keynotep/lc4500_pem
#
#    This script requires superuser priveleges (default) for some operations.
#
#    When run, it will perform several "install" operations for the following components:
# - Links will be created for the startup script using update-rc.d command in /etc/init.d/
# - compile the cape manager overlays (DTS) into DTBO files and place them into the cape manager folder
# - update aptitude database and install various libraries required by the application
#
#
cur_dir=`pwd`

echo "Stopping current application"
sudo kill -15 `cat /var/run/lc4500.pid`

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
echo Check /etc/hostname to be sure the network name is correct:
newhostname="lc4500-pem"
echo "  Type the new network hostname you want to use or just enter to use default."
echo "  (you have 30 seconds or default will be automatically used): [lc4500-pem] "
read -t 30 newhostname
if [ $newhostname == "" ] ; then
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

echo "Building and installing new PEM application..."
cd $cur_dir
make clean
make all
sudo cp lc4500_main /usr/bin/.

#create solutions database directory
if [ -d /opt/lc4500pem ] ; then
    echo "Solution directory exists"
else
    echo "Creating Solution directory"
    sudo mkdir /opt/lc4500pem
fi

if [ -s /usr/bin/lc4500_main ] ; then
   echo "Installation Successfull. Rebooting ..."
   sleep 5
   reboot
else
   echo "Installation script failed!"
fi

