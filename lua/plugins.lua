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
        require("nvim-web-devicons").set_icon {
          ["test.ts"] = {
            icon = "",
            color = "#519aba",
            name = "TsTest"
          },
          ["test.tsx"] = {
            icon = "",
            color = "#519aba",
            name = "TsTest"
          },
          ["test.js"] = {
            icon = "",
            color = "#cbcb41",
            name = "JsTest"
          },
          ["test.jsx"] = {
            icon = "",
            color = "#cbcb41",
            name = "JsTest"
          }
        }
      end
    }

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
      "RishabhRD/nvim-lsputils",
      requires = {"RishabhRD/popfix"}
    }
    use {
      "neovim/nvim-lspconfig",
      config = function()
        require "plugins/lsp"
      end,
      requires = {
        "RishabhRD/nvim-lsputils",
        "onsails/lspkind-nvim",
        "ray-x/lsp_signature.nvim",
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        "jose-elias-alvarez/null-ls.nvim",
        "nvim-lua/lsp-status.nvim"
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
      "akinsho/nvim-bufferline.lua",
      config = function()
        require "plugins/bufferline"
      end,
      requires = "kyazdani42/nvim-web-devicons"
    }
    use {
      "rcarriga/vim-ultest",
      config = function()
        require "plugins/ultest"
      end,
      requires = {"vim-test/vim-test"},
      run = ":UpdateRemotePlugins"
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
      tag = "v0.2.1", -- recommended to pin to a tag and update manually as there may be breaking changes
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
      "ms-jpq/coq_nvim",
      branch = "coq",
      config = function()
        require "plugins/coq"
      end,
      setup = function()
        vim.cmd("let g:coq_settings = { 'auto_start': v:true, 'keymaps': {'manual_completion': '<c-f>'} }")
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
  end
)
