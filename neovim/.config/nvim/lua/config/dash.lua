local M = {}

function M.setup()
  require("telescope").load_extension("dash")

  local dashConfig = {
    search_engine = 'google', -- fallback when no results in dash
    debounce = 500,
    file_type_keywords = {
      dashboard = false,
      NvimTree = false,
      TelescopePrompt = false,
      terminal = false,
      packer = false,
      fzf = false,
      zsh = {
        'zsh',
        'ohmyzsh',
        'git',
        'jq',
        'aws-cli',
        'bashshortcuts',
        'regex',
        'virtualenv',
      },
      sh = {
        'zsh',
        'ohmyzsh',
        'jq',
      },
      javascript = {
        'javascript',
        'nodejs',
        'ramda',
        'lodash',
        'ember',
        'awsjs',
        'redux',
        'express',
        'mongodb',
        'mongoose',
        'echarts',
        'date-fns',
        'jsdoc',
        'axios',
        'regex',
        'jest',
        'caniuse',
      },
      typescript = {
        'typescript',
        'javascript',
        'nodejs',
        'ramda',
        'angular',
        'react',
        'rxjs',
        'express',
        'mongodb',
        'mongoose',
        'date-fns',
        'jsdoc',
        'axios',
        'regex',
        'tsdoc',
        'jest',
        'caniuse',
      },
      typescriptreact = {
        'typescript',
        'javascript',
        'react',
        'ramda',
        'rxjs',
        'emmet',
        'tailwindcss',
        'regex',
        'tsdoc',
        'jest',
        'caniuse',
      },
      javascriptreact = {
        'javascript',
        'react',
        'ramda',
        'emmet',
        'tailwindcss',
        'regex',
        'jest',
        'caniuse',
      },
      hbs = {
        'html',
        'handlebars',
        'tailwindcss',
        'emmet',
        'caniuse',
      },
      html = {
        'html',
        'tailwindcss',
        'emmet',
        'caniuse',
      },
      css = {
        'css',
        'sass',
        'tailwindcss',
        'media',
        'color',
        'caniuse',
      },
      scss = {
        'css',
        'sass',
        'tailwindcss',
        'media',
        'color',
        'caniuse',
      },
      lua = {
        'lua',
        'neovim',
        'vim',
        'regex',
      },
      python = {
        'python3',
        'django',
        'django-cms',
        'regex',
      },
      java = {
        'java11',
        'java19',
        'spring',
        'junit4',
        'regex',
      },
      sql = {
        'mysql',
      },
      markdown = {
        'markdown',
      }
    },
  }

  require('dash').setup(dashConfig)
end

return M
