#!/bin/bash

set -e
set -u
: "${HOME:?Variable not set or empty}"

VM=home-server-vm
MANIFEST=$HOME/.home-server/home-server-manifest.yaml
NFSVOLUME_MANIFEST=$HOME/.home-server/home-server-nfsvolume-manifest.yaml

(podman machine list | grep -q $VM &&
  echo "⏭ Virtual machine ${VM} exists") ||
  (echo "⏳ Creating virtual machine ${VM}..." &&
    podman machine init $VM --rootful 1> /dev/null &&
    echo "✨ Virtual machine ${VM} created successfully")

(podman machine inspect $VM | grep -q '"State": "running"' &&
  echo "⏭ Virtual machine ${VM} is running") ||
  (echo "⏳ Starting virtual machine ${VM}..." &&
    podman machine start $VM 1> /dev/null &&
    echo "🎬 Virtual machine ${VM} started successfully")

echo "⏳ Tearing down pod home-server..."
( (podman play kube --down $MANIFEST &> /dev/null ;
    podman volume prune -f &> /dev/null) &&
  echo "🗑 Torn down pod home-server") ||
  echo "⏭ Pod home-server is not running"

if [ "${1:-}" = "--letsencrypt" ]
then
  echo "⏳ Performing TSL certificates maintainance..."
  podman run $(echo "$2" | xargs -n1 echo -n ' ')
  echo "🔐 TSL certificates maintainance completed"
fi

echo "⏳ Starting pod home-server..."
podman play kube $NFSVOLUME_MANIFEST 1> /dev/null &&
podman play kube $MANIFEST 1> /dev/null &&
  echo "🚀 Pod home-server is running"