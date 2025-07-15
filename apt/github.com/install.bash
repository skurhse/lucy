#!/usr/bin/env bash

# REQ: Installs the github command line interface. <rbt 2025-07>

# SEE: https://github.com/cli/cli/blob/trunk/docs/install_linux.md <>

set +o braceexpand

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o xtrace

keyserver='https://cli.github.com/packages/githubcli-archive-keyring.gpg'
keyring='/etc/apt/keyrings/githubcli-archive-keyring.gpg'
fingerprint='2C6106201985B60E6C7AC87323F3D4EA75716059'

arch="$(dpkg --print-architecture)"
file='/etc/apt/sources.list.d/githubcli.sources'

entry="Types: deb
URIs: https://cli.github.com/packages
Suites: stable
Components: main
Enabled: yes
Signed-By: $keyring
Architectures: $arch"

path=$(realpath "$BASH_SOURCE")
dir=$(dirname "$path")
cd "$dir"

sudo gpg \
  --no-default-keyring \
  --keyring "gnupg-ring:$keyring" \
  --keyserver "$keyserver" \
  --recv-keys "$fingerprint" 

# NOTE: Must be readable by sandbox user '_apt'. <>
sudo chmod 444 "$keyring"

sudo bash -c "echo ${entry@Q} > ${file@Q}"

sudo apt-get update
sudo apt-get install --assume-yes gh

gh --version
