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
  use { 'mfussenegger/nvim-jdtls' }
  use 'weilbith/nvim-code-action-menu'
  use 'ThePrimeagen/refactoring.nvim'
  use "folke/trouble.nvim"
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
  use 'm-demare/hlargs.nvim'
  use 'bennypowers/nvim-regexplainer'

  --
  --
  -- Telescope
  -- Find everything that has ever existed, ever
  --
  --
  use {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
  }
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
  use 'hrsh7th/nvim-cmp'
  use({
    "L3MON4D3/LuaSnip",
    tag = "v<CurrentMajor>.*",
  })
  use 'saadparwaiz1/cmp_luasnip'
  use "rafamadriz/friendly-snippets"
  -- Unclear if I actually need this - it seems to be build into Luasnip itself?
  use 'doxnit/cmp-luasnip-choice'
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
  use 'numToStr/Comment.nvim'
  use "pavanbhat1999/figlet.nvim"
  use 'folke/todo-comments.nvim'

  --
  --
  -- Inter and intra file motion
  -- Move around inside of files, between files, with marks, motions, and file exploration
  --
  --
  use 'rgroli/other.nvim'
  use "folke/which-key.nvim"
  use 'nvim-tree/nvim-tree.lua'
  use 'chentoast/marks.nvim'
  use 'liuchengxu/vista.vim'

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
  use 'brenoprata10/nvim-highlight-colors'
  use 'nvim-lualine/lualine.nvim'
  use 'p00f/nvim-ts-rainbow'
  use 'glepnir/indent-guides.nvim'
  use "folke/twilight.nvim"
  use 'andymass/vim-matchup'

  --
  --
  -- Misc filetype specific things
  -- Filetype specific-ish plugins for filetype specific-ish tasks
  --
  --
  use 'kylechui/nvim-surround'
  use 'mattn/emmet-vim'
  use 'vuki656/package-info.nvim'
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
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
  use 'APZelos/blamer.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'pwntester/octo.nvim'

  --
  --
  -- Other addons
  -- Some things cannot be categorized. They are banished to this dungeon at the bottom of my plugins.lua
  --
  --
  use 'MunifTanjim/prettier.nvim'
  use 'CRAG666/code_runner.nvim'
  use 'yoshio15/vim-trello'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
