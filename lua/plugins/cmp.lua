local cmp = require "cmp"

options = {
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false
  },
  experimental = {
    ghost_text = true,
    native_menu = false
  },
  formatting = {
    kind_icons = {
      Text = " ",
      Method = " ",
      Function = " ",
      Constructor = " ",
      Field = "ﰠ ",
      Variable = " ",
      Class = "ﴯ ",
      Interface = " ",
      Module = " ",
      Property = "ﰠ ",
      Unit = "塞 ",
      Value = " ",
      Enum = " ",
      Keyword = " ",
      Snippet = " ",
      Color = " ",
      File = " ",
      Reference = " ",
      Folder = " ",
      EnumMember = " ",
      Constant = " ",
      Struct = "פּ ",
      Event = " ",
      Operator = " ",
      TypeParameter = " "
    },
    source_names = {
      nvim_lsp = "(LSP)",
      emoji = "(Emoji)",
      path = "(Path)",
      calc = "(Calc)",
      cmp_tabnine = "(Tabnine)",
      vsnip = "(Snippet)",
      luasnip = "(Snippet)",
      buffer = "(Buffer)"
    },
    duplicates = {
      buffer = 1,
      path = 1,
      nvim_lsp = 0,
      luasnip = 1
    },
    duplicates_default = 0,
    format = function(entry, vim_item)
      vim_item.kind = options.formatting.kind_icons[vim_item.kind]
      vim_item.menu = options.formatting.source_names[entry.source.name]
      vim_item.dup = options.formatting.duplicates[entry.source.name] or options.formatting.duplicates_default
      return vim_item
    end
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  },
  documentation = {
    border = {"╭", "─", "╮", "│", "╯", "─", "╰", "│"}
  },
  mapping = {
    ["<C-f>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({select = true})
  },
  sources = {
    {name = "nvim_lsp"},
    {name = "path"},
    {name = "luasnip"},
    {name = "nvim_lua"},
    {name = "buffer"},
    {name = "calc"},
    {name = "emoji"},
    {name = "crates"}
  }
}

cmp.setup(options)
