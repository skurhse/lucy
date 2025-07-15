#!/usr/bin/env bash

# REQ: Installs the Helm source entry, signing key & package. <rbt 2023-10-16>

# SEE: https://helm.sh/docs/intro/install/#from-apt-debianubuntu <>

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

keyserver=https://baltocdn.com/helm/signing.asc
fingerprint=81BF832E2F19CD2AA0471959294AC4827C1A168A

arch=$(dpkg --print-architecture)
keyring=/etc/apt/keyrings/helm.gpg
repo=https://baltocdn.com/helm/stable/debian/
distro=all
component=main
entry="deb [arch=$arch signed-by=$keyring] $repo $distro $component"
list=/etc/apt/sources.list.d/helm.list

sudo gpg --no-default-keyring --keyring "$keyring" \
  --keyserver "$keyserver" --recv-keys "$fingerprint"

sudo bash -c "echo ${entry@Q} > ${list@Q}"

sudo apt-get update
sudo apt-get install helm

helm version
