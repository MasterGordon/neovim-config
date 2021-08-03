local gl = require("galaxyline")
local colors = require("galaxyline.theme").default
local theme = require("monokai")
local condition = require("galaxyline.condition")
local gls = gl.section
colors.bg = theme.classic.base3
gl.short_line_list = {"NvimTree", "vista", "dbui", "packer"}

gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {
        n = colors.green,
        i = colors.red,
        v = colors.blue,
        [""] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red
      }
      local mode_map = {
        ["n"] = "NORMAL ",
        ["no"] = "N·OPERATOR PENDING ",
        ["v"] = "VISUAL ",
        ["V"] = "V·LINE ",
        [""] = "V·BLOCK ",
        ["s"] = "SELECT ",
        ["S"] = "S·LINE ",
        [""] = "S·BLOCK ",
        ["i"] = "INSERT ",
        ["R"] = "REPLACE ",
        ["Rv"] = "V·REPLACE ",
        ["c"] = "COMMAND ",
        ["cv"] = "VIM EX ",
        ["ce"] = "EX ",
        ["r"] = "PROMPT ",
        ["rm"] = "MORE ",
        ["r?"] = "CONFIRM ",
        ["!"] = "SHELL ",
        ["t"] = "TERMINAL "
      }
      vim.api.nvim_command("hi GalaxyViMode guibg=" .. mode_color[vim.fn.mode()])
      return "  " .. mode_map[vim.fn.mode()]
    end,
    separator = " ",
    separator_highlight = {nil, colors.bg},
    highlight = {colors.bg, colors.bg, "bold"}
  }
}
gls.left[3] = {
  Macro = {
    provider = function()
      local reg = vim.fn.reg_recording()

      if (reg == nil) or (reg == "") then
        return ""
      else
        return " " .. vim.call("reg_recording") .. " "
      end
    end,
    highlight = {colors.red, colors.bg}
  }
}
gls.left[5] = {
  FileIcon = {
    provider = "FileIcon",
    condition = condition.buffer_not_empty,
    highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color, colors.bg}
  }
}

gls.left[6] = {
  FileName = {
    provider = "FileName",
    condition = condition.buffer_not_empty,
    highlight = {colors.magenta, colors.bg, "bold"}
  }
}

gls.left[7] = {
  LineInfo = {
    provider = "LineColumn",
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.fg, colors.bg}
  }
}

gls.left[8] = {
  PerCent = {
    provider = "LinePercent",
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.fg, colors.bg, "bold"}
  }
}

gls.left[9] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = {colors.red, colors.bg}
  }
}
gls.left[10] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",
    highlight = {colors.yellow, colors.bg}
  }
}

gls.left[11] = {
  DiagnosticHint = {
    provider = "DiagnosticHint",
    icon = "  ",
    highlight = {colors.cyan, colors.bg}
  }
}

gls.left[12] = {
  DiagnosticInfo = {
    provider = "DiagnosticInfo",
    icon = "  ",
    highlight = {colors.blue, colors.bg}
  }
}

gls.right[1] = {
  FileEncode = {
    provider = "FileEncode",
    condition = condition.hide_in_width,
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.green, colors.bg, "bold"}
  }
}

gls.right[2] = {
  FileFormat = {
    provider = "FileFormat",
    condition = condition.hide_in_width,
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.green, colors.bg, "bold"}
  }
}

gls.right[3] = {
  GitIcon = {
    provider = function()
      return "  "
    end,
    condition = condition.check_git_workspace,
    separator = " ",
    separator_highlight = {"NONE", colors.bg},
    highlight = {colors.violet, colors.bg, "bold"}
  }
}

gls.right[4] = {
  GitBranch = {
    provider = "GitBranch",
    condition = condition.check_git_workspace,
    highlight = {colors.violet, colors.bg, "bold"}
  }
}

gls.right[5] = {
  DiffAdd = {
    provider = "DiffAdd",
    separator = " ",
    separator_highlight = {nil, colors.bg},
    condition = condition.hide_in_width,
    icon = "  ",
    highlight = {colors.green, colors.bg}
  }
}
gls.right[6] = {
  DiffModified = {
    provider = "DiffModified",
    condition = condition.hide_in_width,
    icon = " 柳",
    highlight = {colors.orane, colors.bg}
  }
}
gls.right[7] = {
  DiffRemove = {
    provider = "DiffRemove",
    condition = condition.hide_in_width,
    icon = "  ",
    highlight = {colors.red, colors.bg}
  }
}

-- File type name
-- --------------

gls.short_line_left[1] = {
  ShortLineFileName = {
    provider = "FileName",
    condition = condition.buffer_not_empty,
    highlight = {colors.fg, colors.bg},
    separator = " ",
    separator_highlight = {nil, colors.bg}
  }
}

-- Buffer icon
-- -----------

gls.short_line_right[1] = {
  BufferIcon = {
    provider = "BufferIcon",
    highlight = {colors.fg, colors.bg}
  }
}
