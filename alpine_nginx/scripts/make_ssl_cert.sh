#!/usr/bin/env sh
site='webdev.local'
out='default.pem'

openssl req \
   -x509 -nodes -days 365 -sha512 \
   -subj "/C=CH/ST=ZH/L=Zurich/CN=$site" \
   -newkey rsa:4096 -keyout $out -out $out
