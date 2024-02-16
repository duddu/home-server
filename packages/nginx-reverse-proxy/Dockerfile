#syntax=docker/dockerfile:1.4

ARG NGINX_CONF=/etc/nginx/nginx.conf
ARG LOCAL_DIR=/usr/local

FROM nginx:1.25.4-alpine as builder
ARG NGINX_CONF
ARG LOCAL_DIR

WORKDIR ${LOCAL_DIR}

COPY ssl/test share/ssl
COPY nginx.conf ${NGINX_CONF}

RUN apk update && apk add --no-cache libxml2=2.9.14-r2 && \
    sed -e "s/\$DOMAIN_NAME/localhost/g" \
        -e "s/server home-server/server test.home-server/g" \
        -e "s/server tplinkwifi.net/server test.tplinkwifi.net/g" -i ${NGINX_CONF} && \
    nginx -t

FROM nginx:1.25.4-alpine as production
ARG DOMAIN_NAME
ARG DOMAIN_EMAIL
ARG NGINX_CONF
ARG LOCAL_DIR
ARG ACME_HOME=${LOCAL_DIR}/share/.acme.sh

WORKDIR ${LOCAL_DIR}

ENV TZ=Europe/London \
    ACME_HOME=${ACME_HOME} \
    DOMAIN_NAME=${DOMAIN_NAME} \
    SSL_INSTALL_PATH=${LOCAL_DIR}/ssl

RUN apk update && apk upgrade && \
    apk add --no-cache \
        libxml2=2.11.4-r0 \
        openssl=3.1.3-r0 \
        socat==1.7.4.4-r1 \
        tzdata=2023c-r1 \
        websocketd=0.4.1-r18 && \
    curl https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh | sh -s -- \
        --install-online \
        --accountemail ${DOMAIN_EMAIL} \
        --home ${ACME_HOME} && \
    mv ${ACME_HOME}/acme.sh bin/ && \
    touch /var/run/nginx.pid && \
    touch /var/log/nginx/nginx-reverse-proxy.log && \
    mkdir -p share/.acme.sh && \
    mkdir -p share/www/.well-known/acme-challenge && \
    mkdir -p ${SSL_INSTALL_PATH} && \
    chown nginx:nginx /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx bin && \
    chown -R nginx:nginx share/.acme.sh && \
    chown -R nginx:nginx share/www && \
    chown -R nginx:nginx ${SSL_INSTALL_PATH}

COPY scripts/docker-entrypoint.sh scripts/nginx-healthcheck.sh scripts/letsencrypt.sh bin/
COPY nginx.conf ${NGINX_CONF}

RUN sed -e "s/\$DOMAIN_NAME/${DOMAIN_NAME}/g" -i ${NGINX_CONF}

USER nginx

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