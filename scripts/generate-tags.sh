#!/usr/bin/env bash

set -euo pipefail

distro=$1
patchset=$2
arch=$3

TIMESTAMP="$(date +%Y%m%d)"

PRE_BUILD_TAGS=("${distro}")

# Set arch tags
if [ "$arch" == "linux/amd64" ]; then
  arch_tag="amd64"
elif [ "$arch" == "linux/arm64" ]; then
  arch_tag="arm64"
elif [ "$arch" == "linux/arm/v7" ]; then
  arch_tag="armv7"
elif [ "$arch" == "linux/ppc64le" ]; then
  arch_tag="ppc64le"
else
  echo "Unknown arch: $arch"
  exit 1
fi

# Append patchset type to each entry in PRE_BUILD_TAGS
for TAG in "${PRE_BUILD_TAGS[@]}"; do
  PRE_BUILD_TAGS=("${TAG}-${patchset}")
done

# Create the scenario for a "latest" build
if [ "$distro" == "alpine" ]; then
  PRE_BUILD_TAGS+=("latest")
fi

if [ "$patchset" == "vanilla" ]; then
  PRE_BUILD_TAGS+=("${TAG}")
fi

if [ "$arch_tag" == "amd64" ]; then
  BUILD_TAGS=("${PRE_BUILD_TAGS[@]}")
  for TAG in "${BUILD_TAGS[@]}"; do
    BUILD_TAGS+=("${TAG}-${arch_tag}")
  done
else
  for TAG in "${PRE_BUILD_TAGS[@]}"; do
    BUILD_TAGS+=("${TAG}-${arch_tag}")
  done
fi

# Append matching timestamp tags to keep a version history
for TAG in "${BUILD_TAGS[@]}"; do
  BUILD_TAGS+=("${TAG}-${TIMESTAMP}")
done

# echo "Generated the following build tags: "
for TAG in "${BUILD_TAGS[@]}"; do
  echo "${TAG}"
done
