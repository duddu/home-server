#!/bin/bash

set -e
set -u
: "${1:?Bump increment argument not provided}"

cd "${0%/*}"
cd ..

current_version=$(cat VERSION)
new_version=$(semver bump $1 $current_version)
sed -i '' -E "s/google-ddns:${current_version}/google-ddns:${new_version}/g" ../../config/k8s/cronjobs/google-ddns.yaml
printf "${new_version}" > VERSION
echo "✅ google-ddns version bumped from ${current_version} to ${new_version}"