lever(){
	if [[ $# -eq 0 ]]
	then
		python ~/local/toolbox/lever/lever.py
	elif [ $1 = "pull" ]
	then
		python ~/local/toolbox/lever/pull.py
	fi
}

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
