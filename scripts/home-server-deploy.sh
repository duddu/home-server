#!/bin/bash

set -e

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME="/Users/duddu"
CLONE_DIR="${HOME}/.home-server"

rm -rf $CLONE_DIR
git clone --depth=20 --filter=blob:none --no-checkout git@github.com:duddu/home-server.git $CLONE_DIR
cd $CLONE_DIR
git sparse-checkout set --no-cone \
    .git-crypt \
    .gitattributes \
    home-server-manifest.yaml \
    packages/nginx-reverse-proxy/ssl \
    'scripts/home-server-*.sh'
git reset --hard "${COMMIT_SHA:-HEAD}"
git-crypt unlock

if [ "$1" = "--machine-rm" ]
then
    bash ./scripts/home-server-machine-rm.sh
fi
bash ./scripts/home-server-pod-start.sh