vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.mousemoveevent = true
vim.opt.showmode = false
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
  vim.g.clipboard = {
    name = 'xclip',
    copy = {
      ['+'] = 'xclip -selection clipboard',
      ['*'] = 'xclip -selection primary',
    },
    paste = {
      ['+'] = { 'xclip', '-selection', 'clipboard', '-o' },
      ['*'] = { 'xclip', '-selection', 'primary', '-o' },
    },
    cache_enabled = true,
  }
end)
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.conceallevel = 0
vim.o.swapfile = false
vim.o.backup = false

-- Convert Tab to spaces
vim.cmd([[filetype plugin indent on]])
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.winborder = 'rounded'

vim.filetype.add({
  extension = {
    zsh = 'zsh',
    sh = 'sh',
  },
  filename = {
    ['.zshrc'] = 'zsh',
    ['.zshenv'] = 'zsh',
  },
})

require('diagnostic')
require('keybinds')

-- editorconfig sets textwidth from max_line_length, which causes auto-wrap while typing
-- BufWinEnter fires after BufReadPost (where editorconfig runs), so this wins
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function()
    vim.opt_local.textwidth = 0
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Setup Lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- ... existing plugins ...
  require('plugins/neotest'), -- Add this line
  require('plugins/web-devicons'),
  require('plugins/neo-tree'),
  require('plugins/conform'),
  -- require('plugins/treesitter'),
  require('plugins/ts'),
  require('plugins/lsp'),
  require('plugins/telescope'),
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup({
        transparent = (vim.fn.has_key(vim.fn.environ(), 'WSL_DISTRO_NAME') == 0),
        terminal_colors = false,
        ---@param highlights tokyonight.Highlights
        ---@param _ ColorScheme
        on_highlights = function(highlights, c)
          highlights.TabLineSel = { bg = '#252d37' }
          highlights.TabLineHover = { bg = c.bg_highlight }
        end,
      })
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
  require('plugins/none-ls'),
  require('plugins/blink'),
  require('plugins/pairs'),
  require('plugins/ccc'),
  require('plugins/heirline'),
  { 'folke/ts-comments.nvim', opts = {}, event = 'VeryLazy' },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {},
  },
  {
    'MagicDuck/grug-far.nvim',
    opts = {},
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {},
  },
  {
    'axelvc/template-string.nvim',
    opts = {},
  },
  'jghauser/mkdir.nvim',
  {
    'folke/snacks.nvim',
    ---@type snacks.Config
    opts = {
      input = {},
      styles = {
        input = {
          relative = 'cursor',
          row = -3,
          col = 0,
          position = 'float',
        },
      },
    },
  },
  {
    'seblyng/roslyn.nvim',
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
  },
  require('plugins/markview'),
  {
    'FabijanZulj/blame.nvim',
    lazy = false,
    opts = {},
  },
  -- {
  --   'vyfor/cord.nvim',
  --   ---@type CordConfig
  --   opts = {
  --     -- ...
  --   },
  -- },
  require('plugins/diff'),
})

-- Load custom snippets after plugins are loaded
require('snippets')
