#!/bin/bash

set -e
set -u
: "${USER:?Variable not set or empty}"
: "${COMMIT_SHA:?Variable not set or empty}"
: "${DOMAIN_NAME:?Variable not set or empty}"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME="/Users/${USER}"
export DOMAIN_NAME
CLONE_DIR="${HOME}/.home-server"

mkdir -p $CLONE_DIR
rm -rf $CLONE_DIR/{*,.git*}
cd $CLONE_DIR
git clone -q --no-checkout --depth=1 --filter=blob:none git@github.com:duddu/home-server.git .
git sparse-checkout set --no-cone \
  .git-crypt \
  .gitattributes \
  home-server-manifest.yaml \
  'packages/nginx-reverse-proxy/ssl/*.pem' \
  'scripts/home-server-*.sh' \
  1> /dev/null
git reset --hard "${COMMIT_SHA:-HEAD}" 1> /dev/null
git-crypt unlock

if [ "${1:-}" = "--restart-vm" ]
then
  bash ./scripts/home-server-machine-rm.sh
fi
bash ./scripts/home-server-pod-start.sh