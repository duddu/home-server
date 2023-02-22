#syntax=docker/dockerfile:1.4

FROM debian:11.6-slim as production

ARG DEBIAN_FRONTEND=noninteractive
ARG I2P_PUB_KEY=/usr/share/keyrings/i2p-archive-keyring.gpg
ARG I2P_USER=i2p

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
    echo "deb [signed-by=${I2P_PUB_KEY}] https://deb.i2p2.de/ $(lsb_release -sc) main" \
        | tee /etc/apt/sources.list.d/i2p.list && \
    curl -o ${I2P_PUB_KEY} https://geti2p.net/_static/i2p-archive-keyring.gpg && \
    gpg --keyid-format long --import --import-options show-only --with-fingerprint ${I2P_PUB_KEY} \
        | grep -q '7840 E761 0F28 B904 7535  49D7 67EC E560 5BCF 1346' && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        i2p=2.0.0-2ubuntu1 \
        i2p-keyring=2021.09.10 && \
    apt-get purge -y python3.9 apt-transport-https curl gnupg lsb-release && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/apt/sources.list.d/* && \
    rm -f ${I2P_PUB_KEY} && \
    addgroup ${I2P_USER} && \
    adduser --disabled-password --gecos '' --home /${I2P_USER} --ingroup ${I2P_USER} ${I2P_USER}

USER ${I2P_USER}

CMD ["i2prouter", "console"]

COPY scripts/i2p-healthcheck.sh /usr/local/bin/

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