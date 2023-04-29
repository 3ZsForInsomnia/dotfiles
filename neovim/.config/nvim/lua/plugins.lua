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
  use "kkharji/sqlite.lua"
  use 'rcarriga/nvim-notify'
  use "zdcthomas/yop.nvim"
  use {
    'stevearc/dressing.nvim',
    config = function()
      require('config.ui').setup()
    end
  }

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
  use 'mfussenegger/nvim-jdtls'
  use 'weilbith/nvim-code-action-menu'
  use {
    'ThePrimeagen/refactoring.nvim',
    config = function()
      require('refactoring').setup({})
    end
  }
  use {
    "folke/trouble.nvim",
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
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup({
        library = {
          enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
          -- these settings will be used for your Neovim config directory
          runtime = true, -- runtime path
          types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
          plugins = true, -- installed opt or start plugins in packpath
          -- you can also specify the list of plugins to make available as a workspace library
          -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
        },
        setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
        -- for your Neovim config directory, the config.library settings will be used as is
        -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
        -- for any other directory, config.library.enabled will be set to false
        override = function(root_dir, options) end,
        -- With lspconfig, Neodev will automatically setup your lua-language-server
        -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
        -- in your lsp start options
        lspconfig = true,
      })
    end
  }

  --
  --
  -- Treesitter
  -- Everything directly associated with Treesitter
  --
  --
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('config.treesitter').setup()
    end,
  }
  use {
    'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require('config.treesitter-context').setup()
    end,
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'RRethy/nvim-treesitter-textsubjects'
  use 'nvim-treesitter/playground'
  use {
    'm-demare/hlargs.nvim',
    config = function()
      require('config.hlargs').setup()
    end
  }
  use {
    'bennypowers/nvim-regexplainer',
    config = function()
      require('regexplainer').setup()
    end
  }

  --
  --
  -- Telescope
  -- Find everything that has ever existed, ever
  --
  --
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    config = function()
      require('config.telescope').setup()
    end
  }
  use "nvim-telescope/telescope-live-grep-args.nvim"
  use "nvim-telescope/telescope-frecency.nvim"
  use "LukasPietzschmann/telescope-tabs"
  use "benfowler/telescope-luasnip.nvim"
  use "barrett-ruth/telescope-http.nvim"
  use "danielvolchek/tailiscope.nvim"
  use "LinArcX/telescope-changes.nvim"
  use("HUAHUAI23/telescope-session.nvim")
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }
  use 'dhruvmanila/telescope-bookmarks.nvim'
  use 'debugloop/telescope-undo.nvim'
  use "LinArcX/telescope-scriptnames.nvim"
  use 'crispgm/telescope-heading.nvim'
  use "nvim-telescope/telescope-file-browser.nvim"
  use "nvim-telescope/telescope-packer.nvim"
  --use({
  --  'mrjones2014/dash.nvim',
  --  run = 'make install',
  --  config = function()
  --    require('config.dash').setup()
  --  end
  --})

  --
  --
  -- Cmp, Luasnip and Null-ls
  -- For all my text completion and code-styling needs
  --
  --
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lua'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-nvim-lsp-document-symbol'
  use 'kristijanhusak/vim-dadbod-completion'
  use 'ray-x/cmp-treesitter'
  use 'quangnguyen30192/cmp-nvim-tags'
  use 'petertriho/cmp-git'
  use 'rcarriga/cmp-dap'
  use 'dcampos/cmp-emmet-vim'
  use 'delphinus/cmp-ctags'
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require('config.cmp-and-lsp').setup()
    end
  }
  use({
    "L3MON4D3/LuaSnip",
    tag = "v<CurrentMajor>.*",
    config = function()
      require('config.luasnip').setup()
    end
  })
  use 'saadparwaiz1/cmp_luasnip'
  use "rafamadriz/friendly-snippets"
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require('config.null-ls').setup()
    end
  }

  --
  --
  -- Comments
  -- Code sometimes needs comments, and these plugins make it easier
  --
  --
  use {
    "danymat/neogen",
    config = function()
      require('neogen').setup {
        enabled = true,
        snippet_engine = "luasnip",
        input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
      }
    end,
  }
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  use {
    "pavanbhat1999/figlet.nvim",
    config = function()
      require("figlet").Config({ font = "3d" })
    end
  }
  --use {
  --  'folke/todo-comments.nvim',
  --  config = function()
  --    require("todo-comments").setup()
  --  end
  --}

  --
  --
  -- Inter and intra file motion
  -- Move around inside of files, between files, with marks, motions, and file exploration
  --
  --
  use {
    'rgroli/other.nvim',
    config = function()
      require('config.alternate').setup()
    end
  }
  use {
    "folke/which-key.nvim",
    config = function()
      require('config.whichkey').setup()
    end
  }
  use {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('config.file-explorer').setup()
    end
  }
  use {
    'chentoast/marks.nvim',
    config = function()
      require('config.marks').setup()
    end
  }
  use 'liuchengxu/vista.vim'
  use 'mbbill/undotree'

  --
  --
  -- Debugger (DAP)
  -- For when I need to figure out what dumb thing I did
  --
  --
  use "theHamsta/nvim-dap-virtual-text"
  use "rcarriga/nvim-dap-ui"
  use "mfussenegger/nvim-dap-python"
  use "nvim-telescope/telescope-dap.nvim"
  use "mxsdev/nvim-dap-vscode-js"
  use {
    "microsoft/vscode-js-debug",
    run = "npm install --legacy-peer-deps && npm run compile",
  }
  use "mfussenegger/nvim-dap"

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
    end
  }
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('config.statusline').setup()
    end
  }
  use 'p00f/nvim-ts-rainbow'
  use {
    'glepnir/indent-guides.nvim',
    config = function()
      require('config.indent').setup()
    end
  }
  use {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup()
    end
  }
  use 'andymass/vim-matchup'

  --
  --
  -- Misc filetype specific things
  -- Filetype specific-ish plugins for filetype specific-ish tasks
  --
  --
  use 'kylechui/nvim-surround'
  use 'mattn/emmet-vim'
  use {
    'vuki656/package-info.nvim',
    config = function()
      require('package-info').setup()
    end
  }
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    config = function()
      require('config.markdown-preview-config').setup()
    end
  }

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
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('config.gitsigns').setup()
    end
  }
  use {
    'pwntester/octo.nvim',
    config = function()
      require "octo".setup()
    end
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
    end
  }
  use 'CRAG666/code_runner.nvim'
  --use {
  --  'yoshio15/vim-trello',
  --  config = function()
  --    require('config.trello').setup()
  --  end
  --}
  use 'winston0410/cmd-parser.nvim'
  use {
    'winston0410/range-highlight.nvim',
    config = function()
      require 'range-highlight'.setup {}
    end,
  }
  use {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    config = function()
      require("colortils").setup()
    end,
  }
  use 'dstein64/vim-startuptime'
  use "ThePrimeagen/vim-apm"

  use {
    "epwalsh/obsidian.nvim",
    config = function()
      require("config.obsidian").setup()
    end
  }
  use "godlygeek/tabular"

  if packer_bootstrap then
    require('packer').sync()
  end
end)
