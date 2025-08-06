return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'haydenmeade/neotest-jest',
    'arthur944/neotest-bun',
  },
  config = function()
    local neotest = require('neotest')

    neotest.setup({
      adapters = {
        require('neotest-jest')({
          jestCommand = './node_modules/.bin/jest',
          jestConfigFile = function()
            local root = vim.fn.getcwd()

            local config_files = {
              'jest.config.js',
              'jest.config.ts',
              'jest.config.mjs',
              'jest.config.cjs',
            }

            for _, config_file in ipairs(config_files) do
              local config_path = root .. '/' .. config_file
              if vim.fn.filereadable(config_path) == 1 then
                return config_path
              end
            end

            return nil
          end,
        }),
        require('neotest-bun'),
      },
    })

    vim.keymap.set('n', '<leader>tt', function()
      neotest.run.run()
    end, { desc = 'Run nearest test' })

    vim.keymap.set('n', '<leader>tf', function()
      neotest.run.run(vim.fn.expand('%'))
    end, { desc = 'Run current file tests' })

    vim.keymap.set('n', '<leader>td', function()
      neotest.output.open({ enter = true, auto_close = true })
    end, { desc = 'Display test output' })
  end,
}

