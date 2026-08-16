#!/usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# Removes neovim nightly. <rbt 2025-08-15>

set +o braceexpand

set -o noglob
set -o errexit
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

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

sudo rm -rf "/opt/nvim-linux-$arch/"
