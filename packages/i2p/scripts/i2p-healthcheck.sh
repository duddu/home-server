#!/bin/sh

set -e

[ "$(i2prouter status | grep -o STARTED | wc -l)" = 2 ] &&
  exit 0 ||
  (i2prouter status ; exit 1)