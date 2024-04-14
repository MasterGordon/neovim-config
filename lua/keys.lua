vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", {silent = true})
vim.api.nvim_set_keymap(
  "n",
  "<leader>fF",
  "<cmd>lua require('telescope.builtin').find_files({no_ignore=true, no_ignore_parent = true})<cr>",
  {silent = true}
)
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {silent = true})
-- vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').git_branches()<cr>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>ft", "<CMD>TodoTelescope<CR>", {silent = true})
vim.api.nvim_set_keymap("n", "<leader>fj", "<CMD>Telescope jsonfly<CR>", {silent = true})
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
vim.api.nvim_set_keymap("", "<C-p>", "<C-i>", {silent = true})

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
