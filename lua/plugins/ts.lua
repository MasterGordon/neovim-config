return {
  'romus204/tree-sitter-manager.nvim',
  dependencies = {}, -- tree-sitter CLI must be installed system-wide
  config = function()
    require('tree-sitter-manager').setup({
      ensure_installed = {
        'bash',
        'c_sharp',
        'caddy',
        'css',
        'csv',
        'desktop',
        'diff',
        'dockerfile',
        'editorconfig',
        'gdscript',
        'gdshader',
        'git_config',
        'gitattributes',
        'gitcommit',
        'gitignore',
        'html',
        'ini',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'php',
        'printf',
        'prisma',
        'properties',
        'python',
        'scss',
        'sql',
        'ssh_config',
        'toml',
        'tsx',
        'typescript',
        'xml',
        'yaml',
        'zig',
        'fsharp',
      },
      -- Default Options
      -- ensure_installed = {}, -- list of parsers to install at the start of a neovim session
      -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
      -- auto_install = false, -- if enabled, install missing parsers when editing a new file
      -- highlight = true, -- treesitter highlighting is enabled by default
      -- languages = {}, -- override or add new parser sources
      -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
      -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
    })

    -- tree-sitter-manager uses parser names as FileType patterns, but some Vim
    -- filetypes differ from the treesitter parser name and need manual wiring.
    local mismatches = {
      { lang = 'c_sharp', ft = 'cs' },
      { lang = 'fsharp',  ft = 'fsharp' },
    }
    for _, m in ipairs(mismatches) do
      vim.treesitter.language.register(m.lang, m.ft)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = m.ft,
        callback = function() vim.treesitter.start() end,
      })
    end
  end,
}
