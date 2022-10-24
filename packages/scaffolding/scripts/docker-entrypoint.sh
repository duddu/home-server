#!/bin/sh

set -e

git stash -q
git-crypt unlock
git stash pop -q
rm -rf .git*
"$@"