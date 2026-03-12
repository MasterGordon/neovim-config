vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Navigate buffers with ALT
vim.api.nvim_set_keymap('', '<A-Left>', '<C-w><Left>', { silent = true })
vim.api.nvim_set_keymap('', '<A-Up>', '<C-w><Up>', { silent = true })
vim.api.nvim_set_keymap('', '<A-Down>', '<C-w><Down>', { silent = true })
vim.api.nvim_set_keymap('', '<A-Right>', '<C-w><Right>', { silent = true })
vim.api.nvim_set_keymap('', '<C-p>', '<C-i>', { silent = true, noremap = true })

vim.api.nvim_set_keymap('n', '<leader><cr>', '<cmd>terminal<cr>i', { silent = true })
