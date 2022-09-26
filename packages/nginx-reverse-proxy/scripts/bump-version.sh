#!/bin/bash

set -e
set -u
: "${1:?Bump increment argument not provided}"

cd "${0%/*}"
cd ..

current_version=$(grep -oe '"version":"[^"]*' nginx.conf | cut -c12-)
new_version=$(semver bump $1 $current_version)
sed -i '' -E "s/\"version\":\"${current_version}\"/\"version\":\"${new_version}\"/g" nginx.conf
printf "${new_version}" > VERSION
echo "✅ nginx-reverse-proxy version bumped from ${current_version} to ${new_version}"