# Dotfiles

Personal dotfiles for macOS, managed with [Dotbot](https://github.com/anishathalye/dotbot).

## Installation

```bash
git clone --recursive https://github.com/alexchen/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

## Structure

```
~/.dotfiles/
├── install                 # Dotbot installation script
├── offload                 # Convert symlinks → real files (remove from repo)
├── install.conf.yaml       # Dotbot symlink configuration
│
├── config/
│   ├── alacritty/          # Terminal emulator (TOML)
│   ├── ghostty/            # Terminal emulator
│   ├── nvim/               # Neovim editor (Lua config, lazy.nvim)
│   ├── pip/                # Python package manager
│   ├── starship.toml       # Shell prompt
│   ├── tmuxthemes/         # Tmux themes
│   ├── yazi/               # File manager
│   └── zsh/                # Shell environment
│       ├── env.zsh         # PATH and environment variables
│       ├── tools.zsh       # Aliases, functions, tool inits
│       └── plugins.zsh     # antidote plugin manager
│
├── zshrc                   # Zsh entry point (sources config/zsh/*)
├── zsh_plugins.txt         # antidote plugin list
├── bash_profile            # Bash shell
├── vimrc                   # Vim/Neovim stub
├── tmux.conf               # Terminal multiplexer
├── gitconfig               # Git configuration
├── inputrc                 # readline settings
├── condarc                 # Conda configuration
├── npmrc                   # NPM configuration
│
├── dotbot/                 # Dotbot submodule (v1.24.0)
└── MIGRATION_HISTORY.md    # Migration history and details
```

## What's Managed

**Shell** (zsh)
- antidote plugin manager (zsh-autosuggestions, zsh-syntax-highlighting, zsh-history-substring-search)
- starship prompt
- Tool integrations (fzf, zoxide, yazi, conda)

**Editor** (Neovim)
- lazy.nvim plugin manager (~25 plugins)
- LSP support (pyright, ruff, lua_ls, texlab, bashls)
- Key: `<leader> = ,`

**Terminal**
- Alacritty (Gruvbox theme, TOML config)
- Ghostty (Gruvbox theme)
- Tmux (seamless vim/tmux navigation, prefix: Ctrl-a)

**Tools**
- eza (modern ls)
- zoxide (smart cd)
- yazi (file manager)
- fzf (fuzzy finder)

## Usage

Edit files in the repo, then run `./install` to apply changes.

To remove a config from the repo: `./offload <config-name>`

## Notes

- All configs follow XDG Base Directory standard where possible
- Local secrets go in `~/.zshrc.local` (gitignored)
- See `MIGRATION_HISTORY.md` for migration history
