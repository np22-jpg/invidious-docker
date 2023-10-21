#!/usr/bin/env bash

set -euo pipefail

# Get the actual version history for invidious
rm invidious/.git 
cp .git/modules/invidious/ invidious/.git -r
