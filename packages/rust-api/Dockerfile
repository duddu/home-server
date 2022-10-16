#syntax=docker/dockerfile:1.4

ARG APP_DIR=/usr/local/src

FROM rust:1.64-bullseye as builder
ARG APP_DIR
ARG WEBSOCKETD_VERSION

WORKDIR ${APP_DIR}

ADD https://github.com/joewalnes/websocketd/releases/download/v0.4.1/websocketd-${WEBSOCKETD_VERSION}.zip ./
RUN unzip websocketd-${WEBSOCKETD_VERSION}.zip websocketd && \
    rm websocketd-${WEBSOCKETD_VERSION}.zip

COPY . ./
RUN cargo test --release
RUN cargo build --release

FROM debian:11.5-slim as production
ARG APP_USER=rusty
ARG APP_DIR
ARG TAG
ARG COMMIT
ARG DOMAIN_NAME

WORKDIR ${APP_DIR}

HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1

ENV TZ=Europe/London \
    ROCKET_DOMAIN_NAME=${DOMAIN_NAME}

RUN groupadd ${APP_USER} && \
    useradd -g ${APP_USER} ${APP_USER} && \
    touch rust-api.log && \
    chown ${APP_USER}:${APP_USER} rust-api.log

COPY --from=builder --chown=${APP_USER}:${APP_USER} ${APP_DIR}/Rocket.toml ${APP_DIR}/scripts/docker-entrypoint.sh ./
COPY --from=builder --chown=${APP_USER}:${APP_USER} ${APP_DIR}/target/release/home-server-rust-api ${APP_DIR}/websocketd /usr/local/bin/

USER ${APP_USER}

ENTRYPOINT ["./docker-entrypoint.sh"]

LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-rust-api"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="rust-api"
LABEL org.opencontainers.image.description="Home Server - Rust API"