#!/bin/zsh

set -e
set -u
: "${USER:?Variable not set or empty}"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME=/Users/$USER

SCAFFOLDING_LOCAL_DIR=/Users/Shared/.podman_volumes/scaffolding

if [ -n "$RAW_GITHUB_PATH" ]
then
  INIT_PATH=$RAW_GITHUB_PATH
  run_init_script () {
    zsh <(curl -s "$INIT_PATH/scripts/$1.sh")
  }
else
  INIT_PATH=$SCAFFOLDING_LOCAL_DIR
  run_init_script () {
    zsh "$INIT_PATH/scripts/$1.sh"
  }
fi

# run part of the block also if machine/cluster config changed
# (save hashes before running scaffolding job)
if [ "${1:-}" = "--restart-vm" ]
then
  echo "⏳ Recreating virtual machine and cluster..."
  run_init_script kind/cluster-delete
  run_init_script podman/machine-rm
  run_init_script podman/machine-start
  run_init_script kind/cluster-create
fi
run_init_script podman/machine-start
run_init_script kind/cluster-create

echo "⏳ Preparing scaffolding job..."
kubectl apply -f ${INIT_PATH}/config/k8s/namespaces/home-server.yaml
kubectl config set-context --current --namespace=home-server
kubectl apply -f ${INIT_PATH}/config/k8s/volumes/nfs-pv.yaml
kubectl apply -f ${INIT_PATH}/config/k8s/volumes/nfs-pvc.yaml
kubectl apply -f ${INIT_PATH}/config/k8s/jobs/scaffolding.yaml
echo "⏳ Waiting for scaffolding job to complete..."
kubectl wait --for=condition=complete --timeout=180s job home-server-scaffolding ||
  (kubectl logs job/home-server-scaffolding && exit 1)
echo "🚀 Scaffolding job completed"

cd $SCAFFOLDING_LOCAL_DIR

kube_wait_pod () {
  kubectl wait --for=condition=ContainersReady --timeout=240s pod -l app=$1 ||
    (kubectl get deployments && kubectl describe pod -l app=$1 && exit 1)
}

echo "⏳ Preparing deployments..."
kubectl apply -f ./config/k8s/secrets
kubectl apply -f ./config/k8s/namespaces
kubectl apply -f ./config/k8s/volumes
kubectl apply -f ./config/k8s/cronjobs
kubectl apply -f ./config/k8s/deployments
echo "⏳ Waiting for pods..."
sleep 5
kube_wait_pod home-server-daemons
kube_wait_pod home-server
kubectl apply -f ./config/k8s/services
echo "🚀 Pods ready"