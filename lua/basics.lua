local set = vim.o

set.number = true
set.relativenumber = true
set.clipboard = "unnamedplus"
set.mouse = "a"
set.termguicolors = true

vim.cmd [[filetype plugin indent on]]
set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true

vim.cmd [[autocmd FileType markdown setlocal spell spelllang=de,en]]
vim.cmd [[autocmd bufnewfile,bufread *.tsx set filetype=typescriptreact]]
vim.cmd [[autocmd bufnewfile,bufread *.jsx set filetype=javascriptreact]]

set.splitright = true
set.splitbelow = true

set.signcolumn = "auto:2"

-- set leader
vim.g.mapleader = ","
