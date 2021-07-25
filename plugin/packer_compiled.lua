-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/gordon/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/gordon/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/gordon/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/gordon/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/gordon/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["formatter.nvim"] = {
    config = { "\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins/formatter\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/formatter.nvim"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins/galaxyline\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  kommentary = {
    config = { "\27LJ\1\2^\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\25update_commentstring&ts_context_commentstring.internal\frequire¾\1\1\0\4\0\a\0\n4\0\0\0%\1\1\0>\0\2\0027\0\2\0%\1\3\0003\2\4\0001\3\5\0:\3\6\2>\0\3\1G\0\1\0\18hook_function\0\1\0\2\31multi_line_comment_strings\tauto\31single_line_comment_string\tauto\20typescriptreact\23configure_language\22kommentary.config\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/kommentary"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["monokai.nvim"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/monokai.nvim"
  },
  ["numb.nvim"] = {
    config = { "\27LJ\1\0022\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\tnumb\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/numb.nvim"
  },
  ["nvim-autopairs"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-autopairs"
  },
  ["nvim-blame-line"] = {
    config = { "\27LJ\1\2R\0\0\2\1\3\0\6+\0\0\0007\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0\0\0'autocmd BufEnter * EnableBlameLine\14nvim_exec\bapi\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-blame-line"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\1\0027\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    config = { "\27LJ\1\2-\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\18plugins/compe\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\1\2+\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\16plugins/lsp\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lsputils"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-lsputils"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins/nvim-tree\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\1\2œ\2\0\0\3\0\14\0\0214\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\0014\0\0\0%\1\4\0>\0\2\0027\0\2\0003\1\6\0003\2\5\0:\2\a\0013\2\b\0:\2\t\0013\2\n\0:\2\v\0013\2\f\0:\2\r\1>\0\2\1G\0\1\0\fautotag\1\0\1\venable\2\vindent\1\0\1\venable\2\14highlight\1\0\1\venable\2\26context_commentstring\1\0\0\1\0\2\19enable_autocmd\2\venable\2\28nvim-treesitter.configs\1\0\1\30enable_check_bracket_line\2\nsetup\19nvim-autopairs\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  popfix = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/popfix"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-signify"] = {
    config = { "\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20plugins/signify\frequire\0" },
    loaded = true,
    path = "/home/gordon/.local/share/nvim/site/pack/packer/start/vim-signify"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: formatter.nvim
time([[Config for formatter.nvim]], true)
try_loadstring("\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins/formatter\frequire\0", "config", "formatter.nvim")
time([[Config for formatter.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\2œ\2\0\0\3\0\14\0\0214\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\3\0>\0\2\0014\0\0\0%\1\4\0>\0\2\0027\0\2\0003\1\6\0003\2\5\0:\2\a\0013\2\b\0:\2\t\0013\2\n\0:\2\v\0013\2\f\0:\2\r\1>\0\2\1G\0\1\0\fautotag\1\0\1\venable\2\vindent\1\0\1\venable\2\14highlight\1\0\1\venable\2\26context_commentstring\1\0\0\1\0\2\19enable_autocmd\2\venable\2\28nvim-treesitter.configs\1\0\1\30enable_check_bracket_line\2\nsetup\19nvim-autopairs\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: nvim-colorizer.lua
time([[Config for nvim-colorizer.lua]], true)
try_loadstring("\27LJ\1\0027\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
time([[Config for nvim-colorizer.lua]], false)
-- Config for: nvim-compe
time([[Config for nvim-compe]], true)
try_loadstring("\27LJ\1\2-\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\18plugins/compe\frequire\0", "config", "nvim-compe")
time([[Config for nvim-compe]], false)
-- Config for: numb.nvim
time([[Config for numb.nvim]], true)
try_loadstring("\27LJ\1\0022\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\tnumb\frequire\0", "config", "numb.nvim")
time([[Config for numb.nvim]], false)
-- Config for: nvim-blame-line
time([[Config for nvim-blame-line]], true)
try_loadstring("\27LJ\1\2R\0\0\2\1\3\0\6+\0\0\0007\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0\0\0'autocmd BufEnter * EnableBlameLine\14nvim_exec\bapi\0", "config", "nvim-blame-line")
time([[Config for nvim-blame-line]], false)
-- Config for: vim-signify
time([[Config for vim-signify]], true)
try_loadstring("\27LJ\1\2/\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\20plugins/signify\frequire\0", "config", "vim-signify")
time([[Config for vim-signify]], false)
-- Config for: kommentary
time([[Config for kommentary]], true)
try_loadstring("\27LJ\1\2^\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\25update_commentstring&ts_context_commentstring.internal\frequire¾\1\1\0\4\0\a\0\n4\0\0\0%\1\1\0>\0\2\0027\0\2\0%\1\3\0003\2\4\0001\3\5\0:\3\6\2>\0\3\1G\0\1\0\18hook_function\0\1\0\2\31multi_line_comment_strings\tauto\31single_line_comment_string\tauto\20typescriptreact\23configure_language\22kommentary.config\frequire\0", "config", "kommentary")
time([[Config for kommentary]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins/galaxyline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\1\2+\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\16plugins/lsp\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins/nvim-tree\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
