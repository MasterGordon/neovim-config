local prettierd = function()
  return {
    exe = "prettierd",
    args = {"'" .. vim.api.nvim_buf_get_name(0) .. "'"},
    stdin = true
  }
end

require("formatter").setup(
  {
    logging = false,
    filetype = {
      typescriptreact = {prettierd},
      json = {prettierd},
      jsonc = {prettierd},
      css = {prettierd},
      scss = {prettierd},
      markdown = {prettierd},
      typescript = {prettierd},
      javascript = {prettierd},
      javascriptreact = {prettierd},
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      },
      rust = {
        function()
          return {
            exe = "rustfmt",
            args = {"--emit=stdout", "--edition=2021"},
            stdin = true
          }
        end
      },
      cpp = {
        function()
          return {
            exe = "clang-format",
            args = {"'" .. vim.api.nvim_buf_get_name(0) .. "'"},
            stdin = true
          }
        end
      },
      prisma = {
        function()
          return {
            exe = "npx",
            args = {"prisma", "format", "--schema=" .. vim.api.nvim_buf_get_name(0)},
            stdin = false
          }
        end
      },
      swift = {
        function()
          return {
            exe = "swift-format",
            stdin = true
          }
        end
      },
      xml = {
        function()
          return {
            exe = "xmllint",
            args = {"--format", "-"},
            stdin = true
          }
        end
      },
      cs = {
        function()
          return {
            exe = "dotnet-csharpier",
            args = {"--write-stdout"},
            stdin = true
          }
        end
      },
      -- ocaml
      ocaml = {
        function()
          return {
            exe = "ocamlformat",
            args = {"--name", vim.api.nvim_buf_get_name(0), "-"},
            stdin = true
          }
        end
      },
      php = {
        function()
          return {
            exe = "vendor/bin/php-cs-fixer",
            args = {
              "fix"
            },
            stdin = false,
            ignore_exitcode = true
          }
        end
      }
    }
  }
)

vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.cs,*.h,*.cpp,*.rs,*.lua,*.tsx,*.ts,*.js,*.jsx,*.json,*.jsonc,*.swift,*.xml,*.sln,*.csproj,*.ml,*.php FormatWrite
augroup END
]],
  true
)
-- local formatGrp = vim.api.nvim_create_augroup("Format", {clear = true})
-- vim.api.nvim_create_autocmd(
--   "BufWritePre",
--   {
--     pattern = "*.php",
--     command = "lua vim.lsp.buf.format { async = false }",
--     group = formatGrp
--   }
-- )

-- local function organize_imports()
--   local params = {
--     command = "typescript.organizeImports",
--     arguments = {vim.api.nvim_buf_get_name(0)},
--     title = ""
--   }
--   vim.lsp.buf.execute_command(params)
-- end
