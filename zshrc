# Zsh Configuration

# Environment and PATH
source ~/.config/zsh/env.zsh

# Tools, aliases, and functions
source ~/.config/zsh/tools.zsh

# Plugins and keybindings
source ~/.config/zsh/plugins.zsh

# Source machine-specific secrets if the file exists
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
