#syntax=docker/dockerfile:1.4

FROM nginx:1.23-alpine
ARG TAG
ARG COMMIT
ARG DOMAIN_NAME
LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-nginx-reverse-proxy"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="nginx-reverse-proxy"
LABEL org.opencontainers.image.description="Home Server - Nginx reverse proxy"

ENV TZ=Europe/London

ADD https://github.com/joewalnes/websocketd/releases/download/v0.4.1/websocketd-0.4.1-linux_amd64.zip ./

COPY nginx.conf /etc/nginx/nginx.conf
COPY scripts/docker-entrypoint.sh /usr/share/nginx/docker-entrypoint.sh

RUN sed -i "s/%DOMAIN_NAME%/${DOMAIN_NAME}/g" /etc/nginx/nginx.conf && \
    touch /var/run/nginx.pid && \
    touch /var/log/nginx/nginx-reverse-proxy.log && \
    chown nginx:nginx /var/run/nginx.pid && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    chown -R nginx:nginx /usr/share/nginx && \
    unzip websocketd-0.4.1-linux_amd64.zip websocketd && \
    rm websocketd-0.4.1-linux_amd64.zip && \
    chown nginx:nginx websocketd

USER nginx

ENTRYPOINT ["/usr/share/nginx/docker-entrypoint.sh"]

CMD ["nginx"]