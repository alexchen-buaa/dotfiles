" Vundle part
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'flazz/vim-colorschemes'
Plugin 'liuchengxu/space-vim-theme'
Plugin 'cormacrelf/vim-colors-github'
Plugin 'lervag/vimtex'
Plugin 'w0rp/ale'
Plugin 'sirver/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'edkolev/tmuxline.vim'
Plugin 'shougo/deoplete.nvim'
Plugin 'shougo/deoplete-clangx'
Plugin 'zchee/deoplete-jedi'
Plugin 'klen/python-mode'
Plugin 'fatih/vim-go'
Plugin 'suan/vim-instant-markdown'
Plugin 'tpope/vim-fugitive'
" All of your Plugins must be added before the following line

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"put your none plugin stuff after this line 

" coloring
set termguicolors

" <leader> for certain plugins like EasyMotion
let mapleader = ","

" syntax highlighting
syntax enable

" numbering / relative numbering for fast movement
set nu
set relativenumber

" indentation
set autoindent

" fuzzy searching
set ignorecase
set smartcase

" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>

" colorscheme / statusline
colorscheme quantum
"colorscheme molokai
"colorscheme wombat
"colorscheme Tomorrow-Night
let g:airline_theme='powerlineish'
"let g:airline_theme='molokai'
"let g:airline_theme='wombat'
"let g:airline_theme='tomorrow'
"let g:airline_theme='base16_grayscale'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" so you don't have to reach for <Esc>
inoremap <C-[> <Esc>

" NerdTree
map <C-n> :NERDTreeToggle<CR>

" vimtex
let g:vimtex_latexmk_options='-pdf -pdflatex="xelatex -synctex=1 \%S \%O" -verbose -file-line-error -interaction=nonstopmode'
let g:tex_flavor='latex'
let g:vimtex_view_method='skim'
let g:vimtex_quickfix_mode=0
let conceallevel=1
let g:tex_conceal='abdmg'
let g:vimtex_complete_enabled=1
let g:vimtex_compiler_progname='nvr'

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:ultisnips_python_style='google' " docstring style

" deoplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#var('omni', 'input_patterns', {
          \ 'tex': g:vimtex#re#deoplete
          \})
call deoplete#custom#option('max_list', 15)
let g:pymode_lint=0
let g:pymode_run=1
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })

" ale
let g:ale_linters = {
	\ 'go': ['gopls'],
	\}

" I suppose the completion plugins are pretty much connected
" so some of them might get mixed

" instant markdown
let g:instant_markdown_allow_unsafe_content = 1

" this shuts the popup showing function hints after completion
" the popup actually useful when writing C (when things get long)
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" python pep-8
au BufNewFile,BufRead *.py set tabstop=4
au BufNewFile,BufRead *.py set softtabstop=4
au BufNewFile,BufRead *.py set shiftwidth=4
au BufNewFile,BufRead *.py set textwidth=79
au BufNewFile,BufRead *.py set expandtab
au BufNewFile,BufRead *.py set autoindent
au BufNewFile,BufRead *.py set smartindent
au BufNewFile,BufRead *.py set fileformat=unix

