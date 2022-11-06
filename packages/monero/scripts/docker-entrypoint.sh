#!/bin/bash

set -e

(websocketd --port=9092 --devconsole tail -f /root/monero/chain/log/monero.log) & 

case "$@" in
  monerod)
    "$@" --non-interactive --config-file /etc/monerod.conf
    ;;

  # monero-wallet-cli)
  #   "$@" --config-file /usr/local/etc/monero-wallet-cli.conf
  #   ;;

  *)
    "$@"
    ;;
esac