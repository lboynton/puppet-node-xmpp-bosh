### BEGIN INIT INFO
# Provides:          bosh
# Required-Start:    $remote_fs $network $named $time
# Required-Stop:     $remote_fs $network $named $time
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Starts node-xmpp-bosh server
# Description:       Starts node-xmpp-bosh server, an XMPP
#                    BOSH server written in JavaScript.
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
NODE_PATH=/usr/lib/nodejs
BOSH=/usr/local/bin/start-bosh
NAME=run-server.js
PID_FILE=/var/run/bosh/bosh.pid

test -e $BOSH || exit 0

start()
{
    if ! pgrep -f $NAME
    then
        export NODE_PATH
    fi
    daemon --user=bosh --pidfile=$PID_FILE $BOSH
    return $?
}

stop()
{
    killproc -p $PID_FILE $BOSH
}

case "$1" in
    start)
        echo -n "Starting bosh server"
        start
    ;;
    stop)
        echo -n "Stopping bosh server"
        stop
    ;;
    restart)
        echo -n "Restarting bosh server"
        $0 stop
        $0 start
    ;;
    status)
        status -p $PID_FILE
    ;;
    *)
        echo "Usage: $0 {start|stop|status|restart}" >&2
        exit 1
    ;;
esac

if [ $? -eq 0 ]; then
    echo .
else
    echo " failed."
fi

exit 0
