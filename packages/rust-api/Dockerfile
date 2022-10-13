FROM rust:1.63.0-buster as builder

WORKDIR /app
ADD . ./
RUN cargo build --release
RUN cargo test --release

FROM debian:buster-slim as production
ARG APP_DIR=/usr/src/app
ARG APP_USER=rusty

WORKDIR ${APP_DIR}

EXPOSE 8000

ENV TZ=Europe/London \
    MACHINE_LOCALHOST=host.containers.internal

RUN groupadd ${APP_USER} && \
    useradd -g ${APP_USER} ${APP_USER} && \
    mkdir -p ${APP_DIR}

HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1

COPY --from=builder --chown=${APP_USER}:${APP_USER} /app/Rocket.toml /app/target/release/home-server-rust-api ${APP_DIR}/
USER ${APP_USER}

CMD ["./home-server-rust-api"]