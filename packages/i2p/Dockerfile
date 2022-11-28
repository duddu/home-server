#syntax=docker/dockerfile:1.4

FROM debian:11.5-slim as production

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/London \
    JVM_XMX=256m

EXPOSE 4444 7657

SHELL ["/bin/bash", "-c"]

RUN set -o pipefail && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        apt-transport-https=2.2.4 \
        lsb-release=11.1.0 \
        curl=7.74.0-1.3+deb11u3 \
        ca-certificates=20210119 \
        gnupg=2.2.27-2+deb11u2 \
        procps=2:3.3.17-5 && \
    echo "deb [signed-by=/usr/share/keyrings/i2p-archive-keyring.gpg] https://deb.i2p2.de/ $(lsb_release -sc) main" \
        | tee /etc/apt/sources.list.d/i2p.list && \
    curl -o i2p-archive-keyring.gpg https://geti2p.net/_static/i2p-archive-keyring.gpg && \
    gpg --keyid-format long --import --import-options show-only --with-fingerprint i2p-archive-keyring.gpg \
        | grep -q '7840 E761 0F28 B904 7535  49D7 67EC E560 5BCF 1346' && \
    cp i2p-archive-keyring.gpg /usr/share/keyrings && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        i2p=2.0.0-1ubuntu1 \
        i2p-keyring=2021.09.10 && \
    apt-get purge -y python3.9 apt-transport-https lsb-release gnupg && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/apt/sources.list.d/* && \
    addgroup i2p && \
    adduser --home /i2p --ingroup i2p i2p

COPY scripts/docker-entrypoint.sh scripts/i2p-healthcheck.sh /usr/local/bin/

USER i2p

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["i2prouter"]

ARG COMMIT
ARG TAG

LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-i2p"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="i2p"
LABEL org.opencontainers.image.description="home server - i2p v${TAG} - ${COMMIT}"