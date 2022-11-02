#syntax=docker/dockerfile:1.4

FROM nginx:1.23-alpine as builder
ARG DOMAIN_EMAIL

RUN apk add --no-cache \
      gnupg=2.2.35-r4 \
      git=2.36.3-r0 \
      git-crypt=0.6.0-r2 \
      openssl=1.1.1q-r0 && \
      socat=1.7.4.3-r0 && \
      tzdata=2022c-r0 && \
    set -o pipefail && \
    curl https://get.acme.sh | sh -s email=${DOMAIN_EMAIL} && \
    mv /root/.acme.sh/acme.sh /usr/local/bin && \
    mkdir -p /usr/local/share/www/.well-known/acme-challenge && \
    chmod -R 600 /usr/local/share/www/.well-known/acme-challenge

FROM builder as production
ARG DOMAIN_NAME
ARG WORKDIR=/usr/local/home-server
ARG NGINX_CONF=/etc/nginx/nginx.conf

ENV DOMAIN_NAME=${DOMAIN_NAME} \
    SSL_INSTALL_PATH=${WORKDIR}/packages/nginx-reverse-proxy/ssl \
    TZ=Europe/London

WORKDIR ${WORKDIR}

COPY . ./
COPY packages/scaffolding/scripts/docker-entrypoint.sh packages/scaffolding/scripts/healthcheck.sh /usr/local/bin
COPY packages/scaffolding/nginx.conf ${NGINX_CONF}

RUN sed -e "s/\$DOMAIN_NAME/${DOMAIN_NAME}/g" -i ${NGINX_CONF}

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx"]

ARG COMMIT
ARG TAG
LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-scaffolding"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="scaffolding"
LABEL org.opencontainers.image.description="home server - scaffolding v${TAG} - ${COMMIT}"