#!/bin/sh

set -e

(websocketd --port=8888 --devconsole tail -f /var/log/nginx/nginx-reverse-proxy.log) & 
/docker-entrypoint.sh "$@"