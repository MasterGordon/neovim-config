local remap = vim.api.nvim_set_keymap
local npairs = require("nvim-autopairs")

npairs.setup({map_bs = false})

vim.g.coq_settings = {
  clients = {
    lsp = {
      weight_adjust = 10
    }
  },
  keymap = {recommended = false, manual_complete = "<c-f>"},
  display = {
    preview = {
      positions = {
        east = 1,
        north = 2,
        south = 3,
        west = 4
      }
    },
    icons = {
      mappings = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﰠ",
        Variable = "",
        Class = "ﴯ",
        Interface = "",
        Module = "",
        Property = "ﰠ",
        Unit = "塞",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "פּ",
        Event = "",
        Operator = "",
        TypeParameter = "",
        Character = "",
        Number = "",
        Parameter = "",
        String = ""
      }
    }
  }
}

-- these mappings are coq recommended mappings unrelated to nvim-autopairs
remap("i", "<esc>", [[pumvisible() ? "<c-e><esc>" : "<esc>"]], {expr = true, noremap = true})
remap("i", "<c-c>", [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], {expr = true, noremap = true})
remap("i", "<tab>", [[pumvisible() ? "<c-n>" : "<tab>"]], {expr = true, noremap = true})
remap("i", "<s-tab>", [[pumvisible() ? "<c-p>" : "<bs>"]], {expr = true, noremap = true})

-- skip it, if you use another global object
_G.MUtils = {}

MUtils.CR = function()
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info({"selected"}).selected ~= -1 then
      return npairs.esc("<c-y>")
    else
      return npairs.esc("<c-e>") .. npairs.autopairs_cr()
    end
  else
    return npairs.autopairs_cr()
  end
end
remap("i", "<cr>", "v:lua.MUtils.CR()", {expr = true, noremap = true})

MUtils.BS = function()
  if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({"mode"}).mode == "eval" then
    return npairs.esc("<c-e>") .. npairs.autopairs_bs()
  else
    return npairs.autopairs_bs()
  end
end
remap("i", "<bs>", "v:lua.MUtils.BS()", {expr = true, noremap = true})
