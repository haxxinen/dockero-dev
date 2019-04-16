# Dockerized nginx on Alpine.
FROM haxxinen/alpine_base

ARG NGINX_VERSION=latest
COPY scripts/nginx_installer.sh /tmp/nginx_installer.sh

COPY setup.sh /tmp/setup.sh
RUN sh /tmp/setup.sh && rm -r /tmp/setup.sh
EXPOSE 80 443
CMD ["/usr/bin/supervisord"]
