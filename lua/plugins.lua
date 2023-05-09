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
    use {
      "MasterGordon/monokai.nvim",
      config = function()
        require("monokai").setup()
      end
    }
    use {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("plugins/icons")
      end
    }
    use {
      "nvim-treesitter/playground",
      requires = {"nvim-treesitter/nvim-treesitter"}
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      -- after = "nvim-compe",
      config = function()
        require "plugins/treesitter"
      end,
      requires = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        "windwp/nvim-ts-autotag",
        "windwp/nvim-autopairs"
      }
    }
    use {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup {
          pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
          mappings = {
            basic = true
          }
        }
      end
    }
    use {
      "mhartington/formatter.nvim",
      config = function()
        require "plugins/formatter"
      end
    }
    use {
      "neovim/nvim-lspconfig",
      config = function()
        require "plugins/lsp"
      end,
      requires = {
        "jose-elias-alvarez/null-ls.nvim",
        "RishabhRD/popfix",
        "onsails/lspkind-nvim",
        "ray-x/lsp_signature.nvim",
        "jose-elias-alvarez/typescript.nvim",
        "hood/popui.nvim"
      }
    }
    use {
      "weilbith/nvim-code-action-menu",
      cmd = "CodeActionMenu"
    }
    use {
      "nvim-telescope/telescope.nvim",
      config = function()
        require("telescope").setup {
          file_ignore_patterns = {"package-lock.json"}
        }
      end,
      requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}
    }
    use {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require "colorizer".setup()
      end
    }
    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {}
      end
    }
    use {
      "lewis6991/gitsigns.nvim",
      requires = {
        "nvim-lua/plenary.nvim"
      },
      config = function()
        require("gitsigns").setup()
      end
    }
    use "editorconfig/editorconfig-vim"
    use {
      "hrsh7th/nvim-cmp",
      config = function()
        require("plugins/cmp")
      end,
      requires = {
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-emoji",
        "David-Kunz/cmp-npm",
        "hrsh7th/cmp-nvim-lsp-signature-help"
      }
    }
    use {
      "saecki/crates.nvim",
      event = {"BufRead Cargo.toml"},
      requires = {{"nvim-lua/plenary.nvim"}},
      config = function()
        require("crates").setup()
      end
    }
    use "aklt/plantuml-syntax"
    use {
      "github/copilot.vim",
      config = function()
        require("plugins/copilot")
      end
    }
    use {
      "ggandor/lightspeed.nvim",
      requires = {"tpope/vim-repeat"}
    }
    use "jghauser/mkdir.nvim"
    use {
      "David-Kunz/cmp-npm",
      requires = {
        "nvim-lua/plenary.nvim"
      }
    }
    use {
      "rebelot/heirline.nvim",
      config = function()
        require "plugins/heirline"
      end,
      requires = {
        "kyazdani42/nvim-web-devicons",
        "nvim-treesitter/nvim-treesitter"
      },
      after = {
        "monokai.nvim",
        "nvim-lspconfig"
      }
    }
    use "isobit/vim-caddyfile"
    use {
      "nvim-neotest/neotest",
      config = function()
        require("plugins/neotest")
      end,
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "haydenmeade/neotest-jest"
      },
      after = {
        "monokai.nvim"
      }
    }
    use {
      "andweeb/presence.nvim",
      config = function()
        require("presence"):setup()
      end
    }
    use {
      "rcarriga/nvim-dap-ui",
      config = function()
        require("plugins/dap")
      end,
      requires = {"mfussenegger/nvim-dap"}
    }
    use {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "main",
      config = function()
        require("plugins/neo-tree")
      end,
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        "s1n7ax/nvim-window-picker"
      },
      after = {
        "monokai.nvim"
      }
    }
    use {
      "luukvbaal/statuscol.nvim",
      config = function()
        require("statuscol").setup(
          {
            -- setopt = true,
            ft_ignore = {"neo-tree"}
          }
        )
      end
    }
    use {
      "axelvc/template-string.nvim",
      config = function()
        require("template-string").setup()
      end
    }
  end
)
