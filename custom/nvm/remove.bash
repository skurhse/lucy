#!/usr/bin/env bash

# REQ: Removes node version manager. <>

set -o xtrace

dir=~/'.nvm'

nvm unload
rm --recursive --force "$dir"
