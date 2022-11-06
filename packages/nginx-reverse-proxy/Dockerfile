#syntax=docker/dockerfile:1.4

ARG NGINX_CONF=/etc/nginx/nginx.conf
ARG LOCAL_DIR=/usr/local

FROM nginx:1.23-alpine as builder
ARG DOMAIN_EMAIL
ARG NGINX_CONF
ARG LOCAL_DIR

WORKDIR ${LOCAL_DIR}

RUN apk add --no-cache \
        openssl=1.1.1q-r0 \
        socat=1.7.4.3-r0 \
        websocketd=0.4.1-r10 \
        tzdata=2022c-r0 && \
    set -o pipefail && \
    curl https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh | sh -s -- \
        --install-online \
        --accountemail  my@example.com \
        --home /usr/local/share/.acme.sh

COPY ssl/test share/ssl
COPY nginx.conf ${NGINX_CONF}

RUN sed -e "s/\$DOMAIN_NAME/localhost/g" \
        -e "s/server home-server/server test.home-server/g" \
        -e "s/server tplinkwifi.net/server test.tplinkwifi.net/g" -i ${NGINX_CONF} && \
    nginx -t

FROM nginx:1.23-alpine as production
ARG DOMAIN_NAME
ARG NGINX_CONF
ARG LOCAL_DIR

WORKDIR ${LOCAL_DIR}

ENV TZ=Europe/London \
    DOMAIN_NAME=${DOMAIN_NAME} \
    SSL_INSTALL_PATH=/usr/local/share/ssl

RUN touch /var/run/nginx.pid && \
    touch /var/log/nginx/nginx-reverse-proxy.log && \
    mkdir -p /usr/local/share/www/.well-known/acme-challenge && \
    chown nginx:nginx /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /usr/local/share/.acme.sh && \
    chown -R nginx:nginx /usr/local/share/www && \
    chmod -R 600 /usr/local/share/.acme.sh
    chmod -R 600 /usr/local/share/www

COPY --from=builder --chown=nginx:nginx /usr/bin/websocketd /usr/local/share/.acme.sh/acme.sh bin/
COPY scripts/docker-entrypoint.sh scripts/nginx-healthcheck.sh bin/
COPY nginx.conf ${NGINX_CONF}

RUN sed -e "s/\$DOMAIN_NAME/${DOMAIN_NAME}/g" -i ${NGINX_CONF}

USER nginx

HEALTHCHECK ["nginx-healthcheck.sh"]
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx"]

ARG COMMIT
ARG TAG
LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-nginx-reverse-proxy"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="nginx-reverse-proxy"
LABEL org.opencontainers.image.description="home server - nginx reverse proxy v${TAG} - ${COMMIT}"