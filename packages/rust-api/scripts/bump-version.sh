#!/bin/bash

set -e
set -u
: "${1:?Bump increment argument not provided}"

cd "${0%/*}"
cd ..

current_version=$(cat VERSION)
new_version=$(semver bump $1 $current_version)
sed -i '' -E "s/version = \"${current_version}\"/version = \"${new_version}\"/g" Cargo.toml
cargo check
sed -i '' -E "s/\/${current_version}\"/\/${new_version}\"/g" Rocket.toml
sed -i '' -E "s/rust-api:${current_version}/rust-api:${new_version}/g" ../../config/k8s/deployments/web.yaml
printf "${new_version}" > VERSION
echo "✅ rust-api version bumped from ${current_version} to ${new_version}"