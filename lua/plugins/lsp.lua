vim.lsp.handlers["textDocument/codeAction"] = require "lsputil.codeAction".code_action_handler
vim.lsp.handlers["textDocument/references"] = require "lsputil.locations".references_handler
vim.lsp.handlers["textDocument/definition"] = require "lsputil.locations".definition_handler
vim.lsp.handlers["textDocument/declaration"] = require "lsputil.locations".declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = require "lsputil.locations".typeDefinition_handler
vim.lsp.handlers["textDocument/implementation"] = require "lsputil.locations".implementation_handler
vim.lsp.handlers["textDocument/documentSymbol"] = require "lsputil.symbols".document_handler
vim.lsp.handlers["workspace/symbol"] = require "lsputil.symbols".workspace_handler

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

-- Lsp Status
local lsp_status = require("lsp-status")

-- Register the progress handler
lsp_status.register_progress()

--- Completion Icons
require("lspkind").init({})

--- Languages
require "lspconfig".bashls.setup {}
require "lspconfig".ccls.setup {}
require "lspconfig".clangd.setup {}
require "lspconfig".cssls.setup {}
require "lspconfig".html.setup {}
require "lspconfig".pyright.setup {}
require "lspconfig".vimls.setup {}
require "lspconfig".yamlls.setup {}
require "lspconfig".texlab.setup {}

--- ESLINT

local eslint = {
  lintCommand = "eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {
    "%f(%l,%c): %tarning %m",
    "%f(%l,%c): %rror %m"
  }
}

--- ESLINT Actions
require("null-ls").config {}
require("lspconfig")["null-ls"].setup {}

require "lspconfig".efm.setup {
  init_options = {documentFormatting = true},
  filetypes = {"javascript", "typescript", "javascriptreact", "typescriptreact"},
  init_options = {documentFormatting = true},
  settings = {
    rootMarkers = {".eslintrc.js", ".git/"},
    languages = {
      javascript = {eslint},
      typescript = {eslint},
      typescriptreact = {eslint},
      javascriptreact = {eslint}
    }
  }
}

--- Keybindings

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
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  -- buf_set_keymap("n", "<leader>t", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<leader>d", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  lsp_status.on_attach(client, bufnr)
end

require "lspconfig".jsonls.setup {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150
  },
  settings = {
    json = require "json-schema"
  },
  capabilities = lsp_status.capabilities
}

require "lspconfig".tsserver.setup {
  on_attach = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")

    ts_utils.setup {
      eslint_bin = "eslint_d",
      eslint_enable_diagnostics = false
    }
    ts_utils.setup_client(client)
    on_attach(client, bufnr)
  end,
  flags = {
    debounce_text_changes = 150
  },
  capabilities = lsp_status.capabilities
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
    capabilities = lsp_status.capabilities
  }
end