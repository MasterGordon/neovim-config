local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

require("nvim-gps").setup(
  {
    icons = {
      ["class-name"] = " ",
      ["function-name"] = " ",
      ["method-name"] = " ",
      ["container-name"] = "炙",
      ["tag-name"] = "炙"
    }
  }
)

vim.o.laststatus = 3

local colors = {
  bg = "#333842",
  brown = "#504945",
  white = "#f8f8f0",
  grey = "#8F908A",
  black = "#000000",
  pink = "#f92672",
  green = "#a6e22e",
  blue = "#66d9ef",
  yellow = "#e6db74",
  orange = "#fd971f",
  purple = "#ae81ff",
  red = "#e95678",
  diag = {
    warn = utils.get_highlight("DiagnosticWarn").fg,
    error = utils.get_highlight("DiagnosticError").fg,
    hint = utils.get_highlight("DiagnosticHint").fg,
    info = utils.get_highlight("DiagnosticInfo").fg
  },
  git = {
    del = utils.get_highlight("GitSignsDelete").fg,
    add = utils.get_highlight("GitSignsAdd").fg,
    change = utils.get_highlight("GitSignsChange").fg
  }
}

local ViMode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = {
      -- change the strings if you like it vvvvverbose!
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
    },
    mode_colors = {
      n = colors.green,
      i = colors.pink,
      v = colors.blue,
      V = colors.blue,
      [""] = colors.blue,
      c = colors.red,
      s = colors.purple,
      S = colors.purple,
      [""] = colors.purple,
      R = colors.orange,
      r = colors.orange,
      ["!"] = colors.red,
      t = colors.red
    }
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = function(self)
    return " %2(" .. self.mode_names[self.mode] .. "%)"
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return {bg = self.mode_colors[mode], fg = colors.bg, bold = true}
  end
}

local FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end
}
-- We can now define some children separately and add them later

local FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ":e")
    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension, {default = true})
  end,
  provider = function(self)
    return self.icon and (self.icon .. " ")
  end,
  hl = function(self)
    return {fg = self.icon_color, bg = colors.bg}
  end
}

local FileName = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then
      return "[No Name]"
    end
    -- now, if the filename would occupy more than 1/4th of the available
    -- space, we trim the file path to its initials
    -- See Flexible Components section below for dynamic truncation
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
  hl = {fg = utils.get_highlight("Directory").fg, bg = colors.bg}
}

local FileFlags = {
  {
    provider = function()
      if vim.bo.modified then
        return " [+]"
      end
    end,
    hl = {fg = colors.green, bg = colors.bg}
  },
  {
    provider = function()
      if (not vim.bo.modifiable) or vim.bo.readonly then
        return ""
      end
    end,
    hl = {fg = colors.orange, bg = colors.bg}
  }
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return {fg = colors.cyan, bold = true, force = true, bg = colors.bg}
    end
  end
}

-- let's add the children to our FileNameBlock component
FileNameBlock =
  utils.insert(
  FileNameBlock,
  FileIcon,
  utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
  unpack(FileFlags), -- A small optimisation, since their parent does nothing
  {provider = "%<"} -- this means that the statusline is cut here when there's not enough space
)

local Diagnostics = {
  condition = conditions.has_diagnostics,
  static = {
    error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.ERROR})
    self.warnings = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.WARN})
    self.hints = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.HINT})
    self.info = #vim.diagnostic.get(0, {severity = vim.diagnostic.severity.INFO})
  end,
  {
    provider = function(self)
      -- 0 is just another output, we can decide to print it or not!
      return self.errors > 0 and (self.error_icon .. self.errors .. " ")
    end,
    hl = {fg = colors.diag.error, bg = colors.bg}
  },
  {
    provider = function(self)
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
    end,
    hl = {fg = colors.diag.warn, bg = colors.bg}
  },
  {
    provider = function(self)
      return self.info > 0 and (self.info_icon .. self.info .. " ")
    end,
    hl = {fg = colors.diag.info, bg = colors.bg}
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = {fg = colors.diag.hint, bg = colors.bg}
  }
}

local Git = {
  condition = conditions.is_git_repo,
  init = function(self)
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,
  hl = {fg = colors.orange, bg = colors.bg},
  {
    -- git branch name
    provider = function(self)
      return " " .. self.status_dict.head
    end,
    hl = {bold = true, bg = colors.bg}
  },
  -- You could handle delimiters, icons and counts similar to Diagnostics
  {
    condition = function(self)
      return self.has_changes
    end,
    provider = " "
  },
  {
    provider = function(self)
      local count = self.status_dict.added or 0
      return count > 0 and ("  " .. count)
    end,
    hl = {fg = colors.git.add, bg = colors.bg}
  },
  {
    provider = function(self)
      local count = self.status_dict.removed or 0
      return count > 0 and ("  " .. count)
    end,
    hl = {fg = colors.git.del, bg = colors.bg}
  },
  {
    provider = function(self)
      local count = self.status_dict.changed or 0
      return count > 0 and ("  " .. count)
    end,
    hl = {fg = colors.git.change, bg = colors.bg}
  }
}

