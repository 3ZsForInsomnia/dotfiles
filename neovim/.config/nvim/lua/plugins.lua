-- let Packer ensure it is installed on load
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/wbthomason/packer.nvim",
			install_path,
		})
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()
local packer = require("packer")

-- Prevents Packer hanging and failing to update when there are too many plugins
packer.init({ max_jobs = 50, git = { clone_timeout = 300 } })

local lspServers = {
	"angularls",
	"bashls",
	"cssls",
	"ember",
	"emmet_ls",
	"eslint",
	"grammarly",
	"graphql",
	"html",
	"jdtls",
	"jsonls",
	"lua_ls",
	"marksman",
	"sqlls",
	"tailwindcss",
	"tsserver",
	"vimls",
	"pyright",
	"pylsp",
}

return packer.startup(function(use)
	--
	--
	-- General settings
	-- Packer itself, UI component and function libraries used by other plugins
	--
	--
	use("MunifTanjim/nui.nvim")
	use("nvim-lua/plenary.nvim")
	use("kamykn/popup-menu.nvim")
	use("wbthomason/packer.nvim")
	use("kkharji/sqlite.lua")
	use("rcarriga/nvim-notify")
	use("zdcthomas/yop.nvim")
	use("winston0410/cmd-parser.nvim")
	use({ "dstein64/vim-startuptime", cmd = "StartupTime" })
	use({
		"stevearc/dressing.nvim",
		config = function()
			require("config.ui").setup()
		end,
	})
	use("onsails/lspkind-nvim")

	--
	--
	-- LSP support
	-- For all things LSP related that is not (explicitly) part of the Treesitter ecosystem
	--
	--
	use({
		"neovim/nvim-lspconfig",
		requires = {
			{
				"williamboman/mason.nvim",
				config = function()
					require("mason").setup()
				end,
			},
			{
				"williamboman/mason-lspconfig.nvim",
				config = function()
					require("mason-lspconfig").setup({
						ensure_installed = lspServers,
					})
				end,
			},
			"mfussenegger/nvim-jdtls",
			{
				"jose-elias-alvarez/typescript.nvim",
				config = function()
					require("typescript").setup({})
				end,
			},
			{
				"weilbith/nvim-code-action-menu",
				cmd = "CodeActionMenu",
				after = "nvim-lspconfig",
			},
		},
	})
	use({
		"ThePrimeagen/refactoring.nvim",
		after = "nvim-treesitter",
		module = "refactoring",
		config = function()
			require("refactoring").setup({})
		end,
	})
	use({
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
		config = function()
			require("trouble").setup({
				height = 20,
				action_keys = { open_tab = { "<c-t>" } },
			})
			-- require("keys.trouble-lazy")
		end,
	})
	use({
		"folke/neodev.nvim",
		ft = "lua",
		after = "nvim-lspconfig",
		config = function()
			require("neodev").setup({
				library = {
					enabled = true,
					runtime = true,
					types = true,
					plugins = true,
				},
				setup_jsonls = true,
				override = function(root_dir, options) end,
				lspconfig = true,
			})
		end,
	})

	--
	--
	-- Treesitter
	-- Everything directly associated with Treesitter
	--
	--
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("config.treesitter").setup()
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("config.treesitter-context").setup()
		end,
	})
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("RRethy/nvim-treesitter-textsubjects")
	use({
		"m-demare/hlargs.nvim",
		event = "VimEnter",
		config = function()
			require("config.hlargs").setup()
		end,
	})
	use("HiPhish/nvim-ts-rainbow2")
  use("windwp/nvim-ts-autotag")
  use("theHamsta/nvim-treesitter-pairs")
	use({
		"bennypowers/nvim-regexplainer",
		config = function()
			require("regexplainer").setup()
		end,
	})

	--
	--
	-- Linting & Formatting
	--
	--
	--
	use({
		"mhartington/formatter.nvim",
		event = "BufReadPost",
		config = function()
			require("config.formatting").setup()
		end,
	})
	use({
		"mfussenegger/nvim-lint",
		event = "BufReadPost",
		config = function()
			require("config.linting").setup()
		end,
	})
  use({
    "lewis6991/hover.nvim",
    event = "BufReadPost",
    config = function()
      require("config.hover").setup()
    end
  })

	--
	--
	-- Telescope
	-- Find everything that has ever existed, ever
	--
	--
	use({
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		module = "telescope",
		keys = { "<leader>f" },
		tag = "0.1.2",
		config = function()
			require("config.telescope").setup()
		end,
		requires = {
			"nvim-telescope/telescope-live-grep-args.nvim",
			"nvim-telescope/telescope-frecency.nvim",
			"benfowler/telescope-luasnip.nvim",
			"barrett-ruth/telescope-http.nvim",
			"danielvolchek/tailiscope.nvim",
			"LinArcX/telescope-changes.nvim",
			"HUAHUAI23/telescope-session.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			"3ZsForInsomnia/telescope-angular",
			-- { "dhruvmanila/telescope-bookmarks.nvim", opt = true },
			"debugloop/telescope-undo.nvim",
			"LinArcX/telescope-scriptnames.nvim",
			"crispgm/telescope-heading.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-packer.nvim",
		},
	})

	use({
		"axkirillov/easypick.nvim",
		cmd = "Easypick",
		config = function()
			require("config.easypick").setup()
		end,
	})
	use({
		"mrjones2014/dash.nvim",
		cmd = { "Dash", "DashWord" },
		run = "make install",
		config = function()
			require("config.dash").setup()
		end,
	})

	--
	--
	-- Cmp, Luasnip and Null-ls
	-- For all my text completion and code-styling needs
	--
	--
	use({
		"L3MON4D3/LuaSnip",
		tag = "v<CurrentMajor>.*",
		event = "BufReadPost",
		config = function()
			require("config.luasnip").setup()
		end,
		requires = {
			{ "rafamadriz/friendly-snippets", after = "LuaSnip" },
			{ "johnpapa/vscode-angular-snippets", after = "LuaSnip" },
			{
				"hrsh7th/nvim-cmp",
				after = { "LuaSnip", "nvim-navic" },
				config = function()
					require("config.cmp-and-lsp").setup()
				end,
			},
			{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			{ "delphinus/cmp-ctags", after = "nvim-cmp" },
			{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
			{ "hrsh7th/cmp-path", after = "nvim-cmp" },
			{ "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp" }, -- after = "LuaSnip" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
			{ "hrsh7th/cmp-nvim-lsp-document-symbol", after = "nvim-cmp" },
			{ "kristijanhusak/vim-dadbod-completion", after = "nvim-cmp" },
			{ "ray-x/cmp-treesitter", after = "nvim-cmp" },
			{ "quangnguyen30192/cmp-nvim-tags", after = "nvim-cmp" },
			{ "dcampos/cmp-emmet-vim", after = "nvim-cmp" },
			{
				"petertriho/cmp-git",
				after = "nvim-cmp",
				config = function()
					require("cmp_git").setup({})
				end,
			},
		},
	})

	-- use({
	-- 	"jose-elias-alvarez/null-ls.nvim",
	-- 	opt = true,
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		require("config.null-ls").setup()
	-- 	end,
	-- })
	use({
		"ckolkey/ts-node-action",
		event = "InsertEnter",
		opt = true,
		requires = { "nvim-treesitter" },
		config = function()
			require("ts-node-action").setup({})
		end,
	})

	--
	--
	-- Comments
	-- Code sometimes needs comments, and these plugins make it easier
	--
	--
	use({
		"danymat/neogen",
		cmd = "Neogen",
		module = "neogen",
		config = function()
			require("neogen").setup({
				enabled = true,
				snippet_engine = "luasnip",
				input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
			})
		end,
	})
	use({
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"folke/todo-comments.nvim",
		event = "BufReadPost",
		config = function()
			require("todo-comments").setup()
		end,
	})

	--
	--
	-- Inter and intra file motion
	-- Move around inside of files, between files, with marks, motions, and file exploration
	--
	--
	use({
		"rgroli/other.nvim",
		cmd = "Other",
		config = function()
			require("config.alternate").setup()
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			require("config.whichkey").setup()
		end,
	})
	use({
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("config.file-explorer").setup()
		end,
	})
	use({
		"chentoast/marks.nvim",
		event = "BufReadPost",
		config = function()
			require("config.marks").setup()
		end,
	})
	use({ "liuchengxu/vista.vim", cmd = "Vista" })
	use({ "mbbill/undotree", event = "BufReadPost" })

	--
	--
	-- Testing (Neotest)
	-- Because tests are useful, I *guess*
	--
	--
	use({
		"nvim-neotest/neotest",
		requires = { "haydenmeade/neotest-jest" },
		module = "neotest",
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-jest")({
						jestCommand = "npm test --",
						jestConfigFile = "custom.jest.config.ts",
						env = { CI = true },
						cwd = function(path)
							return vim.fn.getcwd()
						end,
					}),
				},
			})
		end,
	})

	--
	--
	-- Debugger (DAP)
	-- For when I need to figure out what dumb thing I did
	--
	--
	use({
		"mfussenegger/nvim-dap",
		module = "dap",
		opt = true,
		requires = {
			{ "theHamsta/nvim-dap-virtual-text", opt = true },
			{ "rcarriga/nvim-dap-ui", opt = true },
			{ "mfussenegger/nvim-dap-python", opt = true },
			{ "nvim-telescope/telescope-dap.nvim", opt = true },
			{ "mxsdev/nvim-dap-vscode-js", opt = true },
			-- { "rcarriga/cmp-dap",                  after = "nvim-cmp" },
			{
				"microsoft/vscode-js-debug",
				opt = true,
				run = "npm install --legacy-peer-deps && npm run compile",
			},
		},
	})

	--
	--
	-- Theming and highlighting
	-- Making Neovim into a beautiful butterfly
	--
	--
	use("kyazdani42/nvim-web-devicons")
	use("bluz71/vim-moonfly-colors")
	use({
		"karb94/neoscroll.nvim",
    event = "BufReadPost",
		config = function()
			require("config.scroll-config").setup()
		end,
	})
	use({
		"brenoprata10/nvim-highlight-colors",
		ft = { "css", "scss", "jsx", "tsx", "lua", "sh", "bash", "zsh" },
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background",
				enable_named_colors = true,
				enable_tailwind = true,
			})
		end,
	})
  use({'matbme/JABS.nvim', config = function() require("config.jabs").setup() end })
	use({
		"nvim-lualine/lualine.nvim",
		event = "BufReadPost",
		after = "nvim-navic",
		config = function()
			require("config.statusline").setup()
		end,
	})
	use({ "SmiteshP/nvim-navic", requires = "neovim/nvim-lspconfig" })
	use({
		"folke/twilight.nvim",
		cmd = "Twilight",
		module = "twilight",
		config = function()
			require("twilight").setup()
		end,
	})
	use({ "andymass/vim-matchup", event = "BufReadPost" })

	--
	--
	-- Misc filetype specific things
	-- Filetype specific-ish plugins for filetype specific-ish tasks
	--
	--
	use({ "kylechui/nvim-surround", event = "BufReadPost" })
	use({ "mattn/emmet-vim", ft = { "html", "jsx", "tsx", "hbs" } })
	use({
		"vuki656/package-info.nvim",
		ft = "json",
		config = function()
			require("package-info").setup()
		end,
	})
	use({
		"iamcco/markdown-preview.nvim",
		ft = "markdown",
		run = "cd app && npm install",
		config = function()
			require("config.markdown-preview-config").setup()
		end,
	})

	--
	--
	-- Databases
	-- Because DBeaver sucks
	--
	--
	use({ "tpope/vim-dadbod", cmd = { "DB" } })
	use({ "kristijanhusak/vim-dadbod-ui", cmd = { "DBUI", "DBUIToggle" } })

	--
	--
	-- Git
	-- Git statuses and diffs and PRs, oh my
	--
	--
	use({ "sindrets/diffview.nvim" })
	use({ "ruanyl/vim-gh-line", cmd = { "GH", "GHInteractive" } })
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("config.gitsigns").setup()
      require("keys.git").setup()
		end,
	})
  use ({
    "NeogitOrg/neogit",
    event = "BufReadPost",
    cmd = "Neogit",
    module = "neogit",
    config = function()
      require("config.neogit").setup()
    end,
  })
	use({
		"pwntester/octo.nvim",
		cmd = "Octo",
		config = function()
			require("octo").setup()
		end,
	})

	--
	--
	-- Other addons
	-- Some things cannot be categorized. They are banished to this dungeon at the bottom of my plugins.lua
	--
	--
	use({
		"MunifTanjim/prettier.nvim",
		cmd = { "Prettier", "PrettierFragment", "PrettierPartial" },
		config = function()
			require("prettier").setup({ bin = "prettierd" })
		end,
	})
	use({ "CRAG666/code_runner.nvim", cmd = { "RunCode", "RunFile" } })
	use({
		"yoshio15/vim-trello",
		cmd = "VimTrello",
		config = function()
			require("config.trello").setup()
		end,
	})
	use({
		"winston0410/range-highlight.nvim",
		event = "BufReadPost",
		config = function()
			require("range-highlight").setup({})
		end,
	})
	use({
		"max397574/colortils.nvim",
		cmd = "Colortils",
		config = function()
			require("colortils").setup()
		end,
	})
	use({
		"epwalsh/obsidian.nvim",
		cmd = {
			"Obsidian",
			"ObsidianNew",
			"ObsidianOpen",
			"ObsidianToday",
			"ObsidianTemplate",
			"ObsidianQuickSwitch",
			"ObsidianSearch",
		},
		config = function()
			require("config.obsidian").setup()
		end,
	})
	use({ "godlygeek/tabular", cmd = "Tabularize" })
	use({
		"Equilibris/nx.nvim",
		module = "nx",
		requires = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("nx").setup({
				nx_cmd_root = "nx",
				command_runner = require("nx.command-runners").terminal_cmd(),
				form_renderer = require("nx.form-renderers").telescope(),
				read_init = true,
			})
		end,
	})

	use({ "aklt/plantuml-syntax", ft = "uml", opt = true })
	use({ "weirongxu/plantuml-previewer.vim", ft = "uml", opt = true })

	use({
		"m4xshen/hardtime.nvim",
		config = function()
			require("hardtime").setup()
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)
