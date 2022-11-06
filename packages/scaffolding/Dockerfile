#syntax=docker/dockerfile:1.4

FROM alpine:3.16 as builder

RUN apk update && apk upgrade && \
    apk add --no-cache \
        gnupg=2.2.35-r4 \
        git=2.36.3-r0 \
        git-crypt=0.6.0-r2 \
        tzdata=2022f-r1

FROM builder as production

ENV TZ=Europe/London

WORKDIR /usr/local/home-server

COPY . ./
COPY ./packages/scaffolding/scripts/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]

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