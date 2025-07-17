#!/usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# REQ: Installs node version manager. <>

# SEE: https://github.com/nvm-sh/nvm#manual-install <>

set +o braceexpand

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o xtrace

dir=~/'.nvm'
profile=~/'.profile'
repo='https://github.com/nvm-sh/nvm.git'

rm --recursive --force "$dir"
mkdir --parents "$dir"
cd "$dir"

git init .
git remote add origin "$repo"
git fetch origin 'refs/tags/*:refs/tags/*'

tag=$(
  git rev-list \
    --max-count=1 \
    --tags \
  --
)

match=$(
  git describe \
    --abbrev=0 \
    --match "v[0-9].[0-9]*.[0-9]*" \
    --tags \
  -- "$tag"
)

git switch --detach "$match"

set +o xtrace
source "$dir/nvm.sh"
nvm --version
set -o xtrace

while read -r line 
do
  
done <
