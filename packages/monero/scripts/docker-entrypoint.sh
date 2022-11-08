#!/bin/bash

set -e
set -u
: "${MONERO_RPC_LOGIN:?Variable not set or empty}"

"$@" --non-interactive --config-file /etc/monerod.conf --rpc-login $MONERO_RPC_LOGIN