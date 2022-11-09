#!/bin/bash

set -e
set -u
: "${MONERO_RPC_LOGIN:?Variable not set or empty}"
: "${MONERO_ANONYMOUS_INBOUND:?Variable not set or empty}"
: "${MONERO_PEERS:?Variable not set or empty}"

SERVICE_HOST_IP=$(grep `hostname` /etc/hosts | sed 's/[^0-9\.]*//g')
MONERO_PEERS_ARRAY=($MONERO_PEERS)

"$@" --non-interactive \
  --config-file /etc/monerod.conf \
  --rpc-login $MONERO_RPC_LOGIN \
  --tx-proxy i2p,$SERVICE_HOST_IP:48060 \
  --anonymous-inbound $MONERO_ANONYMOUS_INBOUND,$SERVICE_HOST_IP:48061 \
  $(for peer in "${MONERO_PEERS_ARRAY[@]}"; do echo -n "--add-peer $peer "; done)