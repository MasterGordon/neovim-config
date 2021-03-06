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

    --[[ use {
      "NTBBloodbath/galaxyline.nvim",
      branch = "main",
      config = function()
        require "plugins/galaxyline"
      end,
      requires = {"kyazdani42/nvim-web-devicons"}
    } ]]
    use {
      "kyazdani42/nvim-tree.lua",
      after = "nvim-web-devicons",
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
      "nvim-treesitter/playground",
      requires = {"nvim-treesitter/nvim-treesitter"}
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = ":TSUpdate",
      -- after = "nvim-compe",
      config = function()
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
          },
          autopairs = {
            enable = true
          }
        }
      end,
      requires = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        "windwp/nvim-ts-autotag",
        "windwp/nvim-autopairs"
      }
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
        "hood/popui.nvim",
        "onsails/lspkind-nvim",
        "ray-x/lsp_signature.nvim",
        "jose-elias-alvarez/nvim-lsp-ts-utils"
      }
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
      "sindrets/diffview.nvim",
      config = function()
        require "plugins/diffview"
      end
    }
    use {
      "akinsho/bufferline.nvim",
      config = function()
        require "plugins/bufferline"
      end,
      requires = "kyazdani42/nvim-web-devicons"
    }
    use {
      "vuki656/package-info.nvim",
      config = function()
        require("package-info").setup()
      end,
      requires = "MunifTanjim/nui.nvim"
    }
    use {"npxbr/glow.nvim", run = "GlowInstall"}
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
    use "jbyuki/venn.nvim"
    use "editorconfig/editorconfig-vim"
    use {
      "jameshiew/nvim-magic",
      config = function()
        require("nvim-magic").setup(
          {
            use_default_keymap = false
          }
        )
      end,
      requires = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim"
      }
    }

    use {
      "mfussenegger/nvim-jdtls",
      config = function()
        vim.cmd(
          [[
          augroup jdtls_lsp
          autocmd!
          autocmd FileType java lua require'plugins/java-lsp'.setup()
          augroup end
        ]]
        )
      end
    }
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
        "David-Kunz/cmp-npm"
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
      "NTBBloodbath/rest.nvim",
      requires = {"nvim-lua/plenary.nvim"},
      config = function()
        require("rest-nvim").setup(
          {
            -- Open request results in a horizontal split
            result_split_horizontal = false,
            -- Skip SSL verification, useful for unknown certificates
            skip_ssl_verification = false,
            -- Highlight request on run
            highlight = {
              enabled = true,
              timeout = 150
            },
            -- Jump to request line on run
            jump_to_request = false
          }
        )
      end
    }
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
      "zbirenbaum/copilot.lua",
      event = {"VimEnter"},
      config = function()
        vim.defer_fn(
          function()
            require("copilot").setup({server_opts_overrides = {trace = "verbose", name = "AI"}})
          end,
          100
        )
      end
    }
    use {
      "zbirenbaum/copilot-cmp",
      after = {"copilot.lua", "nvim-cmp"}
    }
    use {
      "David-Kunz/cmp-npm",
      requires = {
        "nvim-lua/plenary.nvim"
      }
    }
    use {
      "SmiteshP/nvim-gps",
      requires = "nvim-treesitter/nvim-treesitter"
    }
    use {
      "rebelot/heirline.nvim",
      config = function()
        require "plugins/heirline"
      end,
      requires = {
        "kyazdani42/nvim-web-devicons",
        "SmiteshP/nvim-gps"
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
  end
)
