#!/bin/zsh

set -e

CLUSTER=home-server

kind get clusters | grep -q $CLUSTER &&
  kind delete cluster -n $CLUSTER &&
    echo "🗑 Cluster ${CLUSTER} deleted successfully" ||
  echo "⏭ Cluster ${CLUSTER} is not active"