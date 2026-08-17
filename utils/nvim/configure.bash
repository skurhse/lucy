#!/usr/bin/env bash

# REQ: Installs init.lua via symlink. <eris>

# SEE: https://neovim.io/doc/user/lua-guide.html <> 

set +o braceexpand

set -o errexit
set -o noglob
set -o noclobber
set -o nounset
set -o pipefail
set -o xtrace

readonly cfg_dir=~/.config/nvim/

src_dir=$(dirname "$BASH_SOURCE")

src_dir=$(realpath "$src_dir")
readonly src_dir

src_file="$src_dir/init.lua" 
readonly src_file

mkdir -pv "$cfg_dir"

ln -fs "$src_file" "$cfg_dir"
