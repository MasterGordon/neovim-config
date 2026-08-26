vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Navigate buffers with ALT
vim.api.nvim_set_keymap('', '<A-Left>', '<C-w><Left>', { silent = true })
vim.api.nvim_set_keymap('', '<A-Up>', '<C-w><Up>', { silent = true })
vim.api.nvim_set_keymap('', '<A-Down>', '<C-w><Down>', { silent = true })
vim.api.nvim_set_keymap('', '<A-Right>', '<C-w><Right>', { silent = true })
vim.api.nvim_set_keymap('', '<C-p>', '<C-i>', { silent = true, noremap = true })

vim.api.nvim_set_keymap('n', '<leader><cr>', '<cmd>terminal<cr>i', { silent = true })

-- Git checkout the current buffer's file from a given ref, then reload it
local function git_checkout_buffer(ref)
  local file = vim.fn.expand('%:p')
  if file == '' then
    vim.notify('No file in current buffer', vim.log.levels.WARN)
    return
  end
  local result = vim.fn.system({ 'git', 'checkout', ref, '--', file })
  if vim.v.shell_error ~= 0 then
    vim.notify('git checkout failed: ' .. result, vim.log.levels.ERROR)
    return
  end
  vim.cmd('edit!')
  vim.notify('Checked out ' .. vim.fn.expand('%:t') .. ' from ' .. ref)
end

-- :gch -> discard changes by checking out HEAD
vim.api.nvim_create_user_command('Gch', function()
  git_checkout_buffer('HEAD')
end, { desc = 'Checkout current buffer from HEAD' })

-- :gcm -> checkout current buffer from master/main (whichever exists)
vim.api.nvim_create_user_command('Gcm', function()
  local branch = 'main'
  vim.fn.system({ 'git', 'rev-parse', '--verify', 'master' })
  if vim.v.shell_error == 0 then
    branch = 'master'
  end
  git_checkout_buffer(branch)
end, { desc = 'Checkout current buffer from master/main' })

-- Lowercase command aliases
vim.cmd('cnoreabbrev gch Gch')
vim.cmd('cnoreabbrev gcm Gcm')
