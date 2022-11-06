#!/bin/sh

set -e

monerod status | grep -q "uptime" &&
  echo "monero daemon running" ||
  echo "monero daemon not running"