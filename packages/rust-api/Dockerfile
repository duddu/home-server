FROM rust:1.63.0-buster as builder

WORKDIR /app
ADD . ./
RUN cargo build --release

FROM debian:buster-slim
ARG APP=/usr/src/app

RUN apt-get update \
    && apt-get install -y tzdata \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8000

ENV TZ=Etc/UTC \
    APP_USER=appuser \
    ROCKET_ADDRESS=0.0.0.0 \
    ROCKET_LOG_LEVEL=normal \
    ROCKET_PORT=8000 \
    CONTAINERS_HOST=host.containers.internal

RUN groupadd $APP_USER \
    && useradd -g $APP_USER $APP_USER \
    && mkdir -p ${APP}

COPY --from=builder /app/target/release/rust-home-server-api ${APP}/rust-home-server-api

RUN chown -R $APP_USER:$APP_USER ${APP}

USER $APP_USER
WORKDIR ${APP}

HEALTHCHECK CMD curl --fail http://localhost:8000/health || exit 1

CMD ["./rust-home-server-api"]