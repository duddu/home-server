#!/bin/sh

cd "${0%/*}"

envsubst < $PWD/home-server-manifest.yaml | podman play kube -
