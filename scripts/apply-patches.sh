#!/usr/bin/env bash

type=$1

set -euo pipefail

if [[ -z "$type" ]]; then
    echo "Error: patchset type required"
    exit 1
fi

if [[ "$type" == "vanilla" ]]; then
    patches=""
fi

if [[ "$type" == "highload"  ]]; then
    rm patches/010-use-redis-for-video-cache.patch
    patches=$(ls patches/*.patch)
fi

if [[ "$type" == "redis" ]]; then
    patches=$(ls patches/*.patch)
fi


for patch in $patches; do
    echo "Applying patch: $patch"
    git apply "$patch" --directory invidious
done