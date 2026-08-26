return {
  'dlyongemallo/diffview-plus.nvim',
  version = '*',
  cmd = { 'DiffviewOpen', 'DiffviewToggle', 'DiffviewFileHistory', 'DiffviewDiffFiles' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diff working tree' },
    { '<leader>gm', '<cmd>DiffviewOpen origin/main...HEAD<cr>', desc = 'Diff vs main' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'File history' },
  },
  dependencies = {
    'rickhowe/diffchar.vim',
  },
}
