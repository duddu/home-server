#syntax=docker/dockerfile:1.4

FROM rust:1.63.0-buster as builder

WORKDIR /app

ADD https://github.com/joewalnes/websocketd/releases/download/v0.4.1/websocketd-0.4.1-linux_amd64.zip ./
RUN unzip websocketd-0.4.1-linux_amd64.zip websocketd

ADD . ./
RUN cargo build --release
RUN cargo test --release

FROM debian:buster-slim as production
ARG APP_DIR=/usr/src/app
ARG APP_USER=rusty

WORKDIR ${APP_DIR}

EXPOSE 8000

ENV TZ=Europe/London

RUN groupadd ${APP_USER} && \
    useradd -g ${APP_USER} ${APP_USER} && \
    mkdir -p ${APP_DIR} && \
    touch rust-api.logs && \
    chown ${APP_USER}:${APP_USER} rust-api.logs

COPY --from=builder --chown=${APP_USER}:${APP_USER} /app/Rocket.toml /app/target/release/home-server-rust-api /app/websocketd /app/scripts/docker-entrypoint.sh ./

HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1

USER ${APP_USER}

ENTRYPOINT ["./docker-entrypoint.sh"]