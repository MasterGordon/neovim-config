---@diagnostic disable-next-line: missing-fields
local colors = require('tokyonight.colors').setup({ style = 'night' })
local utils = require('heirline.utils')

local M = {}
M.state = {
  hovered_bufnr = nil,
  tab_col_ranges = {},
}

local function get_listed_bufs()
  return vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted
  end, vim.api.nvim_list_bufs())
end

local function get_tab_width(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  name = name == '' and '[No Name]' or vim.fn.fnamemodify(name, ':t')
  local extra = vim.bo[bufnr].modified and 3 or 0
  return 7 + vim.fn.strdisplaywidth(name) + extra
end

local function rebuild_col_ranges()
  local col = 1
  local wins = vim.api.nvim_tabpage_list_wins(0)
  if #wins > 0 then
    local buf0 = vim.api.nvim_win_get_buf(wins[1])
    if vim.bo[buf0].filetype == 'neo-tree' then
      col = vim.api.nvim_win_get_width(wins[1]) + 3
    end
  end
  M.state.tab_col_ranges = {}
  for _, bufnr in ipairs(get_listed_bufs()) do
    local w = get_tab_width(bufnr)
    M.state.tab_col_ranges[bufnr] = { col, col + w - 1 }
    col = col + w
  end
end

local function get_tab_bg(self)
  if self.is_active then
    return utils.get_highlight('TabLineSel').bg
  elseif self.is_hovered then
    return utils.get_highlight('TabLineHover').bg
  else
    return utils.get_highlight('TabLine').bg
  end
end

local LeftCap = {
  provider = '🭅',
  hl = function(self)
    return { fg = get_tab_bg(self), bg = utils.get_highlight('TabLineFill').bg }
  end,
}

local RightCap = {
  provider = '🭐',
  hl = function(self)
    return { fg = get_tab_bg(self), bg = utils.get_highlight('TabLineFill').bg }
  end,
}

local TabIcon = {
  init = function(self)
    local ext = vim.fn.fnamemodify(self.filename, ':e')
    self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(self.filename, ext, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ') or '  '
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

local TabName = {
  provider = function(self)
    return self.filename == '' and '[No Name]' or vim.fn.fnamemodify(self.filename, ':t')
  end,
  hl = function(self)
    return { bold = self.is_active, italic = true }
  end,
}

local TabFlags = {
  provider = function(self)
    return vim.bo[self.bufnr].modified and ' [+]' or nil
  end,
  hl = { fg = colors.green },
}

local diag_signs = vim.diagnostic.config().signs.text or {}
local TabDiagnostics = {
  static = {
    error_icon = diag_signs[vim.diagnostic.severity.ERROR],
    warn_icon  = diag_signs[vim.diagnostic.severity.WARN],
    info_icon  = diag_signs[vim.diagnostic.severity.INFO],
    hint_icon  = diag_signs[vim.diagnostic.severity.HINT],
  },
  init = function(self)
    self.errors   = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.WARN })
    self.info     = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.INFO })
    self.hints    = #vim.diagnostic.get(self.bufnr, { severity = vim.diagnostic.severity.HINT })
  end,
  {
    provider = function(self)
      return self.errors > 0 and (' ' .. self.error_icon .. self.errors) or nil
    end,
    hl = { fg = colors.error },
  },
  {
    provider = function(self)
      return self.warnings > 0 and (' ' .. self.warn_icon .. self.warnings) or nil
    end,
    hl = { fg = colors.warning },
  },
  {
    provider = function(self)
      return self.info > 0 and (' ' .. self.info_icon .. self.info) or nil
    end,
    hl = { fg = colors.info },
  },
  {
    provider = function(self)
      return self.hints > 0 and (' ' .. self.hint_icon .. self.hints) or nil
    end,
    hl = { fg = colors.hint },
  },
}

local CloseSlot = {
  provider = function(self)
    return self.is_hovered and ' 󰅖' or '  '
  end,
  hl = function(self)
    if self.is_hovered then
      return { fg = colors.red }
    end
  end,
  on_click = {
    callback = function(_, minwid)
      vim.api.nvim_buf_delete(minwid, { force = false })
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = 'heirline_tabline_close_callback',
  },
}

local TabBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
    self.is_hovered = (M.state.hovered_bufnr == self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return 'TabLineSel'
    elseif self.is_hovered then
      return 'TabLineHover'
    else
      return 'TabLine'
    end
  end,
  on_click = {
    callback = function(_, minwid, _, button)
      if button == 'm' then
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
  LeftCap,
  TabIcon,
  TabName,
  TabFlags,
  TabDiagnostics,
  CloseSlot,
  RightCap,
}

local BufferLine = utils.make_buflist(
  TabBlock,
  { provider = '', hl = { fg = 'gray' } },
  { provider = '', hl = { fg = 'gray' } }
)

-- OSC 22: set mouse cursor shape via Kitty protocol
local pointer_active = false
local function set_pointer(enable)
  if enable == pointer_active then return end
  pointer_active = enable
  io.write(enable and '\x1b]22;pointer\x1b\\' or '\x1b]22;\x1b\\')
  io.flush()
end

vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function() set_pointer(false) end,
})

local function on_mouse_move()
  local pos = vim.fn.getmousepos()
  local new_hover = nil
  if pos.screenrow == 1 then
    rebuild_col_ranges()
    for bufnr, range in pairs(M.state.tab_col_ranges) do
      if pos.screencol >= range[1] and pos.screencol <= range[2] then
        new_hover = bufnr
        break
      end
    end
  end
  set_pointer(new_hover ~= nil)
  if new_hover ~= M.state.hovered_bufnr then
    M.state.hovered_bufnr = new_hover
    vim.cmd('redrawtabline')
  end
  return '<MouseMove>'
end

vim.keymap.set({ 'n', 'i', 'v' }, '<MouseMove>', on_mouse_move, { expr = true, noremap = true })

return { BufferLine = BufferLine, state = M.state }
