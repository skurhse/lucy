#! /usr/bin/env bash

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# REQ: Bash profile for macOS Catalina 10.5.8. <Jannah 2026-10-03>

function _sdk {
  # NOTE: Xcode 12.4 <>
  readonly SDKVERS='11.1'

  export SDKROOT="/Library/Developer/CommandLineTools/SDKs/MacOSX$SDKVERS.sdk"
}
_sdk; unset -f _sdk

function _perl {
  # NOTE:
  # - `PERl5LIB`
  # - `PERL_MM_OPT`/`PERL_MB_OPT`
  # - `PERL_LOCAL_LIB_ROOT`
  # <>
  eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"
}
_perl; unset -f _perl

function _brew {
	local product_version
	product_version=$(sw_vers -productVersion)
	
	if [[ $? -eq 0 && -n $product_version ]]
  then 
		export HOMEBREW_MACOS_VERSION="$product_version"
	fi

	export HOMEBREW_NO_AUTO_UPDATE=1
	export HOMEBREW_NO_INSTALL_FROM_API=1

  if [[ -n "$SDKROOT" ]]; then
    export HOMEBREW_SDKROOT="$SDKROOT"
  fi

	if command -v bat > /dev/null
	then
		export HOMEBREW_BAT=1
		if [[ -n "$BAT_CONFIG_PATH" ]]
		then
			export HOMEBREW_BAT_CONFIG_PATH="$BAT_CONFIG_PATH"
		fi
	fi
}
_brew; unset -f _brew

function _clang {
  export MACOSX_DEPLOYMENT_TARGET='10.15'

	local -ar flags=(
		# '-march=nehalem'
		'-mmacosx-version-min=10.15'
		'-isysroot' '/Library/Developer/CommandLineTools/SDKs/MacOSX11.1.sdk'
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
_clang; unset -f _clang

_term() {
  export PS1='\W$ '

  export HISTSIZE=32768
  export HISTFILESIZE=32738
  export HISTTIMEFORMAT='%F %T'

  shopt -s histappend
}
_term; unset -f _term

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
		'range-diff' 'rebase' 'remote' 'restore' 'revert'
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
		'grep' 'help'
		'reset' 'rm'
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
_init; unset -f _init
