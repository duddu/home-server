#!/bin/sh

set -e

MONEROD_HOST=http://127.0.0.1:18081

curl -s $MONEROD_HOST &&
  echo "monero daemon running" ||
  curl -v $MONEROD_HOST