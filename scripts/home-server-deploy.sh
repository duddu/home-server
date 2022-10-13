#!/bin/bash

set -e

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME="/Users/duddu"
CLONE_DIR="${HOME}/.home-server"

rm -rf $CLONE_DIR
git clone --depth 1 git@github.com:duddu/home-server.git $CLONE_DIR
cd $CLONE_DIR
git-crypt unlock
if [ "$1" = "--machine-rm" ]
then
    bash ./scripts/home-server-machine-rm.sh
fi
bash ./scripts/home-server-pod-start.sh