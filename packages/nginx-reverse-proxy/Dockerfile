#syntax=docker/dockerfile:1.4

ARG LOCAL_DIR=/usr/local

FROM nginx:1.23-alpine as builder
ARG DOMAIN_NAME=localhost
ARG LOCAL_DIR

WORKDIR ${LOCAL_DIR}

COPY ssl/test share/
COPY nginx.conf /etc/nginx/nginx.conf

RUN touch /var/run/nginx.pid && \
    touch /var/log/nginx/nginx-reverse-proxy.log && \
    sed -i "s/%DOMAIN_NAME%/${DOMAIN_NAME}/g" /etc/nginx/nginx.conf && \
    nginx -t

FROM nginx:1.23-alpine as production
ARG TAG
ARG COMMIT
ARG DOMAIN_NAME
ARG LOCAL_DIR
ARG WEBSOCKETD_URL

WORKDIR ${LOCAL_DIR}

ENV TZ=Europe/London

RUN curl -sL ${WEBSOCKETD_URL} -o websocketd.zip && \
    unzip websocketd.zip websocketd && \
    rm websocketd.zip && \
    mv websocketd bin && \
    chown nginx:nginx bin/websocketd && \
    touch /var/run/nginx.pid && \
    touch /var/log/nginx/nginx-reverse-proxy.log && \
    chown nginx:nginx /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /usr/share/nginx

COPY scripts/docker-entrypoint.sh ./
COPY nginx.conf /etc/nginx/nginx.conf

RUN sed -i "s/%DOMAIN_NAME%/${DOMAIN_NAME}/g" /etc/nginx/nginx.conf

USER nginx

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["nginx"]

LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-nginx-reverse-proxy"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="nginx-reverse-proxy"
LABEL org.opencontainers.image.description="Home Server - Nginx reverse proxy"