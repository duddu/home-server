#!/bin/sh

set -e

HEALTHCHECK_URL=http://localhost:8080/health

[ "$(curl -s --fail $HEALTHCHECK_URL)" = "OK" ]