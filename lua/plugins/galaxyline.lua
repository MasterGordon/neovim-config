local gl = require("galaxyline")
local colors = require("galaxyline.themes.colors").get_color
local theme = require("monokai")
local condition = require("galaxyline.condition")
local gls = gl.section
gl.short_line_list = {"NvimTree", "vista", "dbui", "packer"}
local color_bg = "#333842"

gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local mode_color = {
        n = colors("green"),
        i = colors("red"),
        v = colors("blue"),
        [""] = colors("blue"),
        V = colors("blue"),
        c = colors("magenta"),
        no = colors("red"),
        s = colors("orange"),
        S = colors("orange"),
        [""] = colors("orange"),
        ic = colors("yellow"),
        R = colors("violet"),
        Rv = colors("violet"),
        cv = colors("red"),
        ce = colors("red"),
        r = colors("cyan"),
        rm = colors("cyan"),
        ["r?"] = colors("cyan"),
        ["!"] = colors("red"),
        t = colors("red")
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
      vim.api.nvim_command("hi GalaxyViMode guibg=" .. mode_color[vim.fn.mode()]())
      return "  " .. mode_map[vim.fn.mode()]
    end,
    separator = " ",
    separator_highlight = {nil, color_bg},
    highlight = {color_bg, color_bg, "bold"}
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
    highlight = {colors("red"), color_bg}
  }
}
gls.left[5] = {
  FileIcon = {
    provider = "FileIcon",
    condition = condition.buffer_not_empty,
    highlight = {require("galaxyline.providers.fileinfo").get_file_icon_color, color_bg}
  }
}

gls.left[6] = {
  FileName = {
    provider = "FileName",
    condition = condition.buffer_not_empty,
    highlight = {colors("magenta"), color_bg, "bold"}
  }
}

gls.left[7] = {
  LineInfo = {
    provider = "LineColumn",
    separator = " ",
    separator_highlight = {"NONE", color_bg},
    highlight = {colors("fg"), color_bg}
  }
}

gls.left[8] = {
  PerCent = {
    provider = "LinePercent",
    separator = " ",
    separator_highlight = {"NONE", color_bg},
    highlight = {colors("fg"), color_bg, "bold"}
  }
}

gls.left[9] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = {colors("red"), color_bg}
  }
}
gls.left[10] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",
    highlight = {colors("yellow"), color_bg}
  }
}

gls.left[11] = {
  DiagnosticHint = {
    provider = "DiagnosticHint",
    icon = "  ",
    highlight = {colors("cyan"), color_bg}
  }
}

gls.left[12] = {
  DiagnosticInfo = {
    provider = "DiagnosticInfo",
    icon = "  ",
    highlight = {colors("blue"), color_bg}
  }
}

gls.right[0] = {
  WordCount = {
    provider = function()
      local wc = vim.api.nvim_eval("wordcount()")
      if wc["visual_words"] then
        return wc["visual_words"]
      else
        return wc["words"]
      end
    end,
    icon = "  ",
    highlight = {colors("green"), color_bg}
  }
}
gls.right[1] = {
  FileEncode = {
    provider = "FileEncode",
    condition = condition.hide_in_width,
    separator = " ",
    separator_highlight = {"NONE", color_bg},
    highlight = {colors("green"), color_bg, "bold"}
  }
}

gls.right[2] = {
  FileFormat = {
    provider = "FileFormat",
    condition = condition.hide_in_width,
    separator = " ",
    separator_highlight = {"NONE", color_bg},
    highlight = {colors("green"), color_bg, "bold"}
  }
}

gls.right[3] = {
  GitIcon = {
    provider = function()
      return "  "
    end,
    condition = condition.check_git_workspace,
    separator = " ",
    separator_highlight = {"NONE", color_bg},
    highlight = {colors("violet"), color_bg, "bold"}
  }
}

gls.right[4] = {
  GitBranch = {
    provider = "GitBranch",
    condition = condition.check_git_workspace,
    highlight = {colors("violet"), color_bg, "bold"}
  }
}

gls.right[5] = {
  DiffAdd = {
    provider = "DiffAdd",
    separator = " ",
    separator_highlight = {nil, color_bg},
    condition = condition.hide_in_width,
    icon = "  ",
    highlight = {colors("green"), color_bg}
  }
}
gls.right[6] = {
  DiffModified = {
    provider = "DiffModified",
    condition = condition.hide_in_width,
    icon = "  ",
    highlight = {colors("orane"), color_bg}
  }
}
gls.right[7] = {
  DiffRemove = {
    provider = "DiffRemove",
    condition = condition.hide_in_width,
    icon = "  ",
    highlight = {colors("red"), color_bg}
  }
}

-- File type name
-- --------------

gls.short_line_left[1] = {
  ShortLineFileName = {
    provider = "FileName",
    condition = condition.buffer_not_empty,
    highlight = {colors("fg"), color_bg},
    separator = " ",
    separator_highlight = {nil, color_bg}
  }
}

-- Buffer icon
-- -----------

gls.short_line_right[1] = {
  BufferIcon = {
    provider = "BufferIcon",
    highlight = {colors("fg"), color_bg}
  }
}
