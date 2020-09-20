# this comes from wuwe1's dotfiles
bing(){
    	if [[ $# -eq 0 ]];then
        	echo "query required"
        	return 1
    	elif [[ $# -eq 1 ]];then
        	query=$1
    	else
        	IFS='+'
        	query="'$*'"
    	fi
    	curl -s "https://cn.bing.com/dict/($query)?mkt=zh-CN&setlang=ZH" | pup '.qdef > ul text{}'
}

# this too comes from wuwe1's dotfiles
up()
{
    	local cdir="$(pwd)"
    	if [[ "${1}" == "" ]]; then
        	cdir="$(dirname "${cdir}")"
    	elif ! [[ "${1}" =~ ^[0-9]+$ ]]; then
        	echo "Error: argument must be a number"
    	elif ! [[ "${1}" -gt "0" ]]; then
        	echo "Error: argument must be positive"
    	else
        	for ((i=0; i<${1}; i++)); do
            		local ncdir="$(dirname "${cdir}")"
            		if [[ "${cdir}" == "${ncdir}" ]]; then
                		break
            		else
                		cdir="${ncdir}"
            		fi
        	done
    	fi
    	cd "${cdir}"
}

# if python3 doesn't work in tmux, do this
rea(){
	conda deactivate
	conda activate base
}

# I adopted this from Sidney Liebrand's dotfiles
bip(){
	local inst=$(brew search | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[brew:install]'")

	if [[ $inst ]]; then
	  for prog in $(echo $inst)
	  do brew install $prog
	  done
	fi
}

bup(){
	local upd=$(brew leaves | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[brew:update]'")

	if [[ $upd ]]; then
	  for prog in $(echo $upd)
	  do brew upgrade $prog
	  done
	fi
}

bcp(){
	local uninst=$(brew leaves | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[brew:clean]'")

	if [[ $uninst ]]; then
	  for prog in $(echo $uninst)
	  do brew uninstall $prog
	  done
	fi
}

op(){
	open $(fd --hidden -t f | fzf) 2> /dev/null
}
