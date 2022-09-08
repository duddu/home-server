#!/bin/sh

cd "${0%/*}"

podman machine list | grep home-server-vm || podman machine init home-server-vm --cpus=1 --memory=1024
podman machine inspect home-server-vm | grep '"State": "running"' || podman machine start home-server-vm
envsubst < $PWD/home-server-manifest.yaml | podman play kube --down - || true
envsubst < $PWD/home-server-manifest.yaml | podman play kube -
