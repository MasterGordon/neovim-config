local util = require "lspconfig.util"

vim.fn.sign_define("DiagnosticSignError", {text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DiagnosticSignWarn", {text = " ", texthl = "DiagnosticSignWarn"})
vim.fn.sign_define("DiagnosticSignInfo", {text = " ", texthl = "DiagnosticSignInfo"})
vim.fn.sign_define("DiagnosticSignHint", {text = " ", texthl = "DiagnosticSignHint"})
vim.fn.sign_define("DapBreakpoint", {text = " ", texthl = "DiagnosticSignError"})
vim.fn.sign_define("DapStopped", {text = " ", texthl = "DiagnosticSignInfo"})

vim.ui.select = require "popui.ui-overrider"
vim.ui.input = require "popui.input-overrider"

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
      ),
      require("typescript.extensions.null-ls.code-actions")
    }
  }
)

-- local lsp = require "lspconfig"
-- vim.lsp.start(
--   {
--     cmd = {"bun", "/home/gordon/git/lsp/index.ts", "--stdio"},
--     filetypes = {"typescript"},
--     name = "blacklist",
--     root_dir = vim.fn.getcwd()
--   }
-- )

--- Languages
require "lspconfig".html.setup {}
require "lspconfig".vimls.setup {}
require "lspconfig".yamlls.setup {
  settings = {
    yaml = {
      keyOrdering = false,
      schemas = {
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/master/all.json"] = "/*.k8s.yaml",
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/master/all.json"] = "/*.k8s.yml",
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/master/all.json"] = "k8s/*.yaml",
        ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/master/all.json"] = "k8s/*.yml"
      }
    }
  }
}

local nvim_lsp = require("lspconfig")

local function codeAction()
  if vim.bo.filetype == "cs" then
    vim.lsp.buf.code_action()
  else
    vim.cmd [[CodeActionMenu]]
  end
end

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
-- vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>CodeActionMenu<CR>", opts)
vim.keymap.set("n", "<leader>a", codeAction, opts)
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

-- require "lspconfig".tsserver.setup {
--   on_attach = function(client, bufnr)
--     local ts_utils = require("nvim-lsp-ts-utils")
--
--     ts_utils.setup {
--       -- eslint_bin = "eslint_d",
--       eslint_enable_diagnostics = false
--     }
--     ts_utils.setup_client(client)
--     on_attach(client, bufnr)
--   end,
--   flags = {
--     debounce_text_changes = 300
--   },
--   capabilities = capabilities
-- }

require("typescript").setup(
  {
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false, -- enable debug logging for commands
    go_to_source_definition = {
      fallback = true -- fall back to standard LSP definition on failure
    },
    server = {
      -- pass options to lspconfig's setup method
      on_attach = on_attach,
      capabilities = capabilities
    }
  }
)

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
local servers = {"pyright", "bashls", "clangd", "cssls", "texlab", "prismals", "solidity", "zls"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150
    },
    capabilities = capabilities
  }
end

nvim_lsp.omnisharp.setup {
  cmd = {"OmniSharp"},
  enable_editorconfig_support = true,
  enable_roslyn_analyzers = true,
  enable_import_completion = true,
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = {
      full = vim.empty_dict(),
      legend = {
        tokenModifiers = {"static_symbol"},
        tokenTypes = {
          "comment",
          "excluded_code",
          "identifier",
          "keyword",
          "keyword_control",
          "number",
          "operator",
          "operator_overloaded",
          "preprocessor_keyword",
          "string",
          "whitespace",
          "text",
          "static_symbol",
          "preprocessor_text",
          "punctuation",
          "string_verbatim",
          "string_escape_character",
          "class_name",
          "delegate_name",
          "enum_name",
          "interface_name",
          "module_name",
          "struct_name",
          "type_parameter_name",
          "field_name",
          "enum_member_name",
          "constant_name",
          "local_name",
          "parameter_name",
          "method_name",
          "extension_method_name",
          "property_name",
          "event_name",
          "namespace_name",
          "label_name",
          "xml_doc_comment_attribute_name",
          "xml_doc_comment_attribute_quotes",
          "xml_doc_comment_attribute_value",
          "xml_doc_comment_cdata_section",
          "xml_doc_comment_comment",
          "xml_doc_comment_delimiter",
          "xml_doc_comment_entity_reference",
          "xml_doc_comment_name",
          "xml_doc_comment_processing_instruction",
          "xml_doc_comment_text",
          "xml_literal_attribute_name",
          "xml_literal_attribute_quotes",
          "xml_literal_attribute_value",
          "xml_literal_cdata_section",
          "xml_literal_comment",
          "xml_literal_delimiter",
          "xml_literal_embedded_expression",
          "xml_literal_entity_reference",
          "xml_literal_name",
          "xml_literal_processing_instruction",
          "xml_literal_text",
          "regex_comment",
          "regex_character_class",
          "regex_anchor",
          "regex_quantifier",
          "regex_grouping",
          "regex_alternation",
          "regex_text",
          "regex_self_escaped_character",
          "regex_other_escape"
        }
      },
      range = true
    }
    on_attach(client, bufnr)
  end,
  flags = {
    debounce_text_changes = 150
  },
  capabilities = capabilities
}

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
