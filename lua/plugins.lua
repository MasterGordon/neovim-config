local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system(
    {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath
    }
  )
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
  {
    "wbthomason/packer.nvim",
    {
      "MasterGordon/monokai.nvim",
      -- dir = "$HOME/git/monokai.nvim",
      config = function()
        require("monokai").setup()
      end
    },
    {
      "kyazdani42/nvim-web-devicons",
      config = function()
        require("plugins/icons")
      end
    },
    {
      "nvim-treesitter/playground",
      dependencies = {"nvim-treesitter/nvim-treesitter"}
    },
    {
      "nvim-treesitter/nvim-treesitter",
      config = function()
        require "plugins/treesitter"
      end,
      dependencies = {
        "JoosepAlviste/nvim-ts-context-commentstring",
        "windwp/nvim-ts-autotag",
        "windwp/nvim-autopairs"
      }
    },
    {
      "numToStr/Comment.nvim",
      after = "nvim-ts-context-commentstring",
      config = function()
        require("Comment").setup {
          pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
          mappings = {
            basic = true
          }
        }
      end
    },
    {
      "mhartington/formatter.nvim",
      config = function()
        require "plugins/formatter"
      end
    },
    {
      "neovim/nvim-lspconfig",
      config = function()
        require "plugins/lsp"
      end,
      dependencies = {
        "nvimtools/none-ls.nvim",
        "davidmh/cspell.nvim",
        "RishabhRD/popfix",
        "onsails/lspkind-nvim",
        "ray-x/lsp_signature.nvim",
        "jose-elias-alvarez/typescript.nvim",
        "hood/popui.nvim",
        "OmniSharp/omnisharp-vim",
        "yioneko/nvim-vtsls",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "jay-babu/mason-null-ls.nvim",
        "seblj/roslyn.nvim"
      }
    },
    {
      "luckasRanarison/tailwind-tools.nvim",
      dependencies = {"nvim-treesitter/nvim-treesitter"},
      opts = {
        document_color = {
          enabled = true, -- can be toggled by commands
          kind = "inline", -- "inline" | "foreground" | "background"
          inline_symbol = "󰝤 ", -- only used in inline mode
          debounce = 200 -- in milliseconds, only applied in insert mode
        },
        conceal = {
          enabled = false, -- can be toggled by commands
          min_length = nil, -- only conceal classes exceeding the provided length
          symbol = "󱏿", -- only a single character is allowed
          highlight = {
            -- extmark highlight options, see :h 'highlight'
            fg = "#38BDF8"
          }
        },
        custom_filetypes = {} -- see the extension section to learn how it works
      } -- your configuration
    },
    {
      "nvim-telescope/telescope.nvim",
      config = function()
        require("plugins/telescope")
      end,
      dependencies = {
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim"
      }
    },
    {
      "norcalli/nvim-colorizer.lua",
      config = function()
        require "colorizer".setup()
      end
    },
    {
      "folke/todo-comments.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {}
      end
    },
    {
      "lewis6991/gitsigns.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim"
      },
      config = function()
        require("gitsigns").setup()
      end
    },
    "editorconfig/editorconfig-vim",
    {
      "hrsh7th/nvim-cmp",
      config = function()
        require("plugins/cmp")
      end,
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-emoji",
        "David-Kunz/cmp-npm",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "saadparwaiz1/cmp_luasnip"
      }
    },
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp"
    },
    {
      "saecki/crates.nvim",
      event = {"BufRead Cargo.toml"},
      dependencies = {{"nvim-lua/plenary.nvim"}},
      config = function()
        require("crates").setup()
      end
    },
    "aklt/plantuml-syntax",
    -- {
    --   "github/copilot.vim",
    --   config = function()
    --     require("plugins/copilot")
    --   end
    -- },
    {
      "supermaven-inc/supermaven-nvim",
      config = function()
        if not (vim.fn.has_key(vim.fn.environ(), "LOAD_SUPERMAVEN") == 0) then
          require("supermaven-nvim").setup({})
        end
      end
    },
    {
      "ggandor/lightspeed.nvim",
      dependencies = {"tpope/vim-repeat"}
    },
    "jghauser/mkdir.nvim",
    {
      "David-Kunz/cmp-npm",
      dependencies = {
        "nvim-lua/plenary.nvim"
      }
    },
    {
      "rebelot/heirline.nvim",
      config = function()
        require "plugins/heirline"
      end,
      dependencies = {
        "kyazdani42/nvim-web-devicons",
        "nvim-treesitter/nvim-treesitter",
        "j-hui/fidget.nvim",
        "monokai.nvim",
        "nvim-lspconfig"
      }
    },
    "isobit/vim-caddyfile",
    {
      "nvim-neotest/neotest",
      config = function()
        require("plugins/neotest")
      end,
      event = {"BufRead *.test.*,*.spec.*,*Test.*,*.zig"},
      dependencies = {
        "lawrence-laz/neotest-zig",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "haydenmeade/neotest-jest",
        "monokai.nvim"
      }
    },
    {
      "andweeb/presence.nvim",
      config = function()
        require("presence"):setup()
      end
    },
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require("plugins/dap")
      end,
      dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "main",
      config = function()
        require("plugins/neo-tree")
      end,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
        "s1n7ax/nvim-window-picker",
        "monokai.nvim"
      }
    },
    {
      "luukvbaal/statuscol.nvim",
      config = function()
        require("statuscol").setup(
          {
            -- setopt = true,
            ft_ignore = {"neo-tree"}
          }
        )
      end
    },
    {
      "axelvc/template-string.nvim",
      config = function()
        require("template-string").setup()
      end
    },
    {
      "hedyhli/outline.nvim",
      config = function()
        -- Example mapping to toggle outline
        vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", {desc = "Toggle Outline"})

        require("outline").setup {}
      end
    }
  }
)
