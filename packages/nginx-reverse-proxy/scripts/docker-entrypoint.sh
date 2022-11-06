#!/bin/sh

set -e
set -u
: "${ACME_HOME:?Variable not set or empty}"
: "${DOMAIN_NAME:?Variable not set or empty}"
: "${SSL_INSTALL_PATH:?Variable not set or empty}"

ACME_COMMON_ARGS="--home $ACME_HOME -w /usr/local/share/www --server letsencrypt -d $DOMAIN_NAME -d api.$DOMAIN_NAME"
echo "acme.sh --issue -k 4096 -ak 4096 $ACME_COMMON_ARGS" > /usr/local/bin/acme-issue
echo "acme.sh --renew --force $ACME_COMMON_ARGS" > /usr/local/bin/acme-renew
echo "acme.sh --install-cert --key-file $SSL_INSTALL_PATH/private.key --fullchain-file $SSL_INSTALL_PATH/fullchain.pem --reloadcmd 'exit 0' $ACME_COMMON_ARGS" > /usr/local/bin/acme-install
chmod +x /usr/local/bin/acme-*
acme-install

(websocketd --port=9090 --devconsole tail -f /var/log/nginx/nginx-reverse-proxy.log) & 
/docker-entrypoint.sh "$@"