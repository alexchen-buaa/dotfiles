# vi-mode editing
bindkey -v

# term declaration
export TERM=xterm-256color

# ffmpeg installation
export PATH="/Users/alexchen/ffmpeg/bin:$PATH"

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
export EDITOR=nvim

# locale
export LC_CTYPE='zh_CN.UTF-8'
export LANG='en_US.UTF-8'
