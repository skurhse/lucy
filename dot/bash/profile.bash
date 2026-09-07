#! /usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# REQ: Bash profile for macOS Catalina 10.5.8. <eris>

function setup_brew {
	local product_version
	product_version=$(sw_vers -productVersion)
	
	if [[ $? -eq 0 && -n $product_version ]]; then 
		export HOMEBREW_MACOS_VERSION="$product_version"
	fi

	export HOMEBREW_NO_AUTO_UPDATE=1
	export HOMEBREW_NO_INSTALL_FROM_API=1

	if command -v bat > /dev/null
	then
		export HOMEBREW_BAT=1
		if [[ -z "$BAT_CONFIG_PATH" ]]
		then
			export HOMEBREW_BAT_CONFIG_PATH="$BAT_CONFIG_PATH"
		fi
	fi
}
setup_brew

function setup_clang {
	local -ar flags=(
		'-march=nehalem'
		'-macosx-version-min=10.15'
		'isysroot' '/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk'
	)

	local -ar c_flags=(
		'-Os' '-w' '-pipe'
		"${flags[@]}"
	)

	# Compiler
	export CC="/usr/local/opt/llvm/bin/clang"
	export CFLAGS="${c_flags[*]}"

	export CXX="/usr/local/opt/llvm/bin/clang++"
	export CXXFLAGS="${c_flags[*]}"

	# Preprocessor
	export CPPFLAGS="-I/usr/local/opt/freetype/include/freetype2"

	# Linker
	export LDFLAGS="${flags[*]}"
}
setup_clang

export PS1='\W \u$ '

export HISTSIZE=32768
export HISTFILESIZE=32738
export HISTTIMEFORMAT='%F %T'

shopt -s histappend

_init() {

	local src_paths
	mapfile -td: src_paths <<<$PATH
	readonly src_paths

	local -r trg_paths=(
		'/usr/local/opt/{gnu-sed,coreutils}/libexec/gnubin'
    		'/usr/local/opt/llvm/bin'
		'/opt/nvim-linux-x86_64/bin'
	)
	
	local found t
	for t in "${trg_paths[@]}"
	do
		found=false
		for s in "${src_paths[@]}"
		do
			if [[ $s == $t ]]
			then
				found=true
				break
			fi
		done
		if [[ $found == true ]]
		then
			break
		fi
		
		PATH="$t:$PATH"
	done
	unset found t

	local a
	for a in vi vim
	do
		alias $a=nvim
	done
	unset a

	local -r git_aliases=(
		'add' 'am' 'apply' 'archive' 
		'backfill' 'bisect' 'blame' 'branch' 'bundle'
		'clone' 'checkout' 'cherry-pick' 'commit' 'config'
		'describe'
		'fetch' 'format-patch'
		'gc'
		'init'
		'log'
		'maintenance' 'merge' 'merge-base' 'mv'
		'notes'
		'pull' 'push'
		'range-diff' 'rebase' 'reset' 'remote' 'restore' 'revert'
		'reflog' 'refs' 'rev-parse' 'rev-list'
		'show' 'stash' 'status' 'submodule'
		'tag'
		'worktree'
	)

	local a
	for a in "${git_aliases[@]}"
	do
		alias "$a=git $a"
	done
	unset a

	local -r ggit_aliases=(
		'clean'
		'diff'
		'grep'
		'help'
		'rm'
		'switch'
		'version'
	)

	local a
	for a in "${ggit_aliases[@]}"
	do
		alias "g$a=git $a"
	done
  unset a

	local s
	for s in $(
		find ~/src -type d -depth 1 -execdir basename '{}' ';'
	)
	do
		alias "$s=cd ~/src/${s@Q}"
	done
  unset s
}
_init
unset -f _init
