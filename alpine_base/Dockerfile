# Dockerized Alpine base.
# This image allows building containers w/ or w/o SSH support.

FROM alpine:latest
ARG INSTALL_SSH
ARG SSH_USER
ARG SSH_PASS

COPY setup.sh /tmp/setup.sh
RUN sh /tmp/setup.sh && rm -r /tmp/setup.sh
CMD ["/usr/bin/supervisord"]
