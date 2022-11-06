#!/bin/bash

echo "disabled"

# set -e
# set -u
# : "${USER:?Variable not set or empty}"
# : "${COMMIT_SHA:?Variable not set or empty}"

# export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export HOME="/Users/${USER}"
# CLONE_DIR="${HOME}/.home-server"
# SSL_CERTS='packages/nginx-reverse-proxy/ssl/*.pem'
# SSL_EXPORT_DIR="${HOME}/.podman_volumes/ssl"

# clone_sparse_checkout () {
#   git clone \
#     -q --depth=1 \
#     --no-checkout \
#     --filter=blob:none \
#     git@github.com:duddu/home-server.git \
#     . \
#     1> /dev/null
#   git sparse-checkout \
#     set --no-cone \
#       .git-crypt \
#       .gitattributes \
#       home-server-manifest.yaml \
#       home-server-nfsvolume-manifest.yaml \
#       'packages/nginx-reverse-proxy/ssl/*.pem' \
#       'scripts/*.sh' \
#     1> /dev/null
#   git reset \
#     --hard \
#     $COMMIT_SHA \
#     1> /dev/null
# }

# rm -rf $CLONE_DIR
# mkdir -p $CLONE_DIR
# cd $CLONE_DIR
# clone_sparse_checkout
# git-crypt unlock

# # mkdir -p $SSL_EXPORT_DIR
# # cp packages/nginx-reverse-proxy/ssl/*.pem $SSL_EXPORT_DIR

# if [ "${1:-}" = "--restart-vm" ]
# then
#   bash ./scripts/home-server-machine-rm.sh
# fi
# bash ./scripts/home-server-pod-start.sh