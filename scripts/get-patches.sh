#!/usr/bin/env bash

set -euo pipefail

if [ ! -d patches ]; then
    mkdir patches
fi

cp invidious-custom/patches/*.patch patches/
cp invidious-custom/patches-api/*.patch patches/

if [ -d custom-patches ]; then
    cp custom-patches/*.patch patches/
fi


# Always remove patches specfic to yewtu.be
rm patches/003-proxy-csp.patch
rm patches/004-donate-page.patch
rm patches/007-range-header.patch
rm patches/009-restrict-playback.patch
rm patches/020-use-separate-domain-for-webhook-requests.patch
rm patches/021-message-registration.patch