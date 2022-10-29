local cmp = require "cmp"
require("cmp-npm").setup({})

local cmp_kinds = {
  --[[ Text = "  ",
  Method = "  ",
  Function = "  ",
  Constructor = "  ",
  Field = "  ",
  Variable = "  ",
  Class = "  ",
  Interface = "  ",
  Module = "  ",
  Property = "  ",
  Unit = "  ",
  Value = "  ",
  Enum = "  ",
  Keyword = "  ",
  Snippet = "  ",
  Color = "  ",
  File = "  ",
  Reference = "  ",
  Folder = "  ",
  EnumMember = "  ",
  Constant = "  ",
  Struct = "  ",
  Event = "  ",
  Operator = "  ",
  TypeParameter = "  " ]]
  Text = " ",
  Method = " ",
  Function = " ",
  Constructor = " ",
  Field = "炙",
  Variable = " ",
  Class = " ",
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
  TypeParameter = " ",
  Copilot = " "
}

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
    kind_icons = cmp_kinds,
    source_names = {
      nvim_lsp = "",
      emoji = "",
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
      vim_item.kind = options.formatting.kind_icons[vim_item.kind] .. " " .. vim_item.kind
      vim_item.menu = options.formatting.source_names[entry.source.name]
      vim_item.dup = options.formatting.duplicates[entry.source.name] or options.formatting.duplicates_default
      return vim_item
    end,
    fields = {"abbr", "kind", "menu"}
    --[[ format = function(_, vim_item)
      vim_item.kind = cmp_kinds[vim_item.kind] or ""
      return vim_item
    end ]]
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  },
  mapping = {
    ["<C-f>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({select = true}),
    ["<Up>"] = cmp.mapping.select_prev_item(),
    ["<Down>"] = cmp.mapping.select_next_item()
  },
  sources = {
    {name = "nvim_lsp"},
    {name = "path"},
    {name = "luasnip"},
    {name = "nvim_lua"},
    -- {name = "buffer"},
    {name = "emoji"},
    {name = "copilot", group_index = 2},
    {name = "npm", keyword_length = 4},
    {name = "nvim_lsp_signature_help"}
  }
}

cmp.setup(options)
