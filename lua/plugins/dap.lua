-- dapui
require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- C#
dap.adapters.coreclr = {
  type = "executable",
  command = "netcoredbg",
  args = {"--interpreter=vscode"}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      local cwd = vim.fn.getcwd()
      local solution = vim.fn.glob(cwd .. "/*.csproj")
      local projectName = vim.fn.fnamemodify(solution, ":t:r")
      local proj = cwd .. "/bin/Debug/net6.0/" .. projectName .. ".dll"
      print(proj)
      return proj
      -- return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
    end
  }
}

-- keybindings
vim.api.nvim_set_keymap("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>dc", ":lua require'dap'.continue()<CR>", {noremap = true, silent = true})
