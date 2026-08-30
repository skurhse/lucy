#!/usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# REQ: Installs a go binary release. <mse 2026-07-12>

# SEE: https://go.dev/doc/install <>
# SEE: https://go.dev/dl/ <>

set +o braceexpand

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o pipefail
set -o xtrace

readonly arch='amd64'
readonly version='1.26.5'
readonly os='darwin'

readonly checksum='6231d8d3b8f5552ec6cbf6d685bdd5482e1e703214b120e89b3bf0d7bf1ef725'

# readonly checksum='77e5da33bb72aeaef1ba4418b6fe511bc4d041873cbf82e5aa6318740df98717'

readonly archive="go$version.$os-$arch.tar.gz"

readonly url="https://golang.org/dl/$archive"

readonly path='/usr/local/go'
readonly profile=~/'.bash_profile'

export=(export "PATH=\"\$PATH:$path/bin\"")

dir=$(dirname "$path")

cd /tmp

wget --timestamping "$url"

sha256sum --check <<<"$checksum $archive"

sudo rm -rf "$path"

sudo tar --extract --gunzip --directory "$dir" --file "$archive"

if ! grep --quiet --line-regexp --fixed-strings -- "${export[*]}" "$profile"
then
  printf "\n${export[*]}\n" >> "$profile"
fi

eval ${export[@]}

go version
