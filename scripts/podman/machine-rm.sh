#!/bin/bash

set -e

VM=home-server-vm

(podman machine list | grep -q $VM &&
  echo "⏳ Stopping virtual machine ${VM}..." &&
    podman machine stop $VM 1> /dev/null &&
    echo "🛑 Virtual machine ${VM} stopped successfully") ||
  echo "⏭ Virtual machine ${VM} is not running"

echo "⏳ Removing virtual machine ${VM}..."
podman machine rm -f $VM 1> /dev/null &&
  echo "🗑 Virtual machine ${VM} removed successfully"