#!/bin/bash

set -e
set -u
: "${1:?Bump increment argument not provided}"

cd "${0%/*}"
cd ..

current_version=$(cat VERSION)
new_version=$(semver bump $1 $current_version)
sed -i '' -E "s/monero:${current_version}/monero:${new_version}/g" ../../config/k8s/deployments/daemons.yaml
printf "${new_version}" > VERSION
echo "✅ monero version bumped from ${current_version} to ${new_version}"