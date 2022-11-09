#!/bin/sh

set -e
set -u
: "${MONERO_RPC_LOGIN:?Variable not set or empty}"

(curl -ks https://localhost:18082 1> /dev/null &&
  echo "Monero rpc ssl reachable") ||
  (echo "Monero rpc ssl not reachable; trying to retrieve daemon status..." &&
    monerod status --rpc-login $MONERO_RPC_LOGIN --log-level 1 ;
    exit 1)