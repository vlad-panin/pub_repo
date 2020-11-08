#!/bin/bash
CATALINA_HOME=$(grep 'CATALINA_HOME' /home/tomcat/.bash_profile |  awk -F"'" '{print $2}')

SHUTDOWN_WAIT=10

tomcat_pid() {
    echo `ps aux | grep org.apache.catalina.startup.Bootstrap | grep -v grep | awk '{ print $2 }'`
}

start() {
    pid=$(tomcat_pid)
    if [ -n "$pid" ]
    then
        echo "Tomcat is already running (pid: $pid)"
    else
        # Start tomcat
        echo "Starting tomcat"
        cd $CATALINA_HOME/bin && $CATALINA_HOME/bin/startup.sh
    fi
    return 0
}

stop() {
    pid=$(tomcat_pid)
    if [ -n "$pid" ]
    then
        echo "Stopping Tomcat"
        cd $CATALINA_HOME/bin && $CATALINA_HOME/bin/shutdown.sh

    let kwait=$SHUTDOWN_WAIT
    count=0
    count_by=5
    until [ `ps -p $pid | grep -c $pid` = '0' ] || [ $count -gt $kwait ]
    do
        echo "Waiting for processes to exit. Timeout before we kill the pid: ${count}/${kwait}"
        sleep $count_by
        let count=$count+$count_by;
    done

    if [ $count -gt $kwait ]; then
        echo "Killing processes which didn't stop after $SHUTDOWN_WAIT seconds"
        kill -9 $pid
    fi
    else
        echo "Tomcat is not running"
    fi

    return 0
}

case $1 in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
       pid=$(tomcat_pid)
        if [ -n "$pid" ]
        then
           echo "Tomcat is running with pid: $pid"
        else
           echo "Tomcat is not running"
        fi
        ;;
esac

exit 0
