-- dapui
require("dapui").setup(
  {
    controls = {
      enabled = false
    }
  }
)
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

vim.g.dotnet_build_project = function()
  local default_path = vim.fn.getcwd() .. "/"
  if vim.g["dotnet_last_proj_path"] ~= nil then
    default_path = vim.g["dotnet_last_proj_path"]
  end
  local cmd = "dotnet build -c Debug > /dev/null"
  print("")
  print("Cmd to execute: " .. cmd)
  local f = os.execute(cmd)
  if f == 0 then
    print("\nBuild: ✔️ ")
  else
    print("\nBuild: ❌ (code: " .. f .. ")")
  end
end

vim.g.dotnet_get_dll_path = function()
  local cwd = vim.fn.getcwd()
  local solution = vim.fn.glob(cwd .. "/*.csproj")
  local projectName = vim.fn.fnamemodify(solution, ":t:r")
  local dll = cwd .. "/bin/Debug/net7.0/linux-x64/" .. projectName .. ".dll"
  return dll
end

local config = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      if vim.fn.confirm("Should I recompile first?", "&yes\n&no", 2) == 1 then
        vim.g.dotnet_build_project()
      end
      return vim.g.dotnet_get_dll_path()
    end
  }
}

dap.configurations.cs = config

-- keybindings
local api = vim.api
local keymap_restore = {}
dap.listeners.after["event_initialized"]["me"] = function()
  for _, buf in pairs(api.nvim_list_bufs()) do
    local keymaps = api.nvim_buf_get_keymap(buf, "n")
    for _, keymap in pairs(keymaps) do
      if keymap.lhs == "K" then
        table.insert(keymap_restore, keymap)
        api.nvim_buf_del_keymap(buf, "n", "K")
      end
    end
  end
  api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', {silent = true})
end

dap.listeners.after["event_terminated"]["me"] = function()
  for _, keymap in pairs(keymap_restore) do
    api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, {silent = keymap.silent == 1})
  end
  keymap_restore = {}
end
api.nvim_set_keymap("n", "<leader>B", ":lua require'dap'.toggle_breakpoint()<CR>", {noremap = true, silent = true})
api.nvim_set_keymap("n", "<f5>", ":lua require'dap'.continue()<CR>", {noremap = true, silent = true})
