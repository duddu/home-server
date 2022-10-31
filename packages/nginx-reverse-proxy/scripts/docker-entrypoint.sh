#!/bin/sh

set -e

(websocketd --port=9091 --devconsole tail -f /var/log/nginx/nginx-reverse-proxy.log) & 
/docker-entrypoint.sh "$@"