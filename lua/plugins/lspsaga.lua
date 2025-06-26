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
    vim.keymap.set('', '<leader>a', '<cmd>Lspsaga code_action<CR>')
    vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
    vim.keymap.set('n', '<F2>', '<cmd>Lspsaga rename<CR>')
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
  },
}
