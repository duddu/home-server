#!/bin/zsh

set -e

CLUSTER=home-server

cd "${0%/*}"

(kind get clusters | grep -q $CLUSTER &&
  echo "⏭ Cluster ${CLUSTER} already exists") ||
  (echo "⏳ Creating cluster ${CLUSTER}..." &&
    kind create cluster --config ../../config/kind/cluster.yaml &&
    kubectl cluster-info --context kind-home-server &&
    echo "✨ Cluster ${CLUSTER} created successfully")