#!/bin/bash

for t in database_url database_name targets; do
  if ! grep -q "^${t}=" /etc/pinger/pinger.conf; then
    logger "$0 Failed to get $t from config"
    exit 1
  fi
done

which fping > /dev/null || (logger "fping not found"; exit 1)

db_url=$(grep "^database_url=" /etc/pinger/pinger.conf | sed 's/^.*=//' | sed 's/ //g') # remove empty spaces
db_name=$(grep "^database_name=" /etc/pinger/pinger.conf | sed 's/^.*=//' | sed 's/[^A-Za-z0-9+\/]//g') # allowed just base64 chars
targets=$(grep "^targets=" /etc/pinger/pinger.conf | sed 's/^.*=//' | sed 's/\(,\|;\)/ /g')

sanitize_url() {
    sanitized_url=${1// /%20}
    echo "$sanitized_url"
}

sanitized_db_url=$(sanitize_url "$db_url")
# base64_db_name=$(echo $db_name | base64)

curl -i -XPOST "${sanitized_db_url}/query" --data-urlencode "q=CREATE DATABASE $db_name" 1>/dev/null 2>/dev/null

while true; do
  result=$(fping -C1 -q $targets 2>&1 | awk '{print "rtt,dst="$1" rtt="$3}')
  curl -i -XPOST "${db_url}/write?db=$db_name" --data-binary "$result"
 sleep 1
done
