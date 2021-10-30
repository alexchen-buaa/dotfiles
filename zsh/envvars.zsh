# vi-mode editing
bindkey -v

# term declaration
export TERM=xterm-256color

# ffmpeg installation
export PATH="/Users/alexchen/ffmpeg/bin:$PATH"

# conda PATH
export PATH="/anaconda3/bin:$PATH"

# -
autoload -U colors && colors

# switch brew source to TUNA
export HOMEBREW_NO_AUTO_UPDATE=true
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

# clang
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# python REPL setting
export PYTHONSTARTUP=~/.pythonrc

# editor
export EDITOR=/usr/local/bin/nvim

# locale
export LC_CTYPE='zh_CN.UTF-8'
export LANG='en_US.UTF-8'

# tp installation
export TP_INSTALL='/Users/alexchen/toolbox/tp'

# fzf config
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi
export FZF_CTRL_R_OPTS='--sort --exact'
