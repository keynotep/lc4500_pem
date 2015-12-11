#!/bin/sh 
# Last Changed:  10-11-2015
#
# Startup script for LC4500 BBB software

### BEGIN INIT INFO
# Provides:          lc4500-pem.sh
# Required-Start:    $remote_fs cron
# Required-Stop:     $remote_fs
# Default-Start:     1 2 3 4 5
# Default-Stop:      0 6
# Short-Description: Start LC4500 application at boot time
# Description:       Enable services for interfacing the LC4500 driver board from BBB.
### END INIT INFO

set -e

PATH=/sbin:/bin:/usr/sbin:/usr/bin
test -x /usr/bin/lc4500_main || exit 0

. /lib/lsb/init-functions

case "$1" in
start|reload|force-reload|restart)

	# update firmware if file exists
	if test -f /var/tmp/ctemp; then
                echo "Updating LC4500-PEM application ..."
		cp /usr/bin/lc4500_main /var/tmp/lc4500_main.old
		cp /var/tmp/ctemp /usr/bin/lc4500_main
		rm -f /var/tmp/ctemp 
	fi
	if test -f /usr/bin/lc4500_main; then
		echo "LC4500-PEM application found and launching ..... "
                start-stop-daemon  -C -I real-time --start -m --pidfile /var/run/lc4500.pid --name lc4500 --exec /usr/bin/lc4500_main -b > /var/log/lc4500.log
		
	fi 

        ;;
stop)
       echo "Stopping LC4500-PEM service..."
       set +e
#      start-stop-daemon  --stop -s 15 --pidfile /var/run/lc4500.pid --name lc4500 --exec /usr/bin/lc4500_main
       kill -15 `cat /var/run/lc4500.pid`
       set -e

        exit 0
        ;;
*)
        echo "Usage: /etc/init.d/lc4500-pem.sh {start|stop|reload|restart|force-reload}"
        exit 1
        ;;
esac

exit 0
	echo "LC4500 Startup script completed."

