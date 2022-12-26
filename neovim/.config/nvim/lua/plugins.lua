-- let Packer ensure it is installed on load
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

-- Prevents Packer hanging and failing to update when there are too many plugins
packer.init {
  max_jobs = 50,
  git = {
    clone_timeout = 300
  }
}

return packer.startup(function(use)
  --
  --
  -- General settings
  -- Packer itself, UI component and function libraries used by other plugins
  --
  --
  use 'lewis6991/impatient.nvim'
  use 'MunifTanjim/nui.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'kamykn/popup-menu.nvim'
  use 'wbthomason/packer.nvim'

  --
  --
  -- LSP support
  -- For all things LSP related that is not (explicitly) part of the Treesitter ecosystem
  --
  --
  use "williamboman/mason.nvim"
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/lsp-status.nvim'
  use 'onsails/lspkind-nvim'
  use { 'mfussenegger/nvim-jdtls', ft = { "java" } }
  use 'weilbith/nvim-code-action-menu'
  use 'ThePrimeagen/refactoring.nvim'
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
  use "folke/neodev.nvim"

  --
  --
  -- Treesitter
  -- Everything directly associated with Treesitter
  --
  --
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
  use { 'bennypowers/nvim-regexplainer',
    config = function() require 'regexplainer'.setup() end,
    requires = {
      'nvim-treesitter/nvim-treesitter',
      'MunifTanjim/nui.nvim',
    }
  }

  --
  --
  -- Telescope
  -- Find everything that has ever existed, ever
  --
  --
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
  use "benfowler/telescope-luasnip.nvim"
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
  use({
    'mrjones2014/dash.nvim',
    run = 'make install',
  })

  --
  --
  -- Cmp, Luasnip and Null-ls
  -- For all my text completion and code-styling needs
  --
  --
  use({ 'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'ray-x/cmp-treesitter',
      'hrsh7th/cmp-cmdline',
      'quangnguyen30192/cmp-nvim-tags',
      'petertriho/cmp-git',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'rcarriga/cmp-dap',
      'dcampos/cmp-emmet-vim',
      'delphinus/cmp-ctags',
      'hrsh7th/cmp-nvim-lua',
    },
  })
  use({
    "L3MON4D3/LuaSnip",
    tag = "v<CurrentMajor>.*",
  })
  use 'saadparwaiz1/cmp_luasnip'
  use "rafamadriz/friendly-snippets"
  -- Unclear if I actually need this - it seems to be build into Luasnip itself?
  use {
    'doxnit/cmp-luasnip-choice',
    config = function()
      require('cmp_luasnip_choice').setup({
        auto_open = true,
      });
    end,
  }
  use 'jose-elias-alvarez/null-ls.nvim'

  --
  --
  -- Comments
  -- Code sometimes needs comments, and these plugins make it easier
  --
  --
  use {
    'kkoomen/vim-doge',
    run = ':call doge#install()'
  }
  use 'tpope/vim-commentary'
  use 'folke/todo-comments.nvim'

  --
  --
  -- Inter and intra file motion
  -- Move around inside of files, between files, with marks, motions, and file exploration
  --
  --
  use 'rgroli/other.nvim'
  use "folke/which-key.nvim"
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }
  use 'chentoast/marks.nvim'
  use 'liuchengxu/vista.vim'

  --
  --
  -- Debugger (DAP)
  -- For when I need to figure out what dumb thing I did
  --
  --
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
  }

  --
  --
  -- Surrounds and tags
  -- Make it easier to work with markup and surrounding things in ({['"``"']})
  --
  --
  use 'kylechui/nvim-surround'
  use 'windwp/nvim-ts-autotag'
  use {
    'andymass/vim-matchup',
    setup = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
  }

  --
  --
  -- Theming and highlighting
  -- Making Neovim into a beautiful butterfly
  --
  --
  use 'kyazdani42/nvim-web-devicons'
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
    requires = { 'kyazdani42/nvim-web-devicons' }
  }
  use 'p00f/nvim-ts-rainbow'
  use 'glepnir/indent-guides.nvim'

  --
  --
  -- Misc filetype specific things
  -- Filetype specific-ish plugins for filetype specific-ish tasks
  --
  --
  use {
    'vuki656/package-info.nvim',
    config = function()
      require('package-info').setup()
    end,
  }
  use { "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
  }
  use 'mattn/emmet-vim'

  --
  --
  -- Databases
  -- Because DBeaver sucks
  --
  --
  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'

  --
  --
  -- Git
  -- Git statuses and diffs and PRs, oh my
  --
  --
  use 'sindrets/diffview.nvim'
  use 'ruanyl/vim-gh-line'
  use 'APZelos/blamer.nvim'
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
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
  }

  --
  --
  -- Other addons
  -- Some things cannot be categorized. They are banished to this dungeon at the bottom of my plugins.lua
  --
  --
  use {
    'MunifTanjim/prettier.nvim',
    config = function()
      require('prettier').setup({
        bin = 'prettierd',
      })
    end,
  }
  use {
    'CRAG666/code_runner.nvim',
    cmd = { 'RunCode', 'RunFile' },
  }
  use {
    'yoshio15/vim-trello',
    branch = 'main',
    cmd = 'VimTrello'
  }

  if packer_bootstrap then
    require('packer').sync()
  end
end)
