local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn
-- ensure that packer is installed
local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
  execute "packadd packer.nvim"
end
vim.cmd("packadd packer.nvim")
local packer = require "packer"
local util = require "packer.util"

packer.init(
  {
    package_root = util.join_paths(vim.fn.stdpath("data"), "site", "pack")
  }
)

return require("packer").startup(
  function()
    -- Packer can manage itself
    use "wbthomason/packer.nvim"
    use "MasterGordon/monokai.nvim"
    use {
      "glepnir/galaxyline.nvim",
      branch = "main",
      config = function()
        require "plugins/galaxyline"
      end,
      requires = {"kyazdani42/nvim-web-devicons"}
    }
    use {
      "kyazdani42/nvim-tree.lua",
      config = function()
        require "plugins/nvim-tree"
      end,
      requires = {"kyazdani42/nvim-web-devicons", opt = true}
    }
    use "JoosepAlviste/nvim-ts-context-commentstring"
    use {
      "b3nj5m1n/kommentary",
      config = function()
        require("kommentary.config").configure_language(
          "typescriptreact",
          {
            single_line_comment_string = "auto",
            multi_line_comment_strings = "auto",
            hook_function = function()
              require("ts_context_commentstring.internal").update_commentstring()
            end
          }
        )
      end
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      config = function()
        require("nvim-autopairs").setup(
          {
            enable_check_bracket_line = true
          }
        )
        require "nvim-treesitter.configs".setup {
          context_commentstring = {
            enable = true,
            enable_autocmd = true
          },
          highlight = {
            enable = true
          },
          indent = {
            enable = true
          },
          autotag = {
            enable = true
          }
        }
      end,
      requires = {"JoosepAlviste/nvim-ts-context-commentstring", "windwp/nvim-ts-autotag", "windwp/nvim-autopairs"}
    }
    use {
      "mhartington/formatter.nvim",
      config = function()
        require "plugins/formatter"
      end
    }
    use {
      "mhinz/vim-signify",
      config = function()
        require "plugins/signify"
      end
    }
    use {
      "RishabhRD/nvim-lsputils",
      requires = {"RishabhRD/popfix"}
    }
    use {
      "neovim/nvim-lspconfig",
      config = function()
        require "plugins/lsp"
      end,
      requires = {"RishabhRD/nvim-lsputils", "onsails/lspkind-nvim"}
    }
    use {
      "hrsh7th/nvim-compe",
      config = function()
        require "plugins/compe"
      end
    }
    use {
      "nvim-telescope/telescope.nvim",
      requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}}
    }
    use {
      "nacro90/numb.nvim",
      config = function()
        require("numb").setup()
      end
    }
    use {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require "colorizer".setup()
      end
    }
    use {
      "tveskag/nvim-blame-line",
      config = function()
        vim.api.nvim_exec([[autocmd BufEnter * EnableBlameLine]], true)
      end
    }
  end
)
