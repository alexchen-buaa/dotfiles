# Plugin Manager: antidote

source /usr/local/opt/antidote/share/antidote/antidote.zsh

# Load plugins from .zsh_plugins.txt
antidote load ~/.zsh_plugins.txt

# Plugin Keybindings

# zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# zsh-autosuggestions: accept suggestion with Ctrl-Y
bindkey '^y' autosuggest-accept

# vi-mode
bindkey -v
