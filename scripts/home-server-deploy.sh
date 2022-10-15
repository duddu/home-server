#!/bin/bash

set -e

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME="/Users/${SSH_USER}"
CLONE_DIR="${HOME}/.home-server"

rm -rf $CLONE_DIR/{*,.git*}
cd $CLONE_DIR
git clone -q --no-checkout --depth=20 --filter=blob:none git@github.com:duddu/home-server.git .
git sparse-checkout set --no-cone \
    .git-crypt \
    .gitattributes \
    home-server-manifest.yaml \
    packages/nginx-reverse-proxy/ssl \
    'scripts/home-server-*.sh' \
    1> /dev/null
git reset --hard "${COMMIT_SHA:-HEAD}" 1> /dev/null
git-crypt unlock

if [ "$1" = "--machine-rm" ]
then
    bash ./scripts/home-server-machine-rm.sh
fi
bash ./scripts/home-server-pod-start.sh