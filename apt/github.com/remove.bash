#!/usr/bin/env bash

# REQ: Removes the github command line interface. <>

set +o braceexpand

set -o errexit
set -o noclobber
set -o noglob
set -o nounset
set -o xtrace

sudo apt-get remove --assume-yes gh

keyring='/etc/apt/keyrings/githubcli-archive-keyring.gpg'
file='/etc/apt/sources.list.d/githubcli.sources'

sudo rm --force --verbose "$file"
sudo apt-get update

sudo rm --force --verbose "$keyring" "$file"
