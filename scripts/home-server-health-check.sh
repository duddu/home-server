#!/bin/bash

set -e
set -u
: "${SSL_CLIENT_CERT_PATH:?Variable not set or empty}"
: "${DOMAIN_NAME:?Variable not set or empty}"

TIMEOUT=10

perform_health_check () {
  [ "$(curl -s --fail -m $TIMEOUT --cert $SSL_CLIENT_CERT_PATH https://$DOMAIN_NAME$1)" = "OK" ] 1> /dev/null
}

(echo "⏳ Running nginx e2e health check..." &&
  perform_health_check /health &&
    echo "⏳ Running api e2e health check..." &&
      perform_health_check /api/health &&
  echo "🏥 Health checks completed") ||
  exit 1