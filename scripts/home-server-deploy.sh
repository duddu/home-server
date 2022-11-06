#!/bin/zsh

set -e
set -u
: "${USER:?Variable not set or empty}"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME=/Users/$USER
export USER

SCAFFOLDING_DIR=/Users/Shared/.podman_volumes/scaffolding

cd $SCAFFOLDING_DIR

zsh ./scripts/podman/machine-start.sh
zsh ./scripts/kind/cluster-create.sh

echo "⏳ Preparing home-server-scaffolding job..."
kubectl apply -f ./config/k8s/namespaces
kubectl config set-context --current --namespace=home-server
kubectl apply -f ./config/k8s/volumes
kubectl apply -f ./config/k8s/jobs
echo "⏳ Waiting for home-server-scaffolding job to complete..."
kubectl wait --for=condition=complete --timeout=180s job/home-server-scaffolding
echo "🚀 Job home-server-scaffolding completed"

if [ "${1:-}" = "--restart-vm" ]
then
  echo "⏳ Recreating virtual machine and cluster..."
  zsh ./scripts/kind/cluster-delete.sh
  zsh ./scripts/podman/machine-rm.sh
  zsh ./scripts/podman/machine-start.sh
  zsh ./scripts/kind/cluster-create.sh
fi

echo "⏳ Preparing deployments..."
kubectl apply -f ./config/k8s/namespaces
kubectl apply -f ./config/k8s/volumes
kubectl apply -f ./config/k8s/secrets
kubectl apply -f ./config/k8s/deployments
kubectl wait --for=condition=Ready --timeout=180s pods -l app=home-server-daemons
kubectl wait --for=condition=Ready --timeout=180s pods -l app=home-server
kubectl apply -f ./config/k8s/services
echo "🚀 Deployments ready"