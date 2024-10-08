local set = vim.o

set.number = true
set.relativenumber = true
set.clipboard = "unnamedplus"
set.mouse = "a"
set.termguicolors = true
set.swapfile = false
set.cursorline = true
set.cursorlineopt = "number"
set.scrolloff = 5

vim.cmd [[filetype plugin indent on]]
set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true

-- vim.cmd [[autocmd FileType markdown setlocal spell spelllang=de,en]]
-- vim.cmd [[autocmd FileType tex setlocal spell spelllang=de,en]]
vim.cmd [[autocmd bufnewfile,bufread *.tsx set filetype=typescriptreact]]
vim.cmd [[autocmd bufnewfile,bufread *.jsx set filetype=javascriptreact]]
vim.cmd [[autocmd bufnewfile,bufread Jenkinsfile set filetype=groovy]]

set.splitright = true
set.splitbelow = true

set.signcolumn = "auto:2"

-- set leader
vim.g.mapleader = " "

vim.filetype.add(
  {
    extension = {
      zsh = "sh",
      sh = "sh"
    },
    filename = {
      [".zshrc"] = "sh",
      [".zshenv"] = "sh"
    }
  }
)
