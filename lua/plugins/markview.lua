return {
  'OXY2DEV/markview.nvim',
  lazy = false,
  opts = {
    preview = {
      icon_provider = 'devicons',
    },
  },
  config = function()
    require('markview.extras.checkboxes').setup({})
  end,

  -- Completion for `blink.cmp`
  -- dependencies = { "saghen/blink.cmp" },
}
