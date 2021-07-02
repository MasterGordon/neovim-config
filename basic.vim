set number relativenumber
set clipboard=unnamedplus
set mouse=a

set t_Co=16
set termguicolors

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=2
" when indenting with '>', use 4 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab
" Spellcheck
autocmd FileType markdown setlocal spell spelllang=de,en

set splitright
set splitbelow

" allow two signs to show up in the sign collumn eg. todo comment and git status
set signcolumn=auto:2

" set leader key
let mapleader = ","
