return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets' },
  version = '1.*',
  build = 'cargo build --release',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<C-f>'] = { 'show', 'show_documentation', 'hide_documentation' },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = true },
      menu = {
        max_height = 24,
      },
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    cmdline = {
      enabled = false,
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    enabled = function()
      return not vim.tbl_contains({ 'sagarename' }, vim.bo.filetype)
    end,
  },
  opts_extend = { 'sources.default' },
}
