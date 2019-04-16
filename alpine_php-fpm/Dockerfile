FROM haxxinen/alpine_base

ARG DIR_WEBROOT
COPY setup.sh /tmp/setup.sh
RUN sh /tmp/setup.sh && rm -r /tmp/setup.sh
CMD ["/usr/bin/supervisord"]
