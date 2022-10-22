#!/bin/bash

set -e
set -u
: "${HOME:?Variable not set or empty}"

VM=home-server-vm
VM_CPUS=1
VM_RAM=1024
VM_HOME=/var/home/core
MANIFEST=$HOME/.home-server/home-server-manifest.yaml

(podman machine list | grep -q $VM &&
  echo "⏭ Virtual machine ${VM} already exists") ||
  (echo "⏳ Creating virtual machine ${VM}..." &&
    podman machine init $VM \
      --cpus=$VM_CPUS \
      --memory=$VM_RAM \
      -v $HOME/.config/containers/podman/machine:$VM_HOME/.config/containers/podman/machine:ro \
      -v $HOME/.podman_volumes/ssl:$VM_HOME/.podman_volumes/ssl:ro \
      -v $HOME/.letsencrypt:$VM_HOME/.letsencrypt \
      -v $HOME/.local/share/containers/podman/machine:$VM_HOME/.local/share/containers/podman/machine \
      1> /dev/null &&
    echo "✨ Virtual machine ${VM} created successfully")

(podman machine inspect $VM | grep -q '"State": "running"' &&
  echo "⏭ Virtual machine ${VM} is already running") ||
  (echo "⏳ Starting virtual machine ${VM}..." &&
    podman machine start $VM 1> /dev/null &&
    echo "🎬 Virtual machine ${VM} started successfully")

echo "⏳ Tearing down pod home-server if running..."
(podman play kube -q --down $MANIFEST &> /dev/null &&
  echo "🗑 Torn down pod home-server") ||
  echo "⏭ Pod home-server is not running"

if [ "${1:-}" = "--letsencrypt" ]
then
  echo "⏳ Performing TSL certificates maintainance..."
  podman run $(echo "$2" | xargs -n1 echo -n ' ')
  echo "🔐 TSL certificates maintainance completed"
fi

echo "⏳ Starting pod home-server..."
podman play kube -q $MANIFEST 1> /dev/null &&
  echo "🚀 Pod home-server started successfully"