#!/bin/sh

set -e
set -u
: "${MONERO_RPC_LOGIN:?Variable not set or empty}"

monerod status --rpc-login $MONERO_RPC_LOGIN --log-level 1