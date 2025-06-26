vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Navigate buffers with ALT
vim.api.nvim_set_keymap('', '<A-Left>', '<C-w><Left>', { silent = true })
vim.api.nvim_set_keymap('', '<A-Up>', '<C-w><Up>', { silent = true })
vim.api.nvim_set_keymap('', '<A-Down>', '<C-w><Down>', { silent = true })
vim.api.nvim_set_keymap('', '<A-Right>', '<C-w><Right>', { silent = true })
vim.api.nvim_set_keymap('', '<C-p>', '<C-i>', { silent = true, noremap = true })

local print_namespace = function()
  local cmd = 'bash -c "xq *.csproj -q RootNamespace"'
  -- insert namespace NAMESPACE.PATH.TO.FILE; at the start of the file
  local output = vim.fn.system(cmd):gsub('\n', '')
  local relative_path = vim.fn.expand('%:h')
  local short_path = relative_path:gsub('/', '.')
  local namespace = output .. '.' .. short_path
  if relative_path == '.' then
    namespace = output
  end
  vim.cmd([[normal! gg]])
  vim.cmd([[normal! }]])
  vim.cmd([[normal! o]])
  vim.api.nvim_put({ 'namespace ' .. namespace .. ';' }, 'c', true, true)
  vim.cmd([[normal! o]])
end

vim.keymap.set('n', '<leader>n', print_namespace, { silent = true })

vim.api.nvim_set_keymap('n', '<leader><cr>', '<cmd>terminal<cr>i', { silent = true })
