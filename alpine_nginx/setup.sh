#!/usr/bin/env sh

helpers=" make g++ wget curl"

apk --update --no-cache add openssl-dev pcre-dev \
zlib-dev supervisor shadow `echo "$helpers"` && \
sh /tmp/nginx_installer.sh && apk del `echo "$helpers"`
rm /tmp/nginx_installer.sh

adduser -D -s /sbin/nologin -h /dev/null -g nginx nginx
