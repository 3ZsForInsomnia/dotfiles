local M = {}

function M.setup()
	local lspServers = {
		"angularls",
		"bashls",
		"cssls",
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

	local cmp = require("cmp")
	local luasnip = require("luasnip")

	local t = function(str)
		return vim.api.nvim_replace_termcodes(str, true, true, true)
	end

	local lspkind = require("lspkind")

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		sources = {
			{ name = "luasnip" },
			{ name = "nvim_lsp_signature_help" },
      { name = "nvim_lsp_document_symbol" },
			{ name = "nvim_lsp" },
			{ name = "treesitter" },
			{ name = "emmet_vim" },
			{ name = "ctags" },
			{ name = "path" },
			{ name = "buffer" },
			{
				name = "spell",
				option = {
					keep_all_entries = false,
					enable_in_context = function()
						return true
					end,
				},
			},
		},
		mapping = {
			["<Tab>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(1) then
					luasnip.jump(1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<Down>"] = cmp.mapping(
				cmp.mapping.select_next_item({
					behavior = cmp.SelectBehavior.Select,
				}),
				{ "i" }
			),
			["<Up>"] = cmp.mapping(
				cmp.mapping.select_prev_item({
					behavior = cmp.SelectBehavior.Select,
				}),
				{ "i" }
			),
			["<C-n>"] = cmp.mapping({
				c = function()
					if cmp.visible() then
						cmp.select_next_item({
							behavior = cmp.SelectBehavior.Select,
						})
					else
						vim.api.nvim_feedkeys(t("<Down>"), "n", true)
					end
				end,
				i = function(fallback)
					if cmp.visible() then
						cmp.select_next_item({
							behavior = cmp.SelectBehavior.Select,
						})
					else
						fallback()
					end
				end,
			}),
			["<C-p>"] = cmp.mapping({
				c = function()
					if cmp.visible() then
						cmp.select_prev_item({
							behavior = cmp.SelectBehavior.Select,
						})
					else
						vim.api.nvim_feedkeys(t("<Up>"), "n", true)
					end
				end,
				i = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item({
							behavior = cmp.SelectBehavior.Select,
						})
					else
						fallback()
					end
				end,
			}),
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-e>"] = cmp.mapping({
				i = cmp.mapping.close(),
				c = cmp.mapping.close(),
			}),
			["<CR>"] = cmp.mapping({
				i = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),
				c = function(fallback)
					if cmp.visible() then
						cmp.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = false,
						})
					else
						fallback()
					end
				end,
			}),
		},
		formatting = {
			format = function(entry, vim_item)
				if vim.tbl_contains({ "path" }, entry.source.name) then
					local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
					if icon then
						vim_item.kind = icon
						vim_item.kind_hl_group = hl_group
						return vim_item
					end
				end
				return lspkind.cmp_format({
					with_text = true,
					menu = {
						nvim_lsp = "LSP",
						buffer = "Buffer",
						nvim_lua = "Lua",
						luasnips = "Snippets",
						treesitter = "Treesitter",
						look = "Look",
						path = "Path",
						spell = "Spell",
						calc = "Calc",
						emoji = "Emoji",
					},
				})(entry, vim_item)
			end,
		},
		enabled = function()
			return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
			-- or require("cmp_dap").is_dap_buffer()
		end,
	})

	cmp.setup.filetype("gitcommit", {
		sources = cmp.config.sources({ { name = "cmp_git" } }, { { name = "buffer" } }),
	})

	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ { name = "nvim_lsp_document_symbol" } },
			{ { name = "buffer" } },
		}),
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline({
			c = function()
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
				else
					cmp.complete()
				end
			end,
		}),
		sources = cmp.config.sources({ { name = "path" } }, {
			{ name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
		}),
	})

	local lsp_flags = {
		-- This is the default in Nvim 0.7+
		debounce_text_changes = 150,
	}

	local navic = require("nvim-navic")
	-- Use an on_attach function to only map the following keys
	-- after the language server attaches to the current buffer
	local on_attach = function(client, bufnr)
		navic.attach(client, bufnr)
		-- Enable completion triggered by <c-x><c-o>
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

		local wk = require("which-key")
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		local l = vim.lsp
		local b = l.buf

		wk.register({
			["<leader>l"] = {
				name = "LSP",
				a = { "<cmd>CodeActionMenu<cr>", "Perform code actions" },
				D = { b.declaration, "Declaration" },
				d = { b.definition, "Definition" },
				i = { b.implementation, "Implementation" },
				r = { b.references, "References" },
				n = { b.rename, "Rename tag under cursor" },
				t = { b.type_definition, "Type definition" },
				f = {
					"<cmd>Format<cr>",
					"Format",
				},
				l = {
					name = "Code lens",
					g = { "<cmd>lua vim.lsp.codelens.get(0)<cr>", "Get lenses" },
					f = { "<cmd>lua vim.lsp.codelens.refresh()<cr>", "Refresh" },
					r = { "<cmd>lua vim.lsp.codelens.run()", "Run" },
					c = {
						"<cmd>lua vim.lsp.codelens.clear(nil, 0)",
						"Clear lenses in buffer",
					},
				},
				w = {
					name = "LSP Workspaces",
					a = { b.add_workspace_folder, "Add folder" },
					r = { b.remove_workspace_folder, "Remove folder" },
					l = {
						function()
							print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
						end,
						"List folder",
					},
				},
			},
			K = { b.hover, "Context" },
			["<C-k>"] = { b.signature_help, "Show signature" },
		}, bufopts)
	end

	-- Set up lspconfig.
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	for _, server in ipairs(lspServers) do
		require("lspconfig")[server].setup({
			on_attach = on_attach,
			flags = lsp_flags,
			capabilities = capabilities,
		})
	end

	require("typescript").setup({
		disable_commands = false,
		debug = false,
		go_to_source_definition = { fallback = true },
		server = {
			on_attach = on_attach,
			flags = lsp_flags,
			capabilities = capabilities,
		},
		javascript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
		typescript = {
			inlayHints = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "sql", "mysql", "plsql" },
		command = "lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })",
	})
end

return M
