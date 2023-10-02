local M = {}

function M.setup()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"javascript",
			"lua",
			"awk",
			"bash",
			"gitignore",
			"graphql",
			"java",
			"jq",
			"jsdoc",
			"json",
			"html",
			"markdown",
			"python",
			"scss",
			"css",
			"regex",
			"tsx",
			"typescript",
			"vim",
			"yaml",
			"http",
		},
		sync_install = true,
		auto_install = true,
		highlight = {
			enable = true, -- false will disable the whole extension
			additional_vim_regex_highlighting = { "markdown" },
			disable = {}, -- list of language that will be disabled
		},
		textsubjects = {
			enable = true,
			prev_selection = ",", -- (Optional) keymap to select the previous selection
			keymaps = {
				["."] = "textsubjects-smart",
				[";"] = "textsubjects-container-outer",
				["i;"] = "textsubjects-container-inner",
			},
		},
		textobjects = {
			select = {
				enable = true,
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["aa"] = "@call.outer",
					["ia"] = "@call.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["al"] = "@loop.outer",
					["il"] = "@loop.inner",
					["ai"] = "@conditional.outer",
					["ii"] = "@conditional.inner",
					["ao"] = "@block.outer",
					["io"] = "@block.inner",
					["am"] = "@comment.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["[F"] = "@function.outer",
					["[C"] = "@class.outer",
					["[A"] = "@call.outer",
					["[O"] = "@block.outer",
					["[I"] = "@conditional.outer",
					["[L"] = "@loop.outer",
				},
				goto_next_end = {
					["]f"] = "@function.outer",
					["]c"] = "@class.outer",
					["]a"] = "@call.outer",
					["]o"] = "@block.outer",
					["]i"] = "@conditional.outer",
					["]l"] = "@loop.outer",
				},
				goto_previous_start = {
					["[f"] = "@function.outer",
					["[c"] = "@class.outer",
					["[a"] = "@call.outer",
					["[o"] = "@block.outer",
					["[i"] = "@conditional.outer",
					["[l"] = "@loop.outer",
				},
				goto_previous_end = {
					["]F"] = "@function.outer",
					["]C"] = "@class.outer",
					["]A"] = "@call.outer",
					["]O"] = "@block.outer",
					["]I"] = "@conditional.outer",
					["]L"] = "@loop.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = { ["<leader>swp"] = "@parameter.inner" },
				swap_previous = { ["<leader>swP"] = "@parameter.inner" },
			},
		},
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn", -- set to `false` to disable one of the mappings
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
		rainbow = {
			enable = true,
			query = "rainbow-parens",
			strategy = require("ts-rainbow").strategy.global,
			-- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
			extended_mode = true,
			max_file_lines = nil,
			-- colors = {}, -- table of hex strings
			-- termcolors = {} -- table of colour name strings
		},
		autotag = { enable = true },
		matchup = { enable = true },
		pairs = {
			enable = true,
			disable = {},
			highlight_pair_events = { "CursorMoved" },
			-- whether to highlight also the part of the pair under cursor (or only the partner)
			highlight_self = false,
			-- whether to go to the end of the right partner or the beginning
			goto_right_end = false,
			-- What command to issue when we can't find a pair (e.g. "normal! %")
			fallback_cmd_normal = "call matchit#Match_wrapper('',1,'n')",
			keymaps = {
				goto_partner = "%",
				delete_balanced = "X",
			},
			delete_balanced = {
				-- whether to trigger balanced delete when on first character of a pair
				only_on_first_char = false,
				-- fallback command when no pair found, can be nil
				fallback_cmd_normal = nil,
				-- whether to delete the longest or the shortest pair when multiple found.
				-- E.g. whether to delete the angle bracket or whole tag in  <pair> </pair>
				longest_partner = false,
			},
		},
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
	})
end

return M
