local selectX = function(n)
  return function(bufnr)
    local a = require("telescope.actions")
    local s = require("telescope.actions.state")
    local picker_name = s.get_current_picker(bufnr).prompt_title
    -- if not quick_prompts[picker_name] then
    --   -- Disable quick prompts to not press by accident
    --   -- TODO: Still type the number
    --   return
    -- end
    a.move_to_top(bufnr)
    for _ = 1, n - 1 do
      a.move_selection_next(bufnr)
    end
    a.select_default(bufnr)
  end
end

local dropdown_configs = {
  layout_config = {
    prompt_position = "top",
    vertical = {
      width = 80,
      height = 12
    }
  },
  border = {}
}

require("telescope").setup {
  file_ignore_patterns = {"package-lock.json"},
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(dropdown_configs)
    }
  },
  defaults = {
    mappings = {
      i = {
        ["<Esc>"] = "close",
        ["1"] = {selectX(1), type = "action"},
        ["2"] = {selectX(2), type = "action"},
        ["3"] = {selectX(3), type = "action"},
        ["4"] = {selectX(4), type = "action"},
        ["5"] = {selectX(5), type = "action"},
        ["6"] = {selectX(6), type = "action"},
        ["7"] = {selectX(7), type = "action"},
        ["8"] = {selectX(8), type = "action"},
        ["9"] = {selectX(9), type = "action"},
        ["0"] = {selectX(10), type = "action"}
      },
      n = {}
    }
  }
}
require("telescope").load_extension("ui-select")
