# environmental variables
source ~/.zsh/envvars.zsh

# prompt
source ~/.zsh/prompt.zsh

# command-line tools
source ~/.zsh/clitools.zsh

# aliases
source ~/.zsh/aliases.zsh

# functions
source ~/.zsh/functions.zsh

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

# plugins
source ~/.zsh/plugins.zsh
