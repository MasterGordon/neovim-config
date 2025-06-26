---@diagnostic disable-next-line: missing-fields
local colors = require('tokyonight.colors').setup({
  style = 'night',
})
local utils = require('heirline.utils')

local TablineFileName = {
  provider = function(self)
    -- self.filename will be defined later, just keep looking at the example!
    local filename = self.filename
    filename = filename == '' and '[No Name]' or vim.fn.fnamemodify(filename, ':t')
    return filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true }
  end,
}

local TablineFileFlags = {
  {
    provider = function(self)
      if vim.bo[self.bufnr].modified then
        return ' [+]'
      end
    end,
    hl = { fg = colors.green },
  },
  {
    provider = function(self)
      if not vim.bo[self.bufnr].modifiable or vim.bo[self.bufnr].readonly then
        return ' '
      end
    end,
    hl = { fg = 'orange' },
  },
}

local diag_signs = vim.diagnostic.config().signs.text or {}
local TablineDiagnostics = {
  static = {
    error_icon = diag_signs[1],
    warn_icon = diag_signs[2],
    info_icon = diag_signs[3],
    hint_icon = diag_signs[4],
  },
  init = function(self)
    self.errors = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.INFO })
    self.has_diags = self.errors > 0 or self.warnings > 0 or self.hints > 0 or self.info > 0
  end,
  {
    provider = function(self)
      return self.has_diags and ' '
    end,
  },
  {
    provider = function(self)
      local has_next = self.warnings > 0 or self.info > 0 or self.hints > 0
      return self.errors > 0 and (self.error_icon .. self.errors .. (has_next and ' ' or ''))
    end,
    hl = { fg = colors.error },
  },
  {
    provider = function(self)
      local has_next = self.info > 0 or self.hints > 0
      return self.warnings > 0 and (self.warn_icon .. self.warnings .. (has_next and ' ' or ''))
    end,
    hl = { fg = colors.warning },
  },
  {
    provider = function(self)
      local has_next = self.hints > 0
      return self.info > 0 and (self.info_icon .. self.info .. (has_next and ' ' or ''))
    end,
    hl = { fg = colors.info },
  },
  {
    provider = function(self)
      return self.hints > 0 and (self.hint_icon .. self.hints)
    end,
    hl = { fg = colors.hint },
  },
}

local TablineFileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (' ' .. self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

-- Here the filename block finally comes together
local TablineFileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return 'TabLineSel'
    else
      return 'TabLine'
    end
  end,
  on_click = {
    callback = function(_, minwid, _, button)
      if button == 'm' then -- close on mouse middle click
        vim.api.nvim_buf_delete(minwid, { force = true })
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = 'heirline_tabline_buffer_callback',
  },
  TablineFileIcon,
  TablineFileName,
  TablineFileFlags,
  TablineDiagnostics,
}

-- a nice "x" button to close the buffer
local TablineCloseButton = {
  condition = function(self)
    return not vim.bo[self.bufnr].modified
  end,
  { provider = ' ' },
  {
    provider = '',
    hl = { fg = 'gray' },
    on_click = {
      callback = function(_, minwid)
        vim.api.nvim_buf_delete(minwid, { force = false })
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = 'heirline_tabline_close_buffer_callback',
    },
  },
}

-- The final touch!
local TablineBufferBlock = {
  {
    hl = function(self)
      if self.is_active then
        return { fg = colors.dark3, bg = utils.get_highlight('TabLineSel').bg }
      else
        return { fg = colors.dark3, bg = utils.get_highlight('TabLine').bg }
      end
    end,
    provider = '',
  },
  TablineFileNameBlock,
  utils.surround({ '', '' }, function(self)
    if self.is_active then
      return utils.get_highlight('TabLineSel').bg
    else
      return utils.get_highlight('TabLine').bg
    end
  end, TablineCloseButton),
  {
    hl = function(self)
      if self.is_active then
        return { fg = colors.dark3, bg = utils.get_highlight('TabLineSel').bg }
      else
        return { fg = colors.dark3, bg = utils.get_highlight('TabLine').bg }
      end
    end,
    provider = '▐',
  },
}

-- and here we go
local BufferLine = utils.make_buflist(
  TablineBufferBlock,
  { provider = '', hl = { fg = 'gray' } }, -- left truncation, optional (defaults to "<")
  { provider = '', hl = { fg = 'gray' } } -- right trunctation, also optional (defaults to ...... yep, ">")
  -- by the way, open a lot of buffers and try clicking them ;)
)

return BufferLine
