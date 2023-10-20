#!/usr/bin/env bash

set -euo pipefail

patches=$(ls patches/*.patch)

# Get the actual version history for invidious
rm invidious/.git 
cp .git/modules/invidious/ invidious/.git -r

for patch in $patches; do
    echo "Applying patch: $patch"
    git apply "$patch" --directory invidious
done