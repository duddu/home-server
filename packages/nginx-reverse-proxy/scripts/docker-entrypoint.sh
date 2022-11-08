#!/bin/sh

set -e
set -a

letsencrypt.sh install

(websocketd --port=9090 --devconsole tail -f /var/log/nginx/nginx-reverse-proxy.log) & 
/docker-entrypoint.sh "$@"