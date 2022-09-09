#!/bin/sh

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

rm -rf ~/.home-server
git clone git@github.com:duddu/podman-home-server-pod.git ~/.home-server
cd ~/.home-server
git-crypt unlock
HOME=/Users/duddddu ./home-server-pod-start.sh
