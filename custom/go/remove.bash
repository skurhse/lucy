#!/usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# REQ: Removes the go binary release. <rbt 2025-04-28>

set +o braceexpand

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

readonly path='/usr/local/go'
readonly profile=~/'.bash_profile'

export=(export "PATH=\"\$PATH:$path/bin\"")

sudo rm -rf "$path"

safe=$(sed 's|/|\\&|g' <<<${export[*]})

sed --in-place "/^$safe$/d" "$profile"


