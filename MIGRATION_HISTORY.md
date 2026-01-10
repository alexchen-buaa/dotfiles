# Dotfiles Migration History

**Last updated**: January 2026-01-10

---

## Overview

| Tool            | Type       | Status     | Details                         |
|-----------------|------------|------------|---------------------------------|
| **Neovim**      | Core       | Upgraded   | 0.11.0 → 0.11.5                 |
| ├─ Plugin mgr   | Core       | Replaced   | Vundle → lazy.nvim              |
| ├─ Plugins      | Core       | Replaced   | 35 plugins                      |
| └─ Config       | Core       | Replaced   | Vimscript → Lua                 |
| **Alacritty**   | Core       | Upgraded   | 0.11.0 → 0.16.1                 |
| └─ Config       | Core       | Migrated   | YAML → TOML                     |
| **Tmux**        | Core       | Upgraded   | 3.4 → 3.6a                      |
| **ZSH**         | Core       | —          |                                 |
| ├─ Plugin mgr   | Core       | Replaced   | Antigen → antidote              |
| ├─ Plugins      | Core       | Upgraded   | 2 → 3 plugins (fish-like)       |
| ├─ Prompt       | Core       | Replaced   | Custom → starship               |
| └─ Config       | Core       | Refactored | 5 → 3 files, XDG structure      |
| **autojump**    | Peripheral | Replaced   | → zoxide                        |
| **ranger**      | Peripheral | Replaced   | → yazi                          |
| **fzf**         | Peripheral | Upgraded   | 0.34.0 → 0.67.0                 |
| **exa**         | Peripheral | Replaced   | → eza                           |
| **starship**    | Peripheral | Added      | v1.24.2                         |
| **dotbot**      | Core       | Upgraded   | v1.17.1 → v1.24.0               |

---

## Neovim Migration Details

**Status**: ✅ Complete

- ✅ Migrated from `Vundle` to `lazy.nvim`
- ✅ 30 plugins configured (27 migrated, 3 kept, 5 AI tools added)
- ✅ LSP configured (`pyright`, `lua_ls`)
- ✅ New config structure: `config/nvim/`

**Old vimrc**: Replaced with minimal stub (legacy support)

**Configuration structure**:
```
config/nvim/
├── init.lua                 # Entry point
├── lazy-lock.json           # Plugin versions
└── lua/
    ├── keymaps.lua          # Global keymaps
    ├── options.lua          # Editor options
    └── plugins/
        ├── init.lua         # Plugin loader
        ├── ui.lua           # Gruvbox, lualine
        ├── lsp.lua          # LSP, Mason, Treesitter, blink.cmp
        ├── navigation.lua   # neo-tree, telescope, flash, aerial
        ├── tools.lua        # Comment, surround, fugitive, vimtex
        └── ai.lua           # claudecode, opencode
```

**Plugin migration highlights**:

| Old Plugin        | New Plugin                | Purpose                     |
|-------------------|---------------------------|-----------------------------|
| Vundle            | lazy.nvim                 | Plugin manager              |
| vim-airline       | lualine.nvim              | Status line                 |
| ALE               | nvim-lspconfig + mason    | Linting/LSP                 |
| deoplete          | blink.cmp                 | Completion                  |
| ultisnips         | LuaSnip                   | Snippets                    |
| NERDTree          | neo-tree.nvim             | File explorer (`<leader>e`) |
| fzf.vim           | telescope.nvim            | Fuzzy finder (`<leader>f`)  |
| vim-easymotion    | flash.nvim                | Motion (`s` key)            |
| tagbar            | aerial.nvim               | Code outline (`<leader>t`)  |

---

## ZSH Migration Details

**Status**: ✅ Complete

- ✅ Migrated from `Antigen` (deprecated) to `antidote` (v1.9.11)
- ✅ Upgraded from 2 to 3 fish-like plugins
- ✅ Replaced custom prompt with `starship` (v1.24.2)
- ✅ Cleaned up `autojump` remnants

