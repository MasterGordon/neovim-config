vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>t", "<CMD>TodoTelescope<CR>", {silent = true})
vim.api.nvim_set_keymap("", "q:", "<Nop>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>h", "<Plug>RestNvim", {silent = true})

function _G.toggle_venn()
  local venn_enabled = vim.inspect(vim.b.venn_enabled)
  if (venn_enabled == "nil") then
    vim.b.venn_enabled = true
    vim.cmd [[setlocal ve=all]]
    -- draw a line on HJKL keystokes
    vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<cr>", {noremap = true})
    vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<cr>", {noremap = true})
    vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<cr>", {noremap = true})
    vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<cr>", {noremap = true})
    -- draw a box by pressing "b" with visual selection
    vim.api.nvim_buf_set_keymap(0, "v", "b", ":VBox<cr>", {noremap = true})
  else
    vim.cmd [[setlocal ve=]]
    vim.cmd [[mapclear <buffer>]]
    vim.b.venn_enabled = nil
  end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap("n", "<leader>v", ":lua toggle_venn()<cr>", {noremap = true})
vim.api.nvim_set_keymap(
  "v",
  "<Leader>mc",
  "<Cmd>lua require('nvim-magic.flows').append_completion(require('nvim-magic').backends.default)<CR>",
  {}
)
vim.api.nvim_set_keymap(
  "v",
  "<Leader>ma",
  "<Cmd>lua require('nvim-magic.flows').suggest_alteration(require('nvim-magic').backends.default)<CR>",
  {}
)
vim.api.nvim_set_keymap(
  "v",
  "<Leader>md",
  "<Cmd>lua require('nvim-magic.flows').suggest_docstring(require('nvim-magic').backends.default)<CR>",
  {}
)
