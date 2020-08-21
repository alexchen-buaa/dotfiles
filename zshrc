bindkey -v
export TERM=xterm-256color
# export PATH="/Users/alexchen/anaconda3/bin:$PATH"  # commented out by conda initialize
export PATH="/Users/alexchen/ffmpeg/bin:$PATH"
#export PATH="/Users/alexchen/anaconda3/lib/graphviz:$PATH"
autoload -U colors && colors
export PS1="%{$fg[cyan]%}%1~ %{$reset_color%}%#%{$fg[green]%} >>>%{$reset_color%} "
export HOMEBREW_NO_AUTO_UPDATE=true
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
export PYTHONSTARTUP=~/.pythonrc
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

alias ls='exa'
alias la='exa -a'
alias ll='exa -lha'
alias home='cd ~'
export EDITOR=nvim
export LC_CTYPE='zh_CN.UTF-8'
export LANG='en_US.UTF-8'

lever(){
	if [[ $# -eq 0 ]]
	then
		python ~/local/toolbox/lever/lever.py
	elif [ $1 = "pull" ]
	then
		python ~/local/toolbox/lever/pull.py
	fi
}

# antigen support
source /usr/local/share/antigen/antigen.zsh

antigen bundle zsh-users/zsh-autosuggestions

# as the last bundle!
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/alexchen/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/alexchen/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/alexchen/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/alexchen/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# broot
source /Users/alexchen/Library/Preferences/org.dystroy.broot/launcher/bash/br

# the fuck
eval $(thefuck --alias)

# old plugins
#source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#bindkey '^y' autosuggest-accept
#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
