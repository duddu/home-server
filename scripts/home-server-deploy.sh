#!/bin/zsh

set -e
set -u
: "${USER:?Variable not set or empty}"
: "${GIT_REF:-main}"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export HOME="/Users/$USER"
export GIT_REF

clone_sparse_checkout () {
  git clone -q --depth=1 --no-checkout --filter=blob:none git@github.com:duddu/home-server.git . > /dev/null
  git sparse-checkout set --no-cone \
    .git-crypt \
    .gitattributes \
    'config/**' \
    'packages/**/VERSION' \
    'scripts/**'
  git reset --hard $GIT_REF
}

local CLONE_DIR="$HOME/.home-server"
rm -rf $CLONE_DIR
mkdir -p $CLONE_DIR
cd $CLONE_DIR
clone_sparse_checkout
git-crypt unlock
export COMMIT_SHA=$(git rev-parse HEAD)
printf $COMMIT_SHA > COMMIT_SHA
rm -rf .git*

run_script () {
  zsh ./scripts/$1.sh
}

# run part of the block also if machine/cluster config changed
# (save hashes before running sparse checkout)
if [ "${1:-}" = "--restart-vm" ]
then
  echo "⏳ Recreating virtual machine and cluster..."
  run_script kind/cluster-delete
  run_script docker/stop
fi
run_script docker/start
run_script kind/cluster-create

for version in ./packages/**/VERSION(.); do
  local package=$(printf $version | cut -d / -f 3 | sed 's/-/_/g' | tr a-z A-Z)
  export declare ${package}_VERSION=$(cat $version)
done

echo "⏳ Preparing resources..."
cd ./config/k8s
kubectl config set-context --current --namespace=home-server
envsubst < kustomization.tmpl.yaml > kustomization.yaml
kubectl apply -k .
echo "⏳ Waiting for pods..."
sleep 3
kubectl wait --for=condition=Available --timeout=240s deployments --all &&
  kubectl wait --for=condition=ContainersReady --field-selector=spec.restartPolicy=Always --timeout=120s pods ||
  (kubectl get deployments ; kubectl describe pods ; exit 1)
echo "🚀 Pods ready"