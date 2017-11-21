#!/bin/bash

### Change paths according to your Dockerfile 'ADD' entries
TORRC="/etc/torrc"
TOR_DATA="/var/lib/tor"

for i in $(env |grep '^TOR_SERVICE_')
do
 SERVICE_NAME="`echo $i | awk -F'=' '{print $1}' | sed 's/TOR_SERVICE_//g'`"
 echo "HiddenServiceDir ${TOR_DATA}/${SERVICE_NAME}/" >> ${TORRC}

 SERVICES="`echo $i | awk -F'name:' '{print $1}' | awk -F'=' '{print $2}' | sed 's/,/ /g' | sed 's/\"//g'`"
 for j in $SERVICES
 do
  echo "HiddenServicePort `echo $j | sed '0,/:/ s/:/ /'`" >> ${TORRC}
 done
done

bash /usr/local/bin/get-tor-hostnames ${TORRC} ${TOR_DATA} &

exec "$@"
