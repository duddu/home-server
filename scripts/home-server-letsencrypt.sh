#!/bin/bash

set -e
set -u
: "${USER:?Variable not set or empty}"
: "${DOMAIN_NAME:?Variable not set or empty}"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME="/Users/${USER}"
export USER
export DOMAIN_NAME

letsencrypt_operation () {
  mkdir -p $HOME/.letsencrypt/${DOMAIN_NAME}
  bash ${HOME}/.home-server/scripts/home-server-pod-start.sh \
    --letsencrypt \
    "--rm \
    -p 8080:80 \
    -v /var/home/core/.letsencrypt:/acme.sh \
    neilpang/acme.sh \
    $@ -d $DOMAIN_NAME -d api.$DOMAIN_NAME"
}

case "$1" in
  --issue)
    letsencrypt_operation --issue --standalone -k 4096 -ak 4096 --server letsencrypt
    ;;

  --renew)
    letsencrypt_operation --renew --force
    ;;

  *)
    echo "Error: $1 is not a valid argument"
    exit 1
    ;;
esac