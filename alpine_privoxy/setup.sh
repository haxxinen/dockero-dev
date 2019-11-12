#!/usr/bin/env sh

apk --update --no-cache add privoxy supervisor

lines=`grep -n '^listen-address' /etc/privoxy/config | awk -F ':' '{print $1}'`
for i in $lines; do sed -i $i's/^/#/' /etc/privoxy/config; done
echo 'listen-address  0.0.0.0:8118' >> /etc/privoxy/config

