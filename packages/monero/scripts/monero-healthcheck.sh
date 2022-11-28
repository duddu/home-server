#!/bin/sh

set -e
set -u
: "${MONERO_RPC_LOGIN:?Variable not set or empty}"

CMD_OUTPUT=$(monerod status --rpc-login $MONERO_RPC_LOGIN --log-level 1)

(echo $CMD_OUTPUT | grep -q 'uptime' &&
  echo "Monero daemon healthy") ||
  (echo "Monero daemon unhealthy" &&
    echo $CMD_OUTPUT ;
    exit 1)