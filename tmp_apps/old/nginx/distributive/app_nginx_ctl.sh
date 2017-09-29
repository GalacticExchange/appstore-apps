#!/bin/sh
### BEGIN INIT INFO
# Provides: app_nginx_ctl
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

#deamon=/usr/lib/gex/nca/gexd.jar
#[ -x "$deamon" ] || exit 0

cmd="/usr/lib/gex/java/bin/java -jar /usr/lib/gex/nca/gexd.jar"
#user="gexuser"

#name=`basename $0`
#pid_file="/var/run/$name.pid"
#stdout_log="/var/log/$name.log"
#stderr_log="/var/log/$name.err"

#get_pid() {
#    cat "$pid_file"
#}

start_container(){
    docker run --name=gex-app-nginx -d --privileged=true -p 9080:80 app-nginx ""
}


case "$1" in
    start)
   echo "starting"
   start_container
    ;;
    stop)
  echo "stop"
;;
    restart)
     echo "restart"
    ;;
    status)
     echo "status"
    ;;
*)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
