#!/bin/bash

set -e

cd "${0%/*}"

CLUSTER=home-server

(kind get clusters | grep -q $CLUSTER &&
  echo "⏭ Cluster ${CLUSTER} already exists") ||
  (echo "⏳ Creating cluster ${CLUSTER}..." &&
    kind create cluster --config ../../config/kind/cluster.yaml &&
    echo "✨ Cluster ${CLUSTER} created successfully")