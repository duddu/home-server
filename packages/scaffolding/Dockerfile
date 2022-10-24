#syntax=docker/dockerfile:1.4

FROM alpine:3.16 as builder
ARG DOMAIN_EMAIL

WORKDIR /usr/local/home-server

RUN apk add --no-cache \
      curl=7.83.1-r3 \
      gnupg=2.2.35-r4 \
      git=2.36.3-r0 \
      git-crypt=0.6.0-r2 \
      openssl=1.1.1q-r0 && \
    curl https://get.acme.sh | sh -s email=${DOMAIN_EMAIL}

ENTRYPOINT ["./packages/scaffolding/scripts/docker-entrypoint.sh"]

FROM builder as production

COPY . ./

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