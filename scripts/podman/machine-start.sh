#!/bin/zsh

set -e

VM=home-server-vm

(podman machine list | grep -q $VM &&
  echo "⏭ Virtual machine ${VM} exists") ||
  (echo "⏳ Creating virtual machine ${VM}..." &&
    podman machine init $VM --rootful && sleep 5 &&
    echo "✨ Virtual machine ${VM} created successfully")

(podman machine list | grep -qe "${VM}.*Currently running" &&
  echo "⏭ Virtual machine ${VM} is running") ||
  (echo "⏳ Starting virtual machine ${VM}..." &&
    podman machine start $VM &&
    echo "🎬 Virtual machine ${VM} started successfully")