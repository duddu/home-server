#!/bin/bash

set -e
set -u
: "${1:?Bump increment argument not provided}"

cd "${0%/*}"
cd ..

current_version=$(grep -oe 'version = "[^"]*' Cargo.toml | head -1 | cut -c12-) ;\
new_version=$(semver bump $1 $current_version) ;\
sed -i '' -E "s/version = \"${current_version}\"/version = \"${new_version}\"/g" Cargo.toml ;\
cargo check
printf "${new_version}" > VERSION
echo "✅ rust-api version bumped from ${current_version} to ${new_version}"