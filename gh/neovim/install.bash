#!/usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# REQ: Installs neovim nightly. <rbt 2026-08-15>

# SEE: https://github.com/neovim/neovim/blob/master/INSTALL.md#linux <>

set +o braceexpand

set -o noglob
set -o errexit
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

readonly repo='neovim/neovim'

readonly tag='nightly'

if type gh
then
  if ! gh --version
  then
    exit $PIPESTATUS
  fi
else
  exit $?
fi

if type dpkg
then
  arch=$(dpkg --print-architecture)

  case $arch in
    amd64)
      arch=x86_64
      ;;
    arm64)
      ;;
    *)
      exit 
      ;;
  esac
else
  if type uname 
  then
    arch=$(uname -m)
  else
    exit $?
  fi
fi

readonly archive="nvim-linux-$arch.tar.gz"

cd /tmp

readonly digest=$(
  gh release view "$tag" \
    --repo "$repo" \
    --json 'assets' \
    --jq ".assets[]|select(.name==$(printf "$archive" | jq -R .)).digest"
)

gh release download "$tag" \
  --repo "$repo" \
  --pattern "$archive" \
  --clobber

echo "${digest#sha256:} $archive" | sha256sum --check

sudo rm -rf "/opt/nvim-linux-$arch/"

sudo tar \
  -C /opt \
  -xzf "nvim-linux-$arch.tar.gz" \

readonly export=(export "PATH=\"\$PATH\":/opt/nvim-linux-$arch/bin")

if ! grep \
  --quiet \
  --line-regexp \
  --fixed-strings \
-- "${export[*]}" ~/'.bash_profile'
then
  printf "\n${export[*]}\n" >> ~/'.bash_profile'
fi

eval "${export[@]}"

nvim -V1 --version
