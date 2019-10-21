#!/usr/bin/env sh

cd ${DIR_WEBROOT}
[ ! -e '.venv' ] && virtualenv --python=python3 .venv

. .venv/bin/activate
pip3 install -r ${PIP_REQUIREMENTS}
deactivate

chmod o+w /tmp/uwsgi/uwsgi.sock
