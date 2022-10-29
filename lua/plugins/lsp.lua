local util = require "lspconfig.util"

vim.fn.sign_define("DiagnosticSignError", {text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = " ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = " ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"})
vim.fn.sign_define("DapBreakpoint", {text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DapStopped", {text = " ", texthl = "DiagnosticSignInfo"})

--- Completion Icons
require("lspkind").init({})

--- Null-LS

require("null-ls").setup(
  {
    sources = {
      require("null-ls").builtins.diagnostics.cspell.with(
        {
          diagnostics_postprocess = function(diagnostic)
            diagnostic.severity = vim.diagnostic.severity["WARN"]
          end
        }
      )
    }
  }
)

--- Languages
require "lspconfig".html.setup {}
require "lspconfig".vimls.setup {}
require "lspconfig".yamlls.setup {}

local nvim_lsp = require("lspconfig")

-- Mappings.
local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
vim.api.nvim_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
-- buf_set_keymap("n", "<leader>t", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
vim.api.nvim_set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>CodeActionMenu<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", opts)
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end
end
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

require "lspconfig".jsonls.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150
  },
  settings = {
    json = require "json-schema"
  },
  capabilities = capabilities
}

require "lspconfig".tsserver.setup {
  on_attach = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")

    ts_utils.setup {
      -- eslint_bin = "eslint_d",
      eslint_enable_diagnostics = false
    }
    ts_utils.setup_client(client)
    on_attach(client, bufnr)
  end,
  flags = {
    debounce_text_changes = 300
  },
  capabilities = capabilities
}

require "lspconfig".eslint.setup {
  on_attach = on_attach,
  root_dir = util.root_pattern(
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json"
  ),
  handlers = {
    ["eslint/openDoc"] = function(_, result)
      if not result then
        return
      end
      print(result.url)
      return {}
    end
  },
  capabilities = capabilities
}

--[[ require "lspconfig".java_language_server.setup {
  on_attach = on_attach,
  cmd = {"java-language-server"}
} ]]
local servers = {"pyright", "bashls", "clangd", "cssls", "texlab", "prismals", "csharp_ls"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150
    },
    capabilities = capabilities
  }
end

nvim_lsp.rust_analyzer.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150
  },
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module"
        },
        prefix = "crate"
      },
      cargo = {
        buildScripts = {
          enable = true
        }
      },
      procMacro = {
        enable = true
      }
    }
  }
}
