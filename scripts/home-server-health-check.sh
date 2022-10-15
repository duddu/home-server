#!/bin/bash

set -e
set -u
: "${SSL_CLIENT_CERT_PATH:?Variable not set or empty}"
: "${DOMAIN_NAME:?Variable not set or empty}"

perform_health_check () {
  [ "$(curl -s --cert $SSL_CLIENT_CERT_PATH --fail https://$DOMAIN_NAME$1)" = "OK" ]
}

(echo "⏳ Running nginx health check..." &&
  perform_health_check /health 1> /dev/null &&
    echo "⏳ Running api health check..." &&
      perform_health_check /api/health 1> /dev/null &&
  echo "🏥 Health checks completed") ||
  exit 1