vim.cmd([[let test#javascript#reactscripts#options = "--watchAll=false"]])
vim.cmd([[let test#javascriptreact#reactscripts#options = "--watchAll=false"]])
vim.cmd([[let test#typescript#reactscripts#options = "--watchAll=false"]])
vim.cmd([[let test#typescriptreact#reactscripts#options = "--watchAll=false"]])
vim.cmd(
  [[
augroup UltestRunner
    au!
    au BufWritePost *.test.* UltestNearest
    au BufWritePost *.spec.* UltestNearest
augroup END
]]
)
vim.g.ultest_virtual_text = 1
vim.g.ultest_output_on_run = 0
vim.g.ultest_pass_text = "🎉"
vim.g.ultest_fail_text = "💥"
vim.g.ultest_running_text = "⌛"
