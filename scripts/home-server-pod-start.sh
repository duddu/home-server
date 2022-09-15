#!/bin/bash

set -e

cd "${0%/*}"
cd ..

VM=home-server-vm
VM_CPUS=1
VM_RAM=1024
MANIFEST=home-server-manifest.yaml

(podman machine list | grep -q $VM &&
  echo "⏭ Virtual machine ${VM} already exists") ||
  (echo "⏳ Creating virtual machine ${VM}..." &&
    podman machine init $VM --cpus=$VM_CPUS --memory=$VM_RAM 1> /dev/null &&
    echo "✅ Virtual machine ${VM} created successfully")

(podman machine inspect $VM | grep -q '"State": "running"' &&
  echo "⏭ Virtual machine ${VM} is already running") ||
  (echo "⏳ Starting virtual machine ${VM}..." &&
    podman machine start $VM 1> /dev/null &&
    echo "🚀 Virtual machine ${VM} started successfully")

echo "⏳ Tearing down pod home-server if running..."
(envsubst < $MANIFEST | podman play kube -q --down - &> /dev/null &&
  echo "✅ Torn down pod home-server") ||
  echo "⏭ Pod home-server is not running"

echo "⏳ Starting pod home-server..."
envsubst < $MANIFEST | podman play kube -q - 1> /dev/null &&
  echo "🚀 Pod home-server started successfully"