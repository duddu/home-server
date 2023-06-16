#!/bin/zsh

set -e
set -u
: "${USER:?Variable not set or empty}"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME="/Users/$USER"
local REPO="git@github.com:duddu/home-server.git"
local CLONE_DIR="$HOME/.home-server"

prepare_dir () {
  echo "⏳ Preparing directory..."
  rm -rf $CLONE_DIR
  mkdir -p $CLONE_DIR
  cd $CLONE_DIR
  git clone -q --depth=1 --no-checkout --filter=blob:none $REPO .
  git sparse-checkout set --no-cone \
    .git-crypt \
    .gitattributes \
    'config/**' \
    'packages/**/VERSION' \
    'scripts/**'
  git reset --hard ${GIT_REF:-origin/main}
  git-crypt unlock
  printf $(git rev-parse HEAD) > COMMIT_SHA
  rm -rf .git*
}

run_script () {
  zsh $CLONE_DIR/scripts/$1.sh
}

prepare_cluster () {
  if [ "${1:-}" = "--restart-vm" ]
  then
    echo "⏳ Recreating virtual machine and cluster..."
    run_script kind/cluster-delete
    run_script docker/stop
  fi
  if ! kubectl get nodes | grep -q Ready
  then
    run_script docker/start
    run_script kind/cluster-create
  fi
}

apply_k8s_resources () {
  for version in $CLONE_DIR/packages/**/VERSION(.); do
    local package=$(printf $version | cut -d / -f 6 | sed 's/-/_/g' | tr a-z A-Z)
    export declare ${package}_VERSION=$(cat $version)
  done

  echo "⏳ Preparing resources..."
  cd $CLONE_DIR/config/k8s
  kubectl config set-context --current --namespace=home-server
  envsubst < kustomization.tmpl.yaml > kustomization.yaml
  kubectl apply -k .

  echo "⏳ Waiting for pods..."
  sleep 5
  kubectl wait --for=condition=Available --timeout=300s deployments --all &&
    kubectl wait --for=condition=ContainersReady --field-selector=spec.restartPolicy=Always --timeout=180s pods &&
    kubectl get -f $CLONE_DIR/config/k8s/cronjobs ||
    (kubectl describe pods ; kubectl describe cronjobs.batch ; exit 1)
  echo "🚀 Pods ready"
}

prepare_dir
prepare_cluster
apply_k8s_resources