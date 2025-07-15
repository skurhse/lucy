#!/usr/bin/env bash

# REQ: Uninstalls the Helm source entry, signing key & package. <rbt 2023-10-16>

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

keyring=/etc/apt/keyrings/helm.gpg
list=/etc/apt/sources.list.d/helm.list

sudo apt-get remove --yes helm

sudo rm -f "$list" "$keyring"
