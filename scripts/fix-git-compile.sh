#!/usr/bin/env bash

set -euo pipefail

# Get the actual version history for invidious
# If invidious/.git is a file, it's a git submodule
# If it's a directory, it's a git repo
if [[ -f invidious/.git ]]; then
    rm invidious/.git
    cp .git/modules/invidious/ invidious/.git -r
fi