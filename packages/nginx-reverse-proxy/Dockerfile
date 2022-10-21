#syntax=docker/dockerfile:1.4

ARG NGINX_CONF=/etc/nginx/nginx.conf
ARG LOCAL_DIR=/usr/local

FROM nginx:1.23-alpine as builder
ARG NGINX_CONF
ARG LOCAL_DIR

WORKDIR ${LOCAL_DIR}

RUN apk add websocketd && \
    touch /var/run/nginx.pid && \
    touch /var/log/nginx/nginx-reverse-proxy.log

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

ENV TZ=Europe/London

RUN touch /var/run/nginx.pid && \
    touch /var/log/nginx/nginx-reverse-proxy.log && \
    chown nginx:nginx /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /usr/share/nginx && \
    chmod -R 400 /usr/share/nginx

COPY --from=builder --chown=nginx:nginx /usr/bin/websocketd bin/
COPY scripts/docker-entrypoint.sh scripts/healthcheck.sh ./
COPY nginx.conf ${NGINX_CONF}

RUN sed -e "s/\$DOMAIN_NAME/${DOMAIN_NAME}/g" -i ${NGINX_CONF}

USER nginx

ENTRYPOINT ["./docker-entrypoint.sh"]
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