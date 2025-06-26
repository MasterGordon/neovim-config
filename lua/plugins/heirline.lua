return {
  'rebelot/heirline.nvim',
  dependencies = {
    'folke/tokyonight.nvim',
    'lewis6991/gitsigns.nvim',
  },
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    local colors = require('tokyonight.colors').setup({
      style = 'night',
    })
    local conditions = require('heirline.conditions')
    local utils = require('heirline.utils')
    vim.o.laststatus = 3
    vim.o.showtabline = 2

    local Align = { provider = '%=' }
    local Space = { provider = '  ' }
    local SmallSpace = { provider = ' ' }

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
          ['n'] = 'NORMAL ',
          ['no'] = 'N·OPERATOR PENDING ',
          ['v'] = 'VISUAL ',
          ['vs'] = 'VISUAL·S ',
          ['V'] = 'V·LINE ',
          ['Vs'] = 'V·LINE·S ',
          [''] = 'V·BLOCK ',
          ['s'] = 'SELECT ',
          ['S'] = 'S·LINE ',
          [''] = 'S·BLOCK ',
          ['i'] = 'INSERT ',
          ['ic'] = 'COMPLETION ',
          ['niI'] = 'INSERT ',
          ['niR'] = 'REPLACE ',
          ['niV'] = 'V·REPLACE ',
          ['R'] = 'REPLACE ',
          ['Rv'] = 'V·REPLACE ',
          ['c'] = 'COMMAND ',
          ['cv'] = 'VIM EX ',
          ['ce'] = 'EX ',
          ['r'] = 'PROMPT ',
          ['rm'] = 'MORE ',
          ['r?'] = 'CONFIRM ',
          ['!'] = 'SHELL ',
          ['t'] = 'TERMINAL ',
        },
        mode_colors = {
          n = colors.green,
          i = colors.magenta,
          v = colors.blue,
          V = colors.blue,
          [''] = colors.blue,
          c = colors.red,
          s = colors.purple,
          S = colors.purple,
          [''] = colors.purple,
          R = colors.orange,
          r = colors.orange,
          ['!'] = colors.red,
          t = colors.red,
        },
      },
      -- We can now access the value of mode() that, by now, would have been
      -- computed by `init()` and use it to index our strings dictionary.
      -- note how `static` fields become just regular attributes once the
      -- component is instantiated.
      -- To be extra meticulous, we can also add some vim statusline syntax to
      -- control the padding and make sure our string is always at least 2
      -- characters long. Plus a nice Icon.
      provider = function(self)
        if self.mode == nil then
          return ''
        end
        -- return ' %2(' .. self.mode .. '%)'
        return ' %2(' .. self.mode_names[self.mode] .. '%)'
      end,
      -- Same goes for the highlight. Now the foreground will change according to the current mode.
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { bg = self.mode_colors[mode], fg = colors.bg, bold = true }
      end,
    }

    local FileNameBlock = {
      -- let's first set up some attributes needed by this component and it's children
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }

    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. ' ')
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ':.')
        if filename == '' then
          return '[No Name]'
        end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
      end,
      hl = { fg = utils.get_highlight('Directory').fg },
    }

    local FileFlags = {
      {
        provider = function()
          if vim.bo.modified then
            return ' [+]'
          end
        end,
        hl = { fg = colors.green },
      },
      {
        provider = function()
          if (not vim.bo.modifiable) or vim.bo.readonly then
            return ''
          end
        end,
        hl = { fg = colors.orange },
      },
    }

    -- Change highlight when file has changes
    local FileNameModifer = {
      hl = function()
        if vim.bo.modified then
          -- use `force` because we need to override the child's hl foreground
          return { fg = colors.cyan, bold = true, force = true }
        end
      end,
    }

    local diag_signs = vim.diagnostic.config().signs.text or {}
    local Diagnostics = {
      condition = conditions.has_diagnostics,
      static = {
        error_icon = diag_signs[1],
        warn_icon = diag_signs[2],
        info_icon = diag_signs[3],
        hint_icon = diag_signs[4],
      },
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      {
        provider = function(self)
          -- 0 is just another output, we can decide to print it or not!
          return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
        end,
        hl = { fg = colors.error },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
        end,
        hl = { fg = colors.warning },
      },
      {
        provider = function(self)
          return self.info > 0 and (self.info_icon .. self.info .. ' ')
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

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifer, FileName), unpack(FileFlags), { provider = '%<' })

    local Git = {
      condition = conditions.is_git_repo,
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,
      hl = { fg = colors.orange, bg = colors.bg },
      {
        provider = function(self)
          return ' ' .. self.status_dict.head
        end,
        hl = { bold = true },
      },
      {
        condition = function(self)
          return self.has_changes
        end,
        provider = ' ',
      },
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and ('  ' .. count)
        end,
        hl = { fg = colors.git.add },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and ('  ' .. count)
        end,
        hl = { fg = colors.git.delete },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and ('  ' .. count)
        end,
        hl = { fg = colors.git.change },
      },
    }

    local FileType = {
      provider = function()
        return vim.bo.filetype
      end,
      hl = { fg = utils.get_highlight('Statusline').fg, bold = true },
    }

    local FileEncoding = {
      provider = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        return enc:upper()
      end,
    }

    local FileInfoBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }

    FileInfoBlock = utils.insert(
      FileInfoBlock,
      FileEncoding,
      Space,
      FileIcon,
      FileType,
      { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
    )

    local FileNameShort = {
      provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ':t')
        if filename == '' then
          return '[No Name]'
        end
        return filename
      end,
      hl = { fg = colors.fg_dark },
    }

    local FileNameShortBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }

    FileNameShortBlock = utils.insert(
      FileNameShortBlock,
      FileIcon,
      FileNameShort,
      { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
    )

    local TerminalName = {
      -- we could add a condition to check that buftype == 'terminal'
      -- or we could do that later (see #conditional-statuslines below)
      provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
        return ' ' .. tname
      end,
      hl = { bold = true },
    }

    local Ruler = {
      -- %l = current line number
      -- %L = number of lines in the buffer
      -- %c = column number
      -- %P = percentage through file of displayed window
      provider = '%7 %p%% %l,%c',
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
      Git,
    }

    local SpecialStatusline = {
      condition = function()
        return conditions.buffer_matches({
          buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
          filetype = { '^git.*', 'fugitive' },
        })
      end,
      FileType,
      Space,
      Align,
    }

    local TerminalStatusline = {
      condition = function()
        return conditions.buffer_matches({ buftype = { 'terminal' } })
      end,
      TerminalName,
      Align,
    }

    local StatusLines = {
      fallthrough = false,
      SpecialStatusline,
      TerminalStatusline,
      DefaultStatusline,
    }

    local WinBars = {
      fallthrough = false,
      {
        -- An inactive winbar for regular files
        condition = function()
          return conditions.buffer_matches({ buftype = { 'terminal' } }) and not conditions.is_active()
        end,
        {
          hl = { bg = colors.bg_dark, fg = 'gray', force = true },
          SmallSpace,
          TerminalName,
          Align,
        },
      },
      {
        -- A special winbar for terminals
        condition = function()
          return conditions.buffer_matches({ buftype = { 'terminal' } })
        end,
        {
          hl = { bg = colors.bg_dark1, force = true },
          SmallSpace,
          TerminalName,
          Align,
        },
      },
      {
        -- An inactive winbar for regular files
        condition = function()
          return not conditions.is_active()
        end,
        {
          hl = { bg = colors.bg_dark, fg = 'gray', force = true },
          SmallSpace,
          FileNameShortBlock,
          Align,
        },
      },
      -- A winbar for regular files
      {
        hl = { bg = colors.bg_dark1, force = true },
        SmallSpace,
        FileNameShortBlock,
        Align,
      },
    }

    vim.api.nvim_create_autocmd('User', {
      pattern = 'HeirlineInitWinbar',
      callback = function(args)
        local buf = args.buf
        local buftype = vim.tbl_contains({ 'prompt', 'nofile', 'help', 'quickfix' }, vim.bo[buf].buftype)
        local filetype = vim.tbl_contains({ 'gitcommit', 'fugitive' }, vim.bo[buf].filetype)
        if buftype or filetype then
          vim.opt_local.winbar = nil
        end
      end,
    })

    local TablineOffset = {
      condition = function(self)
        local win = vim.api.nvim_tabpage_list_wins(0)[1]
        local bufnr = vim.api.nvim_win_get_buf(win)
        self.winid = win

        if vim.bo[bufnr].filetype == 'neo-tree' then
          self.title = ' NeoTree'
          return true
        end
      end,
      provider = function(self)
        local title = self.title
        local width = vim.api.nvim_win_get_width(self.winid) + 2
        local padLeft = math.ceil((width - #title) / 2)
        local padRight = width - #title - padLeft
        return string.rep(' ', padLeft) .. title .. string.rep(' ', padRight) .. '▐'
      end,
      hl = function(self)
        if vim.api.nvim_get_current_win() == self.winid then
          return 'TablineSel'
        else
          return 'Tabline'
        end
      end,
    }

    local Tabpage = {
      provider = function(self)
        return '%' .. self.tabnr .. 'T ' .. self.tabnr .. ' %T'
      end,
      hl = function(self)
        if not self.is_active then
          return 'TabLine'
        else
          return 'TabLineSel'
        end
      end,
    }

    local TabpageClose = {
      provider = '%999X  %X',
      hl = 'TabLine',
    }

    local TabPages = {
      -- only show this component if there's 2 or more tabpages
      condition = function()
        return #vim.api.nvim_list_tabpages() >= 2
      end,
      { provider = '%=' },
      utils.make_tablist(Tabpage),
      TabpageClose,
    }

    local BufferLine = require('plugins.heirline-tabline')

    local Tabline = { TablineOffset, BufferLine, TabPages }

    require('heirline').setup({
      statusline = StatusLines,
      winbar = WinBars,
      tabline = Tabline,
      opts = {
        disable_winbar_cb = function(args)
          local buf = args.buf
          local buftype = vim.tbl_contains({ 'prompt', 'nofile', 'help', 'quickfix' }, vim.bo[buf].buftype)
          local filetype = vim.tbl_contains({ 'gitcommit', 'fugitive', 'Trouble', 'packer', 'markdown' }, vim.bo[buf].filetype)
          return buftype or filetype
        end,
      },
    })

    local function goto_buf(index)
      local bufs = vim.tbl_filter(function(bufnr)
        return vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted
      end, vim.api.nvim_list_bufs())
      if index > #bufs then
        index = #bufs
      end
      vim.api.nvim_win_set_buf(0, bufs[index])
    end

    local function addKey(key, index)
      vim.keymap.set('', '<A-' .. key .. '>', function()
        goto_buf(index)
      end, { noremap = true, silent = true })
    end

    for i = 1, 9 do
      addKey(i, i)
    end
    addKey('0', 10)
  end,
}
