#!/bin/bash

set -e
set -u
: "${1:?Bump increment argument not provided}"

cd "${0%/*}"
cd ..

current_version=$(cat VERSION)
new_version=$(semver bump $1 $current_version)
printf "${new_version}" > VERSION
echo "✅ scaffolding version bumped from ${current_version} to ${new_version}"