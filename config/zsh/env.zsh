# Environment Variables and PATH Setup

# PATH setup
export PATH="/Users/alexchen/ffmpeg/bin:$PATH"
export PATH="/Users/alexchen/miniconda3/bin:$PATH"
export PATH="/Users/alexchen/.local/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/3.4.0/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"

# Homebrew
# export HOMEBREW_NO_AUTO_UPDATE=true

# TUNA mirrors
# export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
# export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

# USTC mirrors
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"

# Aliyun mirrors
# export HOMEBREW_API_DOMAIN="https://mirrors.aliyun.com/homebrew-bottles/api"
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.aliyun.com/homebrew/homebrew-core.git"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.aliyun.com/homebrew/homebrew-bottles"

# Original upstream
# unset HOMEBREW_API_DOMAIN
# unset HOMEBREW_BREW_GIT_REMOTE
# unset HOMEBREW_CORE_GIT_REMOTE
# git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew
# BREW_TAPS="$(BREW_TAPS="$(brew tap 2>/dev/null)"; echo -n "${BREW_TAPS//$'\n'/:}")"
# for tap in core cask; do
#     if [[ ":${BREW_TAPS}:" == *":homebrew/${tap}:"* ]]; then
#         brew tap --custom-remote "homebrew/${tap}" "https://github.com/Homebrew/homebrew-${tap}"
#     fi
# done

# Development tools
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# Python
export PYTHONSTARTUP=~/.pythonrc

# Editor
export EDITOR=/usr/local/bin/nvim

# Locale
export LC_CTYPE='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Terminal
export TERM=xterm-256color

# fzf configuration
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height ~50% --border'
fi
export FZF_CTRL_R_OPTS='--sort --exact'

# Mujoco
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.mujoco/mujoco210/bin
export MUJOCO_PY_MUJOCO_PATH=~/.mujoco/mujoco210
