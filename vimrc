" Minimal vimrc for legacy Vim support
" Primary editor is now Neovim (see config/nvim/)

set nocompatible
syntax enable
set nu
set relativenumber
set autoindent
set ignorecase
set smartcase
set encoding=utf-8

" System clipboard access
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+p
noremap <Leader>P "+p
