vim.ui.select = require "popui.ui-overrider"

local signError = vim.fn.sign_getdefined("DiagnosticSignError")
signError["text"] = ""
signError["texthl"] = "DiagnosticSignError"
vim.fn.sign_define("DiagnosticSignError", signError)
local signWarn = vim.fn.sign_getdefined("DiagnosticSignWarn")
signWarn["text"] = ""
signWarn["texthl"] = "DiagnosticSignWarn"
vim.fn.sign_define("DiagnosticSignWarn", signWarn)
local signHint = vim.fn.sign_getdefined("DiagnosticSignHint")
signHint["text"] = ""
signHint["texthl"] = "DiagnosticSignHint"
vim.fn.sign_define("DiagnosticSignHint", signHint)
vim.fn.sign_define("DiagnosticSignInfo", signHint)

--- Completion Icons
require("lspkind").init({})

--- Languages
require "lspconfig".html.setup {}
require "lspconfig".vimls.setup {}
require "lspconfig".yamlls.setup {}

local nvim_lsp = require("lspconfig")

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Mappings.
  local opts = {noremap = true, silent = true}
  buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  -- buf_set_keymap("n", "<leader>t", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "<leader>d", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
end
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

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
local servers = {"pyright", "bashls", "clangd", "cssls", "texlab", "rust_analyzer"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150
    },
    capabilities = capabilities
  }
end
