#!/bin/sh

set -e
set -u
: "${MONERO_RPC_LOGIN:?Variable not set or empty}"

CMD=$(monerod status --rpc-login $MONERO_RPC_LOGIN)

echo $CMD | grep -q 'uptime' &&
  echo "monero daemon running" ||
  echo $CMD