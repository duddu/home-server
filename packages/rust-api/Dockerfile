#syntax=docker/dockerfile:1.4

FROM rust:1.64-bullseye as builder

WORKDIR /app

ADD https://github.com/joewalnes/websocketd/releases/download/v0.4.1/websocketd-0.4.1-linux_amd64.zip ./
RUN unzip websocketd-0.4.1-linux_amd64.zip websocketd && \
    rm websocketd-0.4.1-linux_amd64.zip

ADD . ./
RUN cargo build --release
RUN cargo test --release

FROM debian:11.5-slim as production
ARG APP_DIR=/usr/src/app
ARG APP_USER=rusty
ARG TAG
ARG COMMIT
ARG DOMAIN_NAME
LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-rust-api"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="rust-api"
LABEL org.opencontainers.image.description="Home Server - Rust API"

WORKDIR ${APP_DIR}

EXPOSE 8000

ENV TZ=Europe/London \
    ROCKET_DOMAIN_NAME=${DOMAIN_NAME}

RUN groupadd ${APP_USER} && \
    useradd -g ${APP_USER} ${APP_USER} && \
    mkdir -p ${APP_DIR} && \
    touch rust-api.log && \
    chown ${APP_USER}:${APP_USER} rust-api.log

COPY --from=builder --chown=${APP_USER}:${APP_USER} \
    /app/Rocket.toml \
    /app/scripts/docker-entrypoint.sh \
    /app/target/release/home-server-rust-api \
    /app/websocketd \
    ./

HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1

USER ${APP_USER}

ENTRYPOINT ["./docker-entrypoint.sh"]