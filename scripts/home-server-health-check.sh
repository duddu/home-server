#!/bin/bash

set -e

curl --cert $SSL_CLIENT_CERT_PATH --fail $HTTPS_HOST/health || exit 1