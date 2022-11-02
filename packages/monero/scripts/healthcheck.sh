#!/bin/sh

set -e

pidof monerod &&
  echo "monero daemon running" ||
  echo "monero daemon not running"