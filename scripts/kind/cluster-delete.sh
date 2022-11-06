#!/bin/bash

set -e

CLUSTER=home-server

kind delete cluster -n $CLUSTER &> /dev/null &&
  echo "🗑 Cluster ${CLUSTER} deleted successfully" ||
  echo "⏭ Cluster ${CLUSTER} is not active"