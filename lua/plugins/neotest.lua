require("neotest").setup(
  {
    adapters = {
      require("neotest-jest")(
        {
          jestCommand = "npx jest"
        }
      )
    },
    icons = {
      passed = "🌈",
      skipped = "🌙",
      failed = "⛈️",
      running = "☀️"
    },
    highlights = {
      passed = "DiagnosticSignSuccess",
      skipped = "DiagnosticSignInfo",
      failed = "DiagnosticSignError",
      running = "DiagnosticSignWarn"
    }
  }
)

local keymap = vim.api.nvim_set_keymap

keymap("n", "<leader>tf", ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', {silent = true, noremap = true})
keymap("n", "<leader>tn", ':lua require("neotest").run.run()<CR>', {silent = true})
keymap("n", "<leader>td", ':lua require("neotest").output.open({enter=true,short=true})<CR>', {silent = true})
