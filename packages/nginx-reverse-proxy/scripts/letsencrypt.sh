#!/bin/sh

set -e
set -u
: "${ACME_HOME:?Variable not set or empty}"
: "${DOMAIN_NAME:?Variable not set or empty}"
: "${SSL_INSTALL_PATH:?Variable not set or empty}"
: "${1:?Command argument not set or empty}"

SUBJ_ALT_NAMES="api plex xmr"
WWW_ROOT="/usr/local/share/www"
ACME_COMMON_ARGS="--home $ACME_HOME -w $WWW_ROOT --server letsencrypt -d $DOMAIN_NAME -d $(echo "$SUBJ_ALT_NAMES" | sed "s/ /\.$DOMAIN_NAME -d /g").$DOMAIN_NAME"

echo "⏳ Performing ssl certificates $1 operation..."

case "$1" in
  issue)
    acme.sh --issue -k 4096 -ak 4096 $ACME_COMMON_ARGS
    ;;

  renew)
    acme.sh --renew --force $ACME_COMMON_ARGS
    ;;
  
  install)
    INSTALL_ARGS="--install-cert --key-file $SSL_INSTALL_PATH/private.key --fullchain-file $SSL_INSTALL_PATH/fullchain.pem $ACME_COMMON_ARGS"
    if [ "${2:-}" = "--no-postinstall-reload" ]; then
      acme.sh $INSTALL_ARGS --reloadcmd 'exit 0'
    else
      acme.sh $INSTALL_ARGS --reloadcmd 'nginx -s reload'
    fi
    ;;

  *)
    echo "Command argument must be one of: (issue, renew, install)"
    exit 1
    ;;
esac

echo "🔐 Let's Encrypt certificates updated"