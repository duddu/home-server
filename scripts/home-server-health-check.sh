#!/bin/bash

set -e

echo "⏳ Running e2e health check..."
(curl --cert $SSL_CLIENT_CERT_PATH --fail $HTTPS_HOST/api/health 1> /dev/null &&
  echo "✅ Health check completed") ||
  exit 1