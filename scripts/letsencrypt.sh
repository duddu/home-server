#!/bin/zsh

set -e
set -u
: "${1:?Acme command argument not provided}"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

kubectl exec deploy/home-server-web it -c nginx-reverse-proxy -- letsencrypt.sh "${1}"