#!/bin/bash

for t in database_url database_name targets; do
  if ! grep -q "^${t}=" /etc/pinger/pinger.conf; then
    logger "$0 Failed to get $t from config"
    exit 1
  fi
done

which fping > /dev/null || (logger "fping not found"; exit 1)

db_url=$(grep "^database_url=" /etc/pinger/pinger.conf | sed 's/^.*=//')
db_name=$(grep "^database_name=" /etc/pinger/pinger.conf | sed 's/^.*=//')
targets=$(grep "^targets=" /etc/pinger/pinger.conf | sed 's/^.*=//' | sed 's/\(,\|;\)/ /g')

encoded_db_url=$(printf %s "$db_url" | jq -s -R -r @uri)
encoded_db_name=$(printf %s "$db_name" | jq -s -R -r @uri)
encoded_targets=$(printf %s "$targets" | jq -s -R -r @uri)

curl -i -XPOST "${encoded_db_url}/query" --data-urlencode "q=CREATE DATABASE $encoded_db_name" 1>/dev/null 2>/dev/null

while true; do
  result=$(fping -C1 -q $targets 2>&1 | awk '{print "rtt,dst="$1" rtt="$3}')
  curl -i -XPOST "${encoded_db_url}/write?db=$encoded_db_name" --data-binary "$result" 1>/dev/null 2>/dev/null
 sleep 1
done
