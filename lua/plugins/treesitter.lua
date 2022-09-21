local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.http = {
  install_info = {
    url = "https://github.com/NTBBloodbath/tree-sitter-http",
    files = {"src/parser.c"},
    branch = "main"
  }
}
local npairs = require("nvim-autopairs")
npairs.setup(
  {
    check_ts = true,
    enable_check_bracket_line = true
  }
)

require "nvim-treesitter.configs".setup {
  context_commentstring = {
    enable = true,
    enable_autocmd = false
  },
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  autotag = {
    enable = true
  },
  autopairs = {
    enable = true
  }
}
