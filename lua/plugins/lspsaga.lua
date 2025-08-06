return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup({
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
      beacon = {
        enable = false,
      },
      rename = {
        keys = {
          quit = '<C-c>',
        },
      },
      code_action = {
        keys = {
          quit = '<C-c>',
        },
      },
    })
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
}
