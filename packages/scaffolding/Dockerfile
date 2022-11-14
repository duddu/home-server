#syntax=docker/dockerfile:1.4

FROM alpine:3.16 as production
ARG USER=mason

RUN apk update && apk upgrade && \
    apk add --no-cache \
        gnupg=2.2.35-r4 \
        git=2.36.3-r0 \
        git-crypt=0.6.0-r2 \
        tzdata=2022f-r1 && \
    addgroup ${USER} && \
    adduser -G ${USER} -D ${USER}

WORKDIR /home/${USER}

USER ${USER}

ENV TZ=Europe/London

COPY --chown=${USER}:${USER} ./packages/scaffolding/scripts/docker-entrypoint.sh /usr/local/bin/
COPY --chown=${USER}:${USER} . ./

ENTRYPOINT ["docker-entrypoint.sh"]

ARG TAG
ARG COMMIT
LABEL org.opencontainers.image.authors="Davide Doronzo"
LABEL org.opencontainers.image.url="https://github.com/duddu/home-server/pkgs/container/home-server-scaffolding"
LABEL org.opencontainers.image.version="${TAG}"
LABEL org.opencontainers.image.revision="${COMMIT}"
LABEL org.opencontainers.image.vendor="duddu"
LABEL org.opencontainers.image.licenses="Unlicense"
LABEL org.opencontainers.image.title="scaffolding"
LABEL org.opencontainers.image.description="home server - scaffolding v${TAG} - ${COMMIT}"