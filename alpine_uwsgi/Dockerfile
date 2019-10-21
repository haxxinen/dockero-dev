FROM haxxinen/alpine_base

ARG DIR_WEBROOT
ARG DEPLOY_SCRIPT

COPY setup.sh /tmp/setup.sh
COPY deploy.sh ${DEPLOY_SCRIPT}
RUN sh /tmp/setup.sh && rm -r /tmp/setup.sh

ENV DIR_WEBROOT=''
ENV PIP_REQUIREMENTS=''

CMD ["/usr/bin/supervisord"]
