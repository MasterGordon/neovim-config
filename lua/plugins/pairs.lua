return {
  'echasnovski/mini.pairs',
  event = 'VeryLazy',
  opts = {
    modes = { insert = true, command = true, terminal = false },
    -- skip autopair when next character is one of these
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    -- skip autopair when the cursor is inside these treesitter nodes
    skip_ts = { 'string' },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = true,
    -- better deal with markdown code blocks
    markdown = true,
  },
  config = function(_, opts)
    require('mini.pairs').setup(opts)

    -- In F# single quotes are mostly used for generics (e.g. 'a), so don't
    -- auto-pair them.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'fsharp',
      callback = function(args)
        MiniPairs.unmap_buf(args.buf, 'i', "'", "''")
      end,
    })
  end,
}
