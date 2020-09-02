# this file sources non-plugin cli programs
# like br, thefuck etc.

# broot
source /Users/alexchen/Library/Preferences/org.dystroy.broot/launcher/bash/br

# the fuck
eval $(thefuck --alias)

# autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# ffmpeg, you can change the path to wherever you like
export PATH="/Users/alexchen/ffmpeg/bin:$PATH"

# lever
source ~/toolbox/lever/lever.zsh

# tp
source ~/toolbox/tp/tp.zsh

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
