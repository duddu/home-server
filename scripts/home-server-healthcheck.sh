#!/bin/bash

set -e
set -u
: "${SSL_CLIENT_CERT_PATH:?Variable not set or empty}"
: "${DOMAIN_NAME:?Variable not set or empty}"

TIMEOUT=30

perform_health_check () {
  [ "$(curl -s --fail -m $TIMEOUT --cert $SSL_CLIENT_CERT_PATH $1)" = "OK" ] 1> /dev/null
}

(echo "⏳ Running http nginx e2e health check..." &&
  perform_health_check http://$DOMAIN_NAME/health &&
    echo "⏳ Running https nginx e2e health check..." &&
    perform_health_check https://$DOMAIN_NAME/health &&
      echo "⏳ Running api e2e health check..." &&
        perform_health_check https://$DOMAIN_NAME/api/health &&
  echo "🏥 Health checks completed") ||
  exit 1