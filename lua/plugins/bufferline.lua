diagnostics_indicator = function(count, level, diagnostics_dict, context)
  local s = " "
  for e, n in pairs(diagnostics_dict) do
    local sym = e == "error" and " " or (e == "warning" and " " or "")
    s = s .. n .. sym
  end
  return s
end
require "bufferline".setup {
  options = {
    always_show_bufferline = true,
    diagnostics_indicator = diagnostics_indicator,
    diagnostics = "nvim_lsp",
    separator_style = "thin"
  }
}

vim.api.nvim_set_keymap("", "<A-1>", ":lua require'bufferline'.go_to_buffer(1)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-2>", ":lua require'bufferline'.go_to_buffer(2)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-3>", ":lua require'bufferline'.go_to_buffer(3)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-4>", ":lua require'bufferline'.go_to_buffer(4)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-5>", ":lua require'bufferline'.go_to_buffer(5)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-6>", ":lua require'bufferline'.go_to_buffer(6)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-7>", ":lua require'bufferline'.go_to_buffer(7)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-8>", ":lua require'bufferline'.go_to_buffer(8)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-9>", ":lua require'bufferline'.go_to_buffer(9)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-0>", ":lua require'bufferline'.go_to_buffer(10)<CR>", {silent = true})
vim.api.nvim_set_keymap("", "<A-Left>", "<C-w><Left>", {silent = true})
vim.api.nvim_set_keymap("", "<A-Up>", "<C-w><Up>", {silent = true})
vim.api.nvim_set_keymap("", "<A-Down>", "<C-w><Down>", {silent = true})
vim.api.nvim_set_keymap("", "<A-Right>", "<C-w><Right>", {silent = true})
