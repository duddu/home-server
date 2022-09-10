#!/bin/bash

set -e

cd "${0%/*}"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
CLONE_DIR="~/.home-server"

rm -rf $CLONE_DIR
git clone --depth 1 git@github.com:duddu/podman-home-server-pod.git $CLONE_DIR
cd $CLONE_DIR
git-crypt unlock
HOME=/Users/duddu ./home-server-pod-start.sh
