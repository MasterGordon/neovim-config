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
      }
    }
  }
)

vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.lua,*.tsx,*.ts,*.js,*.jsx,*.json FormatWrite
augroup END
]],
  true
)
