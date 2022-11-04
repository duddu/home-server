#!/bin/sh

set -e
set -u
: "${TAG:?Variable not set or empty}"
: "${GOOGLE_DDNS_HOSTNAME:?Variable not set or empty}"
: "${GOOGLE_DDNS_USERNAME:?Variable not set or empty}"
: "${GOOGLE_DDNS_PASSWORD:?Variable not set or empty}"

PUBLIC_IP=$(curl --fail -s https://domains.google.com/checkip)

NIC_UPDATE_PATH="domains.google.com/nic/update"
NIC_UPDATE_QUERY="hostname=$GOOGLE_DDNS_HOSTNAME&myip=$PUBLIC_IP"
NIC_UPDATE_AUTH="$GOOGLE_DDNS_USERNAME:$GOOGLE_DDNS_PASSWORD"
NIC_UPDATE_URL="https://$NIC_UPDATE_AUTH@$NIC_UPDATE_PATH?$NIC_UPDATE_QUERY"

curl --fail -X POST $NIC_UPDATE_URL \
  -H  "Authorisation: Basic base64-encoded-auth-string" \
  -H  "User-Agent: home-server/google-ddns/$TAG"