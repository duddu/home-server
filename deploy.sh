#!/bin/sh

set -e

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

rm -rf ~/.home-server
git clone git@github.com:duddu/podman-home-server-pod.git ~/.home-server
cd oweurhfioeurh
cd ~/.home-server
git-crypt unlock
HOME=/Users/duddu ./home-server-pod-start.sh
