#!/bin/bash

cd "${0%/*}"

VM=home-server-vm
VM_CPUS=1
VM_RAM=1024
MANIFEST=$(envsubst < $PWD/home-server-manifest.yaml)

podman machine list | grep $VM &&
  echo "⏭ Virtual machine ${VM} already exists" ||
  echo "⏳ Creating virtual machine ${VM}..." &&
    podman machine init $VM --cpus=$VM_CPUS --memory=$VM_RAM &&
    echo "✅ Virtual machine ${VM} created successfully"

podman machine inspect $VM | grep '"State": "running"' &&
  echo "⏭ Virtual machine ${VM} is already running" ||
  echo "⏳ Starting virtual machine ${VM}..." &&
    podman machine start $VM &&
    echo "🚀 Virtual machine ${VM} started successfully"

echo "⏳ Tearing down pod home-server if running..."
$MANIFEST | podman play kube --down - &&
  echo "✅ Torn down pod home-server" ||
  echo "⏭ Pod home-server is not running"

echo "⏳ Starting pod home-server..."
$MANIFEST | podman play kube - &&
  echo "🚀 Pod home-server started successfully"
