_init() {
	export PS1='\W \u$ '

	local src_paths
	mapfile -td: src_paths <<<$PATH

	readonly local trg_paths=(
		/usr/local/opt/{gnu-sed,coreutils}/libexec/gnubin
		/opt/nvim-linux-x86_64/bin
	)
	
	local found
	for t in "${trg_paths[@]}"
	do
		found=false
		for s in "${src_paths[@]}"
		do
			if [[ $s == $t ]]
			then
				found=true && break
			fi
		done
		[[ $found == true ]] && break
		
		PATH+=":$t"
	done

	readonly local aliases=(
		vi=nvim
		vim=nvim
	)
	for a in "${aliases[@]}"
	do
		alias "$a"
	done
}
_init
unset _init
