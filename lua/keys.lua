vim.api.nvim_set_keymap(
  "n",
  "<leader>ff",
  "<cmd>lua require('telescope.builtin').find_files({hidden = true})<cr>",
  {silent = true}
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>fF",
  "<cmd>lua require('telescope.builtin').find_files({no_ignore=true, no_ignore_parent = true, hidden = true})<cr>",
  {silent = true}
)
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fB", "<cmd>lua require('telescope.builtin').git_branches()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>ft", "<CMD>TodoTelescope<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fj", "<CMD>Telescope jsonfly<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fb", "<CMD>Telescope buffers<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>", {silent = true})
local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap(
  "n",
  "<C-LeftMouse>",
  "<LeftMouse><cmd>lua require('telescope.builtin').lsp_definitions()<cr>",
  opts
)
vim.api.nvim_set_keymap(
  "n",
  "<C-RightMouse>",
  "<LeftMouse><cmd>lua require('telescope.builtin').lsp_references()<cr>",
  opts
)
vim.api.nvim_set_keymap("n", "gi", "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>D", "<cmd>lua vim.diagnostic.goto_next { wrap = false }<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>Gitsigns blame_line<cr>", {silent = true})
vim.api.nvim_set_keymap("", "q:", "<Nop>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>h", "<Plug>RestNvim", {silent = true})
vim.api.nvim_set_keymap("n", "<leader><cr>", ":terminal<cr>i", {silent = true})
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", {silent = true, noremap = true})
vim.api.nvim_set_keymap("", "<A-Left>", "<C-w><Left>", {silent = true})
vim.api.nvim_set_keymap("", "<A-Up>", "<C-w><Up>", {silent = true})
vim.api.nvim_set_keymap("", "<A-Down>", "<C-w><Down>", {silent = true})
vim.api.nvim_set_keymap("", "<A-Right>", "<C-w><Right>", {silent = true})
vim.api.nvim_set_keymap("", "<C-p>", "<C-i>", {silent = true, noremap = true})

local insert_random_uuid = function()
  local id, _ = vim.fn.system("uuidgen"):gsub("\n", ""):gsub("-", ""):upper()
  vim.api.nvim_put({id}, "c", true, true)
end
local insert_random_uuid_dashed = function()
  local id, _ = vim.fn.system("uuidgen"):gsub("\n", ""):upper()
  vim.api.nvim_put({id}, "c", true, true)
end

vim.keymap.set("n", "<leader>u", insert_random_uuid, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>U", insert_random_uuid_dashed, {noremap = true, silent = true})
