return {
  'kyazdani42/nvim-web-devicons',
  config = function()
    require('nvim-web-devicons').set_icon({
      ['test.ts'] = {
        icon = '',
        color = '#519aba',
        name = 'TsTest',
      },
      ['test.tsx'] = {
        icon = '',
        color = '#519aba',
        name = 'TsTest',
      },
      ['test.js'] = {
        icon = '',
        color = '#cbcb41',
        name = 'JsTest',
      },
      ['test.jsx'] = {
        icon = '',
        color = '#cbcb41',
        name = 'JsTest',
      },
      ['readme.md'] = {
        icon = '',
        color = '#42A5F5',
        name = 'Readme',
      },
      ['package.json'] = {
        icon = '󰎙',
        color = '#8BC34A',
        name = 'PackageJson',
      },
      ['package-lock.json'] = {
        icon = '󰎙',
        color = '#8BC34A',
        name = 'PackageJson',
      },
      ['tsconfig.json'] = {
        icon = '',
        color = '#0288D1',
        name = 'TsConfig',
      },
      ['prisma'] = {
        icon = '',
        color = '#FFFFFF',
        name = 'Prisma',
      },
      ['jar'] = {
        icon = '',
        color = '#FFFFFF',
        name = 'Jar',
      },
    })
  end,
}
