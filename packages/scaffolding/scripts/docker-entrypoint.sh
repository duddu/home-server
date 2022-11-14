#!/bin/sh

set -e

git stash
git-crypt unlock

cp -R config /usr/local/share/home-server/
cp -R scripts /usr/local/share/home-server/
cp packages/nginx-reverse-proxy/ssl/ca.pem /usr/local/share/ssl/
cp packages/nginx-reverse-proxy/ssl/dhparam.pem /usr/local/share/ssl/

rm -rf ./*

echo "🛠 Scaffolding completed"