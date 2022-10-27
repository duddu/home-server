#!/bin/sh

set -e
set -u
: "${DOMAIN_NAME:?Variable not set or empty}"
: "${SSL_INSTALL_PATH:?Variable not set or empty}"

if [ -e /tmp/entrypoint-run ]; then
  if [ -e /tmp/entrypoint-aborted ]; then
    exit 1
  fi
  echo "docker-entrypoint.sh failed on first run, aborting..."
  touch /tmp/entrypoint-aborted
  exit 1
fi
touch /tmp/entrypoint-run

git stash -q
git-crypt unlock 1> /dev/null
git stash pop -q
rm -rf .git*

ACME_COMMON_ARGS="-w /usr/local/share/www --server letsencrypt -d $DOMAIN_NAME -d api.$DOMAIN_NAME"
echo "acme.sh --issue -k 4096 -ak 4096 $ACME_COMMON_ARGS" > /usr/local/bin/acme-issue
echo "acme.sh --renew --force $ACME_COMMON_ARGS" > /usr/local/bin/acme-renew
echo "acme.sh --install-cert --key-file $SSL_INSTALL_PATH/private.key --fullchain-file $SSL_INSTALL_PATH/fullchain.pem --reloadcmd 'exit 0' $ACME_COMMON_ARGS" > /usr/local/bin/acme-install
chmod +x /usr/local/bin/acme-*
acme-install
chmod 644 $SSL_INSTALL_PATH/*

/docker-entrypoint.sh "$@"