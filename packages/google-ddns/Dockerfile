#syntax=docker/dockerfile:1.4

FROM curlimages/curl:7.86.0 as production

COPY scripts/google-ddns-healthcheck.sh /usr/local/bin/

ARG DOMAIN_NAME
ARG COMMIT
ARG TAG

ENV TZ=Europe/London \
    TAG=${TAG} \
    GOOGLE_DDNS_HOSTNAME=${DOMAIN_NAME}

HEALTHCHECK ["google-ddns-healthcheck.sh"]
CMD ["sleep", "infinity"]

LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-google-ddns"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="google-ddns"
LABEL org.opencontainers.image.description="home server - google-ddns v${TAG} - ${COMMIT}"