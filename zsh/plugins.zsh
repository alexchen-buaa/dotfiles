# antigen plugins
source /usr/local/share/antigen/antigen.zsh

antigen bundle zsh-users/zsh-autosuggestions

# zsh-syntax-highlighting prefer manual installation

antigen apply

# non-antigen plugins

# manual installation of zsh-syntax-highlighting
# this must be at the end of .zshrc file
# so is the whole file
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# ctrl-y to accept autosuggestions
bindkey '^y' autosuggest-accept