**Configuration files**:
```
~/.zshrc                    # Main entry point
~/.zsh_plugins.txt          # Plugin list (antidote)
~/.zsh/envvars.zsh          # Environment variables
~/.zsh/aliases.zsh          # Aliases
~/.zsh/functions.zsh        # Custom functions
~/.zsh/clitools.zsh         # CLI tool integrations
~/.zsh/plugins.zsh          # Plugin loader (antidote)
~/.config/starship.toml     # Starship prompt config
```

**Plugin migration highlights**:

| Old Plugin Manager | New Plugin Manager           | Purpose                     |
|--------------------|------------------------------|-----------------------------|
| Antigen            | antidote                     | Plugin manager              |
| Manual install     | zsh-autosuggestions          | Autosuggestions             |
| Manual install     | zsh-syntax-highlighting      | Syntax highlighting         |
| —                  | zsh-history-substring-search | History search              |

**New keybindings**:
- `Ctrl-Y` - Accept autosuggestion
- `Up/Down` arrows - History substring search
- `k/j` (vi-mode) - History substring search

**Starship prompt features**:
- Minimal, fast cross-shell prompt
- Nerd Font Symbols preset (icons for git, languages, OS, etc.)
- Default format with no blank lines (`add_newline = false`)
- Conda environment display configured

---

## Dotfiles Cleanup (January 2026)

**Status**: ✅ Complete

**Goal**: Reduce dotfiles repository to only actively managed configurations, offloading tool-generated and rarely modified configs.

### Changes Made

#### 1. Offloaded configs (converted symlinks → real files)

**Top-level configs** (in `~/`):
- `itermcolors/` - iTerm2 color schemes
- `terminalizer/` - Terminal recording tool config
- `emacs` - Emacs configuration
- `flake8` - Python linting config
- `pythonrc` - Python startup config
- `yarnrc` - Yarn package manager config

**Config directories** (in `~/.config/`):
- `Amazon/` - AWS CLI config
- `NuGet/` - .NET package manager config
- `dask/` - Dask distributed computing config
- `htop/` - htop system monitor config
- `kitty/` - Kitty terminal config
- `nnn/` - nnn file manager config
- `ranger/` - ranger file manager config
- `stetic/` - GTK UI designer config
- `thefuck/` - Thefuck correction tool config
- `xbuild/` - Xcode build config
- `karabiner/` - Karabiner key remapper config

#### 2. Removed from repository

- `config/fontconfig/` - Legacy PowerlineSymbols font config (obsolete)
- `config/nvim.old/` - Backup of old Vim configuration (exists elsewhere)
- `config/karabiner/assets/` - Auto-generated UI assets
- `config/karabiner/automatic_backups/` - Auto-generated backups
- `config/configstore/` - npm update-notifier cache
- `textemplate/` - LaTeX template (unused)
- `config/yarn/` - Yarn cache (removed from .gitignore)

#### 3. Repository structure improvements

**Before**: Used `glob: true` pattern for `config/*` (auto-symlinked everything)

**After**: Explicit entries in `install.conf.yaml`:
```yaml
~/.config/alacritty:
        path: config/alacritty
~/.config/nvim:
        path: config/nvim
~/.config/pip:
        path: config/pip
~/.config/starship.toml:
        path: config/starship.toml
```

**Benefits**:
- Clear what's being managed
- Adding to `config/` won't auto-symlink
- No need for `exclude` patterns

#### 4. New tools

**Created `./offload` script** - Reverse of `./install`:
- Converts symlinks → real files
- Removes from repo
- Updates `install.conf.yaml`
- Auto-detects top-level vs config items
- Supports `--dry-run`, `--list`, `-y` (skip confirm)

**Usage**:
```bash
# List managed files
./offload --list

# Offload configs
./offload emacs flake8
./offload nvim alacritty

# Dry run first
./offload --dry-run nvim
```

### Remaining managed configs

**Top-level** (13 items):
- Shell: `zshrc`, `bash_profile`, `zsh_plugins.txt`
- Editor: `vimrc`
- Tools: `gitconfig`, `tmux.conf`, `inputrc`
- Package managers: `condarc`, `npmrc`

