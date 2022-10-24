#syntax=docker/dockerfile:1.4

FROM alpine:3.16 as builder

COPY . /usr/local/

RUN apk add --no-cache git gnupg git-crypt

FROM builder as production

ENTRYPOINT ["sh", "-c"]

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