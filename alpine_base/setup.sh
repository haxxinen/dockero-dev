#!/usr/bin/env sh

apk --update --no-cache add bind-tools musl-dev ncurses-dev wget curl sudo zip unzip ca-certificates supervisor
echo "Europe/Zurich" > /etc/timezone

[ ${INSTALL_SSH} -eq 1 ] && apk --update --no-cache add openssh && \
adduser -D -s /bin/sh -h /home/${SSH_USER} -g ${SSH_USER} ${SSH_USER} && \
ssh-keygen -A -b 4096 && echo "${SSH_USER}:${SSH_PASS}" | chpasswd
