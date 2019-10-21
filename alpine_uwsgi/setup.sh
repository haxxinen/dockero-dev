#!/usr/bin/env sh

apk --update --no-cache add \
uwsgi-python3 python3 \
python3-dev py3-virtualenv

python3 -m ensurepip
pip3 install --upgrade pip setuptools && rm -r /root/.cache

mkdir -p ${DIR_WEBROOT}
