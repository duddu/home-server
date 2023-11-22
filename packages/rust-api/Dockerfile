#syntax=docker/dockerfile:1.4

ARG APP_DIR=/usr/local/src

FROM rust:1.64-slim-bullseye as builder
ARG APP_DIR

WORKDIR ${APP_DIR}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    pkg-config=0.29.2-1 libssl-dev=1.1.1n-0+deb11u3 websocketd=0.4.1-1+b5

COPY . ./
RUN cargo test --release && \
    cargo build --release

FROM debian:bullseye-20231030-slim as production
ARG APP_USER=rusty
ARG APP_DIR
ARG DOMAIN_NAME

WORKDIR ${APP_DIR}

RUN groupadd ${APP_USER} && \
    useradd -g ${APP_USER} ${APP_USER} && \
    touch rust-api.log && \
    chown ${APP_USER}:${APP_USER} rust-api.log

COPY --from=builder --chown=${APP_USER}:${APP_USER} \
    ${APP_DIR}/Rocket.toml \
    ${APP_DIR}/scripts/docker-entrypoint.sh \
    ./
COPY --from=builder --chown=${APP_USER}:${APP_USER} \
    ${APP_DIR}/target/release/home-server-rust-api \
    ${APP_DIR}/target/release/home-server-rust-api-healthcheck \
    /usr/bin/websocketd \
    /usr/local/bin/

ENV TZ=Europe/London \
    ROCKET_DOMAIN_NAME=${DOMAIN_NAME}

USER ${APP_USER}

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["home-server-rust-api"]

ARG TAG
ARG COMMIT
LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-rust-api"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="rust-api"
LABEL org.opencontainers.image.description="home server - rust api v${TAG} - ${COMMIT}"