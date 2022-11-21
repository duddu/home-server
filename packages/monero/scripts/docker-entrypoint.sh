#!/bin/bash

set -e
set -u
: "${MONERO_RPC_LOGIN:?Variable not set or empty}"
: "${MONERO_PEERS:?Variable not set or empty}"

MONERO_PEERS_PARSED=$(echo -n $MONERO_PEERS | tr '\n' ' ')
MONERO_PEERS_ARRAY=($MONERO_PEERS_PARSED)
HOSTNAME_FILE=/var/lib/tor/monero/hostname

nohup tor -f /etc/tor/torrc &

TOR_READY=0
for i in `seq 10`
do
  sleep 2
  if test -f "$HOSTNAME_FILE"
  then
    TOR_READY=1
    echo "Tor is ready"
    break
  fi
done
if test "$TOR_READY" = 0
then
  echo "Error starting Tor"
  exit 1
fi

MONERO_ANONYMOUS_INBOUND=$(cat $HOSTNAME_FILE)

"$@" --non-interactive \
  --config-file /etc/monerod.conf \
  --rpc-login $MONERO_RPC_LOGIN \
  --anonymous-inbound $MONERO_ANONYMOUS_INBOUND:18083,127.0.0.1:18083,64 \
  $(for peer in "${MONERO_PEERS_ARRAY[@]}"; do (echo -n "--add-peer $peer --add-priority-node $peer "); done)