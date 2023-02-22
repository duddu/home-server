#syntax=docker/dockerfile:1.4

ARG DEBIAN_FRONTEND=noninteractive

FROM debian:11.6-slim as builder
ARG DEBIAN_FRONTEND

WORKDIR /tmp/monero

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates=20210119 \
        curl=7.74.0-1.3+deb11u5 \
        bzip2=1.0.8-4 && \
    curl -L -O https://downloads.getmonero.org/cli/linux64 && \
    curl -L -O https://www.getmonero.org/downloads/hashes.txt && \
    grep -qe $(sha256sum linux64) hashes.txt && \
    tar -xvf linux64 && \
    mv monero-x86_64-linux-gnu-*/monero* /usr/local/bin && \
    rm -rf /tmp/monero && \
    rm -rf /var/lib/apt/lists/*

FROM debian:11.6-slim as production
ARG DEBIAN_FRONTEND

RUN apt-get update && \
    apt-get install -y --no-install-recommends tor=0.4.5.10-1~deb11u1 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/monero

ENV TZ=Europe/London

COPY --from=builder /usr/local/bin/monero* /usr/local/bin/
COPY scripts/docker-entrypoint.sh scripts/monero-healthcheck.sh /usr/local/bin/
COPY monerod.conf monero-wallet-cli.conf /etc/
COPY torrc /etc/tor/torrc

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["monerod"]

ARG COMMIT
ARG TAG
LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-monero"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="monero"
LABEL org.opencontainers.image.description="home server - monero v${TAG} - ${COMMIT}"