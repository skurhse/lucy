#!/usr/bin/env bash

# REQ: Installs the NodeSource APT repository and signing key. <skr 2023-04-05> 

# SEE: https://nodejs.org/en/download/package-manager#debian-and-ubuntu-based-linux-distributions <>

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set +o braceexpand
set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

source /etc/os-release

declare -A key
key[server]=https://deb.nodesource.com/gpgkey/nodesource.gpg.key
key[ring]=/etc/apt/keyrings/nodesource.gpg
key[fingerprint]=9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280

declare -A src
src[archive_type]=deb
src[architecture]=$(dpkg --print-architecture)
src[signed-by]=${key[ring]}
src[repository_url]=https://deb.nodesource.com/node_18.x
src[distribution]=$VERSION_CODENAME
src[component]=main

readonly list=/etc/apt/sources.list.d/nodesource.list

gpg --version

sudo gpg \
  --no-default-keyring                     \
  --keyring            ${key[ring]}        \
  --keyserver          ${key[server]}      \
  --recv-keys          ${key[fingerprint]}

entry=${src[archive_type]}
entry+=" [arch=${src[architecture]} signed-by=${src[signed-by]}]"
entry+=" ${src[repository_url]}"
entry+=" ${src[distribution]}"
entry+=" ${src[component]}"

sudo bash -c "echo ${entry@Q} > ${list@Q}"

sudo apt-get update
