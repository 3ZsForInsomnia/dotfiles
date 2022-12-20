-- vim.cmd [[packadd packer.nvim]]

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
local packer = require('packer')

packer.init {
  max_jobs = 50
}

return packer.startup(function(use)
  use 'lewis6991/impatient.nvim'
  use 'tpope/vim-sensible'

  use 'MunifTanjim/nui.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'kamykn/popup-menu.nvim'

  use 'wbthomason/packer.nvim'
  use { "williamboman/mason.nvim" }
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  use { 'mfussenegger/nvim-jdtls', ft = { "java" } }

  use "folke/neodev.nvim"
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'RRethy/nvim-treesitter-textsubjects'
  use {
    'm-demare/hlargs.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('hlargs').setup({
        paint_catch_blocks = {
          declarations = true,
          usages = true,
        },
      })
    end
  }
  use {
    "danymat/neogen",
    config = function()
      require('neogen').setup {}
    end,
    requires = "nvim-treesitter/nvim-treesitter",
    tag = "*"
  }

  use 'windwp/nvim-ts-autotag'
  use {
    'andymass/vim-matchup',
    setup = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
  }
  use { 'bennypowers/nvim-regexplainer',
    config = function() require 'regexplainer'.setup() end,
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'MunifTanjim/nui.nvim',
    }
  }

  use {
    "mfussenegger/nvim-dap",
    module = { "dap" },
    requires = {
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope-dap.nvim",
      "theHamsta/nvim-dap-virtual-text",
      { "mxsdev/nvim-dap-vscode-js" },
      {
        "microsoft/vscode-js-debug",
        run = "npm install --legacy-peer-deps && npm run compile",
      },
    },
    disable = false,
  }
  use {
    'dhruvmanila/telescope-bookmarks.nvim',
    tag = '*',
  }
  use {
    'debugloop/telescope-undo.nvim',
    requires = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require("telescope").load_extension("undo")
    end,
  }

  use 'onsails/lspkind-nvim'
  use({ 'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'ray-x/cmp-treesitter',
      'hrsh7th/cmp-cmdline',
      'quangnguyen30192/cmp-nvim-tags',
      'quangnguyen30192/cmp-nvim-ultisnips',
      'petertriho/cmp-git',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'rcarriga/cmp-dap',
      'dcampos/cmp-emmet-vim',
      'delphinus/cmp-ctags',
      'hrsh7th/cmp-nvim-lua',
    },
    config = function()
      require("cmp_nvim_ultisnips").setup {}
    end,
  })
  use { 'SirVer/ultisnips',
    requires = {
      { "honza/vim-snippets", rtp = "." },
      "mlaursen/vim-react-snippets"
    },
    config = function()
      vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
      vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
      vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
      vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
      vim.g.UltiSnipsRemoveSelectModeMappings = 0
    end
  }

  use 'jose-elias-alvarez/null-ls.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    config = function()
      require('telescope').setup({
        defaults = {
          layout_config = {
            width = 0.95,
            height = 0.95,
            preview_width = 0.5
          }
        }
      })
    end,
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use {
    "nvim-telescope/telescope-frecency.nvim",
    config = function()
      require "telescope".load_extension("frecency")
    end,
    requires = { "kkharji/sqlite.lua" }
  }
  use {
    "LukasPietzschmann/telescope-tabs",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require "telescope-tabs".setup()
    end
  }
  use {
    "fhill2/telescope-ultisnips.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require('telescope').load_extension("ultisnips")
    end
  }
  use {
    "barrett-ruth/telescope-http.nvim",
    config = function()
      require('telescope').load_extension "http"
    end
  }
  use {
    "danielvolchek/tailiscope.nvim",
    config = function()
      require('telescope').load_extension("tailiscope")
    end
  }
  use "LinArcX/telescope-changes.nvim"
  use("HUAHUAI23/telescope-session.nvim")
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }
  use {
    "otavioschwanck/telescope-alternate",
    config = function()
      require('telescope').load_extension('telescope-alternate')
    end
  }

  use "folke/which-key.nvim"

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        height = 20,
        action_keys = {
          open_tab = { "<c-t>" },
        },
      }
    end
  }

  use {
    "ms-jpq/chadtree",
    branch = "chad",
    run = "python3 -m chadtree deps"
  }

  use 'ThePrimeagen/refactoring.nvim'
  use({
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  })

  -- Theming and highlighting
  use 'kyazdani42/nvim-web-devicons'
  -- use 'tanvirtin/monokai.nvim'
  -- use 'marko-cerovac/material.nvim'
  -- use 'nxvu699134/vn-night.nvim'
  -- use 'bluz71/vim-nightfly-guicolors'
  -- use 'rafi/awesome-vim-colorschemes'
  -- use 'rebelot/kanagawa.nvim'
  use 'bluz71/vim-moonfly-colors'
  use {
    'brenoprata10/nvim-highlight-colors',
    config = function()
      require("nvim-highlight-colors").setup {
        render = 'background',
        enable_named_colors = true,
        enable_tailwind = true
      }
    end,
  }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use 'kylechui/nvim-surround'
  use 'p00f/nvim-ts-rainbow'
  use 'glepnir/indent-guides.nvim'

  -- Misc filetype specific things
  use {
    'vuki656/package-info.nvim',
    config = function()
      require('package-info').setup()
    end,
    ft = { 'json' },
  }
  use { "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown", 'md' },
  }
  use {
    'mattn/emmet-vim',
    ft = { 'html', 'hbs', 'jsx', 'tsx' }
  }

  -- Database viewer
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'

  -- Git and status line
  use {
    'sindrets/diffview.nvim',
    cmd = 'DiffviewOpen',
    config = function()
      require('config.diffview')
    end
  }
  use {
    'ruanyl/vim-gh-line',
    keys = '<leader>gh'
  }
  use 'APZelos/blamer.nvim'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  -- Other addons
  use {
    'MunifTanjim/prettier.nvim',
    config = function()
      require('prettier').setup({
        bin = 'prettierd',
      })
    end,
  }
  use 'chentoast/marks.nvim'
  use 'tpope/vim-commentary'
  use 'folke/todo-comments.nvim'
  use {
    'CRAG666/code_runner.nvim',
    cmd = { 'RunCode', 'RunFile' },
  }
  use 'vimwiki/vimwiki'
  -- use 'tpope/vim-dispatch'
  -- use 'narutoxy/silicon.lua'
  use {
    'yoshio15/vim-trello',
    branch = 'main',
    cmd = 'VimTrello'
  }
  -- use 'jbyuki/instant.nvim'
  use {
    'liuchengxu/vista.vim',
    cmd = 'Vista'
  }

  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require "octo".setup()
    end,
    cmd = 'Octo'
  }

  -- " Remote plugin, legacy from vim-compatible plugins
  use 'roxma/nvim-yarp'

  use({
    'mrjones2014/dash.nvim',
    run = 'make install',
  })

  if packer_bootstrap then
    require('packer').sync()
  end
end)
