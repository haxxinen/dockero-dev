# Dockerized mysql on Alpine.
FROM haxxinen/alpine_base

ARG DB_APP_USER
ARG DB_NAME
ARG DB_APP_USER
ARG DB_APP_PASS
ARG DB_ROOT_PASS

COPY setup.sh /tmp/setup.sh
RUN sh /tmp/setup.sh && rm -r /tmp/setup.sh
CMD ["/usr/bin/supervisord"]

# USER 501