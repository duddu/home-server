#!/bin/sh

set -e
set -u
: "${TAG:?Variable not set or empty}"
: "${GOOGLE_DDNS_HOSTNAME:?Variable not set or empty}"
: "${GOOGLE_DDNS_USERNAME:?Variable not set or empty}"
: "${GOOGLE_DDNS_PASSWORD:?Variable not set or empty}"

PUBLIC_IP_DIR=/var/public-ip
PUBLIC_IP=$(curl --fail -s https://domains.google.com/checkip)

if [ -f "$PUBLIC_IP_DIR/$PUBLIC_IP" ]; then
  echo "⏭ Public IP $PUBLIC_IP has not changed; skipping update."
  exit 0
fi

echo "⏳ Public IP has changed to $PUBLIC_IP; attempting update..."

NIC_UPDATE_PATH="domains.google.com/nic/update"
NIC_UPDATE_QUERY="hostname=$GOOGLE_DDNS_HOSTNAME&myip=$PUBLIC_IP"
NIC_UPDATE_AUTH="$GOOGLE_DDNS_USERNAME:$GOOGLE_DDNS_PASSWORD"
NIC_UPDATE_URL="https://$NIC_UPDATE_AUTH@$NIC_UPDATE_PATH?$NIC_UPDATE_QUERY"

curl -X POST -v $NIC_UPDATE_URL \
  -H "Authorisation: Basic base64-encoded-auth-string" \
  -H "User-Agent: home-server/google-ddns/$TAG"

touch $PUBLIC_IP_DIR/$PUBLIC_IP

echo "✅ Dynamic DNS updated successfully."