local WorkDir = {
  provider = function()
    local icon = " "
    local cwd = vim.fn.getcwd(0)
    cwd = vim.fn.fnamemodify(cwd, ":~")
    if not conditions.width_percent_below(#cwd, 0.25) then
      cwd = vim.fn.pathshorten(cwd)
    end
    local trail = cwd:sub(-1) == "/" and "" or "/"
    return icon .. cwd .. trail
  end,
  hl = {fg = colors.blue, bold = true, bg = colors.bg}
}

local TerminalName = {
  -- we could add a condition to check that buftype == 'terminal'
  -- or we could do that later (see #conditional-statuslines below)
  provider = function()
    local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
    return " " .. tname
  end,
  hl = {bold = true, bg = colors.bg}
}

local Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = "%7 %p%% Ln %l, Col %c"
}

local Align = {provider = "%=", hl = {bg = colors.bg}}
local Space = {provider = "  "}

local FileInfoBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end
}

local FileType = {
  provider = function()
    return vim.bo.filetype
  end,
  hl = {fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg}
}

local FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc:upper()
  end
}

FileInfoBlock =
  utils.insert(
  FileInfoBlock,
  FileEncoding,
  Space,
  FileIcon,
  FileType,
  {provider = "%<"} -- this means that the statusline is cut here when there's not enough space
)

local FileNameShort = {
  provider = function(self)
    -- first, trim the pattern relative to the current directory. For other
    -- options, see :h filename-modifers
    local filename = vim.fn.fnamemodify(self.filename, ":t")
    if filename == "" then
      return "[No Name]"
    end
    return filename
  end,
  hl = {fg = colors.gray, bg = colors.bg}
}

local FileNameShortBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end
}

FileNameShortBlock =
  utils.insert(
  FileNameShortBlock,
  FileIcon,
  FileNameShort,
  {provider = "%<"} -- this means that the statusline is cut here when there's not enough space
)

local Gps = {
  condition = require("nvim-gps").is_available,
  provider = function()
    local loc = require("nvim-gps").get_location()
    if loc == "" then
      return ""
    end
    return "> " .. loc
  end,
  hl = {fg = colors.gray, bg = colors.bg}
}

local DefaultStatusline = {
  ViMode,
  Space,
  FileNameBlock,
  Space,
  Diagnostics,
  Align,
  Ruler,
  Space,
  FileInfoBlock,
  Space,
  Git
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches(
      {
        buftype = {"nofile", "prompt", "help", "quickfix"},
        filetype = {"^git.*", "fugitive"}
      }
    )
  end,
  FileType,
  Space,
  Align
}

local TerminalStatusline = {
  condition = function()
    return conditions.buffer_matches({buftype = {"terminal"}})
  end,
  TerminalName,
  Align
}

local StatusLines = {
  init = utils.pick_child_on_condition,
  SpecialStatusline,
  TerminalStatusline,
  DefaultStatusline
}

local GSpace = {provider = " ", hl = {bg = colors.bg}}

local WinBars = {
  init = utils.pick_child_on_condition,
  {
    -- Hide the winbar for special buffers
    condition = function()
      return conditions.buffer_matches(
        {
          buftype = {"nofile", "prompt", "help", "quickfix"},
          filetype = {"^git.*", "fugitive"}
        }
      )
    end,
    provider = ""
  },
  {
    -- An inactive winbar for regular files
    condition = function()
      return conditions.buffer_matches({buftype = {"terminal"}}) and not conditions.is_active()
    end,
    utils.surround({"", ""}, colors.bright_bg, {hl = {fg = "gray", force = true}, GSpace, TerminalName, Align})
  },
  {
    -- A special winbar for terminals
    condition = function()
      return conditions.buffer_matches({buftype = {"terminal"}})
    end,
    utils.surround(
      {"", ""},
      colors.dark_red,
      {
        GSpace,
        TerminalName,
        Align
      }
    )
  },
  {
    -- An inactive winbar for regular files
    condition = function()
      return not conditions.is_active()
    end,
    utils.surround({"", ""}, colors.bright_bg, {hl = {fg = "gray", force = true}, GSpace, FileNameShortBlock, Align})
  },
  -- A winbar for regular files
  {GSpace, FileNameShortBlock, GSpace, Gps, Align}
}

require "heirline".setup(StatusLines, WinBars)