**Config** (6 items):
- `config/alacritty/` - Terminal emulator
- `config/nvim/` - Neovim editor
- `config/pip/` - Python package manager
- `config/starship.toml` - Shell prompt
- `config/tmuxthemes/` - Tmux themes
- `config/zsh/` - Shell configuration

**Total reduction**: ~20 configs offloaded/removed

---

## Configuration Restructure (January 2026)

**Status**: ✅ Complete

**Goal**: Simplify zsh configuration and adopt XDG Base Directory standard.

### ZSH Configuration Changes

**Before** (5 files, over-fragmented):
```
zsh/
├── envvars.zsh        # 54 lines - PATH, env vars, bindkey
├── aliases.zsh         # 10 lines - aliases
├── functions.zsh       # 10 lines - 1 function
├── clitools.zsh        # 4 lines - fzf init
└── plugins.zsh         # 17 lines - antidote + keybindings

zshrc                   # 100 lines - includes API keys
```

**After** (3 files, logical grouping):
```
config/zsh/
├── env.zsh            # 40 lines - PATH and env vars only
├── tools.zsh          # 60 lines - aliases, functions, tool inits
└── plugins.zsh        # 20 lines - antidote and keybindings

zshrc                   # 15 lines - clean entry point
~/.zshrc.local          # 70 lines - API keys (not in repo)
```

**Improvements**:
- ✅ **Reduced fragmentation**: 3 files instead of 5
- ✅ **Clear purpose**: env, tools, plugins
- ✅ **No secrets in repo**: API keys moved to `~/.zshrc.local`
- ✅ **Clean zshrc**: 15 lines vs 100 lines
- ✅ **Logical grouping**: Tool inits, aliases, functions together

**File mapping**:
| Old | New |
|-----|-----|
| `zsh/envvars.zsh` | → `config/zsh/env.zsh` |
| `zsh/aliases.zsh` | → `config/zsh/tools.zsh` |
| `zsh/functions.zsh` | → `config/zsh/tools.zsh` |
| `zsh/clitools.zsh` | → `config/zsh/tools.zsh` |
| `zsh/plugins.zsh` | → `config/zsh/plugins.zsh` (cleaned) |
| `zshrc` (API keys) | → `~/.zshrc.local` (new, gitignored) |

### XDG Standard Adoption

**Moved to `~/.config/`** (XDG standard location):
```
config/
├── alacritty/          # Terminal
├── nvim/               # Editor
├── pip/                # Python
├── starship.toml       # Prompt
├── tmuxthemes/         # Tmux themes (moved from ~/)
└── zsh/                # Shell (moved from ~/)
```

**Updated symlinks**:
- Removed: `~/.zsh/` (now `~/.config/zsh/`)
- Removed: `~/.tmuxthemes/` (now `~/.config/tmuxthemes/`)

**Updated paths**:
- `zshrc`: Changed sources from `~/.zsh/*` to `~/.config/zsh/*`
- `tmux.conf`: Changed theme source from `~/.tmuxthemes/` to `~/.config/tmuxthemes/`

**Benefits**:
- ✅ **XDG compliant**: Configs follow freedesktop.org standard
- ✅ **Predictable**: All user configs in one location
- ✅ **Cleaner home**: Fewer dotfiles in `~/`
- ✅ **Standard**: Works across Linux, BSD, macOS

**Remaining in `~/`** (non-XDG compliant):
- `~/.vimrc` - Vim hardcodes this path
- `~/.gitconfig` - Git doesn't support XDG
- `~/.tmux.conf` - Tmux uses `~/.tmux.conf` by default
- `~/.zshrc` - Zsh entry point (must be in home)

---

## Pending Items

### Dotbot Enhancement

**Status**: ✅ Complete (January 2026-01-10)

**Changes**: Upgraded from v1.17.1 → v1.24.0

**New features available**:
- `backup:` option for `link`
- `--dry-run` flag for testing
- Hardlinks support in `link`
- Multiple config files support
- `--only` and `--except` flags
- `mode:` option for `create`
- `exclude:` option for `link`

---

### Low Priority
(None at this time)
