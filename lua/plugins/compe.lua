vim.o.completeopt = "menuone,noselect"
require "compe".setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,
  source = {
    path = true,
    buffer = true,
    nvim_lsp = true,
    vsnip = false
  }
}

vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", {silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", {silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", {silent = true, expr = true})
vim.api.nvim_set_keymap("i", "<C-f>", "compe#complete()", {silent = true, expr = true})
