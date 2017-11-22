#!/bin/bash

### Change paths according to your Dockerfile 'ADD' entries
SERVICE_NAME_LIST="state|lock|^cached-*"
TOR_DATA="/var/lib/tor"
TORRC="/etc/tor/torrc"

sed -i '/^HiddenServiceDir /d; /^HiddenServicePort /d' ${TORRC}

for i in $(env |grep '^TOR_SERVICE_')
do
 SERVICE_NAME="`echo $i | awk -F'=' '{print $1}' | sed 's/TOR_SERVICE_//g'`"
 echo "HiddenServiceDir ${TOR_DATA}/${SERVICE_NAME}/" >> ${TORRC}
 SERVICE_NAME_LIST+="|${SERVICE_NAME}"
 SERVICES="`echo $i | awk -F'name:' '{print $1}' | awk -F'=' '{print $2}' | sed 's/,/ /g' | sed 's/\"//g'`"
 for j in $SERVICES
 do
  echo "HiddenServicePort `echo $j | sed '0,/:/ s/:/ /'`" >> ${TORRC}
 done
done

# If persistent volume set, remove unused old SERVICE_NAME directories
cd ${TOR_DATA} && ls | egrep -v "${SERVICE_NAME_LIST}" | xargs rm -rf {}

bash /usr/local/bin/get-tor-hostnames ${TORRC} ${TOR_DATA} &

exec "$@"
