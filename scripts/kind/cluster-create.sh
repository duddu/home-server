#!/bin/zsh

set -e

CLUSTER=home-server
SCAFFOLDING_DIR=/Users/Shared/.podman_volumes/scaffolding

(kind get clusters | grep -q $CLUSTER &&
  echo "⏭ Cluster ${CLUSTER} already exists") ||
  (echo "⏳ Creating cluster ${CLUSTER}..." &&
    kind create cluster --config $SCAFFOLDING_DIR/config/kind/cluster.yaml &&
    echo "✨ Cluster ${CLUSTER} created successfully")