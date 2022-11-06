#!/bin/zsh

set -e

VM=home-server-vm

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