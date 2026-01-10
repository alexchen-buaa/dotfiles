# Tool Initialization, Aliases, and Functions

## Aliases

# Enhanced replacements
alias ls='eza'
alias la='eza -a'
alias ll='eza -lha'
alias vi='nvim'
alias tldr='tldr -t base16'

# Safe defaults (prevent overwriting)
alias cp='cp -i'
alias mv='mv -i'

## Functions

# yazi - change directory on exit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

## Tool Inits

# fzf
source <(fzf --zsh)

# starship prompt
eval "$(starship init zsh)"

## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/alexchen/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/alexchen/miniconda3/etc/profile.d/conda.sh" ]; then
	. "/Users/alexchen/miniconda3/etc/profile.d/conda.sh"
    else
	export PATH="/Users/alexchen/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
## <<< conda initialize <<<

# zoxide
eval "$(zoxide init zsh)"
