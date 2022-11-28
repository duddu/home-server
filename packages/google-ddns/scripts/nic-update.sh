#!/bin/sh

set -e
set -u
: "${GOOGLE_DDNS_HOSTNAME:?Variable not set or empty}"
: "${GOOGLE_DDNS_LOGIN:?Variable not set or empty}"
: "${TAG:?Variable not set or empty}"

echo $(date +'%Y-%m-%dT%H:%M:%S%z') 'Google DDNS update started'

PUBLIC_IP_DIR=/var/public-ip
PUBLIC_IP=$(curl --fail -s https://domains.google.com/checkip)

if [ -f "$PUBLIC_IP_DIR/$PUBLIC_IP" ]; then
  echo "⏭ Public IP $PUBLIC_IP has not changed; skipping nic update"
  exit 0
fi

echo "⏳ Public IP has changed to $PUBLIC_IP; attempting update..."

NIC_UPDATE_PATH="domains.google.com/nic/update"
NIC_UPDATE_QUERY="hostname=$GOOGLE_DDNS_HOSTNAME&myip=$PUBLIC_IP"
NIC_UPDATE_URL="https://$GOOGLE_DDNS_LOGIN@$NIC_UPDATE_PATH?$NIC_UPDATE_QUERY"

curl -X POST $NIC_UPDATE_URL \
  -H "Authorisation: Basic base64-encoded-auth-string" \
  -H "User-Agent: home-server/google-ddns/$TAG"

rm -f $PUBLIC_IP_DIR/*
touch $PUBLIC_IP_DIR/$PUBLIC_IP

echo "✅ Dynamic DNS updated successfully"