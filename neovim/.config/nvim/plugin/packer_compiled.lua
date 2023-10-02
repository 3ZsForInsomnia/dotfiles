-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

_G._packer = _G._packer or {}
_G._packer.inside_compile = true

local time
local profile_info
local should_profile = false
if should_profile then
  local hrtime = vim.loop.hrtime
  profile_info = {}
  time = function(chunk, start)
    if start then
      profile_info[chunk] = hrtime()
    else
      profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
    end
  end
else
  time = function(chunk, start) end
end

local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end
  if threshold then
    table.insert(results, '(Only showing plugins that took longer than ' .. threshold .. ' ms ' .. 'to load)')
  end

  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/zachary/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/zachary/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/zachary/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/zachary/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/zachary/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["JABS.nvim"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16config.jabs\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/JABS.nvim",
    url = "https://github.com/matbme/JABS.nvim"
  },
  LuaSnip = {
    after = { "vscode-angular-snippets", "nvim-cmp", "friendly-snippets" },
    config = { "\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19config.luasnip\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmd-parser.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/cmd-parser.nvim",
    url = "https://github.com/winston0410/cmd-parser.nvim"
  },
  ["cmp-buffer"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-cmdline"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-cmdline/after/plugin/cmp_cmdline.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-cmdline",
    url = "https://github.com/hrsh7th/cmp-cmdline"
  },
  ["cmp-ctags"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-ctags/after/plugin/cmp_ctags.vim" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-ctags",
    url = "https://github.com/delphinus/cmp-ctags"
  },
  ["cmp-emmet-vim"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-emmet-vim/after/plugin/cmp_emmet_vim.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-emmet-vim",
    url = "https://github.com/dcampos/cmp-emmet-vim"
  },
  ["cmp-git"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\fcmp_git\frequire\0" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-git",
    url = "https://github.com/petertriho/cmp-git"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-document-symbol"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp-document-symbol/after/plugin/cmp_nvim_lsp_document_symbol.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp-document-symbol",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-document-symbol"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp-signature-help/after/plugin/cmp_nvim_lsp_signature_help.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-nvim-lua"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-nvim-tags"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-nvim-tags/after/plugin/cmp_nvim_tags.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-nvim-tags",
    url = "https://github.com/quangnguyen30192/cmp-nvim-tags"
  },
  ["cmp-path"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-treesitter"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-treesitter/after/plugin/cmp_treesitter.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp-treesitter",
    url = "https://github.com/ray-x/cmp-treesitter"
  },
  cmp_luasnip = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp_luasnip/after/plugin/cmp_luasnip.lua" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["code-shot.nvim"] = {
    config = { "\27LJ\2\nE\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\28config.code-screenshots\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/code-shot.nvim",
    url = "https://github.com/niuiic/code-shot.nvim"
  },
  ["code_runner.nvim"] = {
    commands = { "RunCode", "RunFile" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/code_runner.nvim",
    url = "https://github.com/CRAG666/code_runner.nvim"
  },
  ["colortils.nvim"] = {
    commands = { "Colortils" },
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colortils\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/colortils.nvim",
    url = "https://github.com/max397574/colortils.nvim"
  },
  ["core.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/core.nvim",
    url = "https://github.com/niuiic/core.nvim"
  },
  ["dash.nvim"] = {
    commands = { "Dash", "DashWord" },
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16config.dash\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/dash.nvim",
    url = "https://github.com/mrjones2014/dash.nvim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["dressing.nvim"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14config.ui\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  ["easypick.nvim"] = {
    commands = { "Easypick" },
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20config.easypick\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/easypick.nvim",
    url = "https://github.com/axkirillov/easypick.nvim"
  },
  ["emmet-vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  ["formatter.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22config.formatting\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/formatter.nvim",
    url = "https://github.com/mhartington/formatter.nvim"
  },
  ["friendly-snippets"] = {
    load_after = {
      LuaSnip = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/friendly-snippets",
    url = "https://github.com/rafamadriz/friendly-snippets"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20config.gitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["hardtime.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20config.hardtime\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/hardtime.nvim",
    url = "https://github.com/m4xshen/hardtime.nvim"
  },
  ["hlargs.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18config.hlargs\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/hlargs.nvim",
    url = "https://github.com/m-demare/hlargs.nvim"
  },
  ["hover.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.hover\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/hover.nvim",
    url = "https://github.com/lewis6991/hover.nvim"
  },
  ["inc-rename.nvim"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15inc_rename\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/inc-rename.nvim",
    url = "https://github.com/smjonas/inc-rename.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22config.statusline\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  ["markdown-preview.nvim"] = {
    config = { "\27LJ\2\nL\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup#config.markdown-preview-config\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  ["marks.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.marks\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/marks.nvim",
    url = "https://github.com/chentoast/marks.nvim"
  },
  ["mason-lspconfig.nvim"] = {
    config = { "\27LJ\2\n_\0\0\4\1\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0-\3\0\0=\3\4\2B\0\2\1K\0\1\0\0\0\21ensure_installed\1\0\0\nsetup\20mason-lspconfig\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/mason-lspconfig.nvim",
    url = "https://github.com/williamboman/mason-lspconfig.nvim"
  },
  ["mason.nvim"] = {
    config = { "\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nmason\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/mason.nvim",
    url = "https://github.com/williamboman/mason.nvim"
  },
  ["neodev.nvim"] = {
    config = { "\27LJ\2\n\v\0\2\2\0\0\0\1K\0\1\0›\1\1\0\4\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\4\0005\3\3\0=\3\5\0023\3\6\0=\3\a\2B\0\2\1K\0\1\0\roverride\0\flibrary\1\0\2\14lspconfig\2\17setup_jsonls\2\1\0\4\ntypes\2\fruntime\2\fenabled\2\fplugins\2\nsetup\vneodev\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/neodev.nvim",
    url = "https://github.com/folke/neodev.nvim"
  },
  neogen = {
    commands = { "Neogen" },
    config = { "\27LJ\2\np\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\19snippet_engine\fluasnip\fenabled\2\24input_after_comment\2\nsetup\vneogen\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/neogen",
    url = "https://github.com/danymat/neogen"
  },
  neogit = {
    commands = { "Neogit" },
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18config.neogit\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/neogit",
    url = "https://github.com/NeogitOrg/neogit"
  },
  ["neoscroll.nvim"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25config.scroll-config\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/neoscroll.nvim",
    url = "https://github.com/karb94/neoscroll.nvim"
  },
  neotest = {
    config = { "\27LJ\2\n%\0\1\3\0\3\0\0046\1\0\0009\1\1\0019\1\2\1D\1\1\0\vgetcwd\afn\bvimØ\1\1\0\b\0\v\1\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\t\0004\3\3\0006\4\0\0'\6\3\0B\4\2\0025\6\4\0005\a\5\0=\a\6\0063\a\a\0=\a\b\6B\4\2\0?\4\0\0=\3\n\2B\0\2\1K\0\1\0\radapters\1\0\0\bcwd\0\benv\1\0\1\aCI\2\1\0\2\16jestCommand\16npm test --\19jestConfigFile\26custom.jest.config.ts\17neotest-jest\nsetup\fneotest\frequire\3€€À™\4\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/neotest",
    url = "https://github.com/nvim-neotest/neotest"
  },
  ["neotest-jest"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/neotest-jest",
    url = "https://github.com/haydenmeade/neotest-jest"
  },
  ["noice.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.noice\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/noice.nvim",
    url = "https://github.com/folke/noice.nvim"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["nvim-cmp"] = {
    after = { "cmp-path", "cmp-buffer", "cmp-emmet-vim", "cmp_luasnip", "cmp-nvim-lua", "cmp-nvim-lsp-document-symbol", "cmp-treesitter", "cmp-cmdline", "cmp-git", "cmp-ctags", "vim-dadbod-completion", "cmp-nvim-tags", "cmp-nvim-lsp-signature-help" },
    config = { "\27LJ\2\n@\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\23config.cmp-and-lsp\frequire\0" },
    load_after = {
      LuaSnip = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-code-action-menu"] = {
    commands = { "CodeActionMenu" },
    load_after = {},
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-code-action-menu",
    url = "https://github.com/weilbith/nvim-code-action-menu"
  },
  ["nvim-dap"] = {
    after = { "nvim-dap-vscode-js", "nvim-dap-virtual-text", "nvim-dap-python", "nvim-dap-ui", "vscode-js-debug", "telescope-dap.nvim" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-python"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-dap-ui"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-dap-virtual-text"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-dap-virtual-text",
    url = "https://github.com/theHamsta/nvim-dap-virtual-text"
  },
  ["nvim-dap-vscode-js"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-dap-vscode-js",
    url = "https://github.com/mxsdev/nvim-dap-vscode-js"
  },
  ["nvim-highlight-colors"] = {
    config = { "\27LJ\2\n‚\1\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\3\24enable_named_colors\2\20enable_tailwind\2\vrender\15background\nsetup\26nvim-highlight-colors\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-highlight-colors",
    url = "https://github.com/brenoprata10/nvim-highlight-colors"
  },
  ["nvim-jdtls"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-jdtls",
    url = "https://github.com/mfussenegger/nvim-jdtls"
  },
  ["nvim-lint"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\19config.linting\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-lint",
    url = "https://github.com/mfussenegger/nvim-lint"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-navic"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-navic",
    url = "https://github.com/SmiteshP/nvim-navic"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\14max_width\3x\nsetup\vnotify\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-regexplainer"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\24config.regexplainer\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-regexplainer",
    url = "https://github.com/bennypowers/nvim-regexplainer"
  },
  ["nvim-surround"] = {
    config = { "\27LJ\2\n?\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\18nvim-surround\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25config.file-explorer\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/nvim-tree/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    after = { "refactoring.nvim" },
    config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22config.treesitter\frequire\0" },
    loaded = true,
    only_config = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-context"] = {
    config = { "\27LJ\2\nG\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\30config.treesitter-context\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-treesitter-context",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-context"
  },
  ["nvim-treesitter-pairs"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-treesitter-pairs",
    url = "https://github.com/theHamsta/nvim-treesitter-pairs"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-treesitter-textsubjects"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textsubjects",
    url = "https://github.com/RRethy/nvim-treesitter-textsubjects"
  },
  ["nvim-ts-autotag"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-ts-autotag",
    url = "https://github.com/windwp/nvim-ts-autotag"
  },
  ["nvim-ts-rainbow2"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow2",
    url = "https://github.com/HiPhish/nvim-ts-rainbow2"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["nx.nvim"] = {
    config = { "\27LJ\2\nÚ\1\0\0\6\0\n\0\0196\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0006\3\0\0'\5\4\0B\3\2\0029\3\5\3B\3\1\2=\3\6\0026\3\0\0'\5\a\0B\3\2\0029\3\b\3B\3\1\2=\3\t\2B\0\2\1K\0\1\0\18form_renderer\14telescope\22nx.form-renderers\19command_runner\17terminal_cmd\23nx.command-runners\1\0\2\16nx_cmd_root\anx\14read_init\2\nsetup\anx\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/nx.nvim",
    url = "https://github.com/Equilibris/nx.nvim"
  },
  ["obsidian.nvim"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/obsidian.nvim/after/plugin/cmp_obsidian.lua", "/Users/zachary/.local/share/nvim/site/pack/packer/opt/obsidian.nvim/after/plugin/cmp_obsidian_new.lua" },
    commands = { "Obsidian", "ObsidianNew", "ObsidianOpen", "ObsidianToday", "ObsidianTemplate", "ObsidianQuickSwitch", "ObsidianSearch" },
    config = { "\27LJ\2\nW\0\0\3\0\4\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\1K\0\1\0\18keys.obsidian\nsetup\20config.obsidian\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/obsidian.nvim",
    url = "https://github.com/epwalsh/obsidian.nvim"
  },
  ["octo.nvim"] = {
    commands = { "Octo" },
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16config.octo\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/octo.nvim",
    url = "https://github.com/pwntester/octo.nvim"
  },
  ["other.nvim"] = {
    commands = { "Other" },
    config = { "\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21config.alternate\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/other.nvim",
    url = "https://github.com/rgroli/other.nvim"
  },
  ["package-info.nvim"] = {
    config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17package-info\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/package-info.nvim",
    url = "https://github.com/vuki656/package-info.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plantuml-previewer.vim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/plantuml-previewer.vim",
    url = "https://github.com/weirongxu/plantuml-previewer.vim"
  },
  ["plantuml-syntax"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/plantuml-syntax",
    url = "https://github.com/aklt/plantuml-syntax"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["prettier.nvim"] = {
    commands = { "Prettier", "PrettierFragment", "PrettierPartial" },
    config = { "\27LJ\2\nK\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\bbin\14prettierd\nsetup\rprettier\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/prettier.nvim",
    url = "https://github.com/MunifTanjim/prettier.nvim"
  },
  ["range-highlight.nvim"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\20range-highlight\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/range-highlight.nvim",
    url = "https://github.com/winston0410/range-highlight.nvim"
  },
  ["refactoring.nvim"] = {
    config = { "\27LJ\2\n=\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\16refactoring\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/refactoring.nvim",
    url = "https://github.com/ThePrimeagen/refactoring.nvim"
  },
  ["rest.nvim"] = {
    commands = { "RestNvim" },
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16config.rest\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/rest.nvim",
    url = "https://github.com/rest-nvim/rest.nvim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/kkharji/sqlite.lua"
  },
  tabular = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/tabular/after/plugin/TabularMaps.vim" },
    commands = { "Tabularize" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/tabular",
    url = "https://github.com/godlygeek/tabular"
  },
  ["tailiscope.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/tailiscope.nvim",
    url = "https://github.com/danielvolchek/tailiscope.nvim"
  },
  ["telescope-angular"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-angular",
    url = "https://github.com/3ZsForInsomnia/telescope-angular"
  },
  ["telescope-changes.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-changes.nvim",
    url = "https://github.com/LinArcX/telescope-changes.nvim"
  },
  ["telescope-dap.nvim"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/telescope-dap.nvim",
    url = "https://github.com/nvim-telescope/telescope-dap.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
  },
  ["telescope-frecency.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-heading.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-heading.nvim",
    url = "https://github.com/crispgm/telescope-heading.nvim"
  },
  ["telescope-http.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-http.nvim",
    url = "https://github.com/barrett-ruth/telescope-http.nvim"
  },
  ["telescope-live-grep-args.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-live-grep-args.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-args.nvim"
  },
  ["telescope-luasnip.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-luasnip.nvim",
    url = "https://github.com/benfowler/telescope-luasnip.nvim"
  },
  ["telescope-packer.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-packer.nvim",
    url = "https://github.com/nvim-telescope/telescope-packer.nvim"
  },
  ["telescope-scriptnames.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-scriptnames.nvim",
    url = "https://github.com/LinArcX/telescope-scriptnames.nvim"
  },
  ["telescope-session.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-session.nvim",
    url = "https://github.com/HUAHUAI23/telescope-session.nvim"
  },
  ["telescope-undo.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/telescope-undo.nvim",
    url = "https://github.com/debugloop/telescope-undo.nvim"
  },
  ["telescope.nvim"] = {
    commands = { "Telescope" },
    config = { "\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21config.telescope\frequire\0" },
    keys = { { "", "<leader>f" } },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18todo-comments\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["trouble.nvim"] = {
    commands = { "TroubleToggle" },
    config = { "\27LJ\2\nw\0\0\5\0\b\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\3=\3\a\2B\0\2\1K\0\1\0\16action_keys\ropen_tab\1\0\0\1\2\0\0\n<c-t>\1\0\1\vheight\3\20\nsetup\ftrouble\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["ts-node-action"] = {
    config = { "\27LJ\2\n@\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\19ts-node-action\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/ts-node-action",
    url = "https://github.com/ckolkey/ts-node-action"
  },
  ["twilight.nvim"] = {
    commands = { "Twilight" },
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rtwilight\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/twilight.nvim",
    url = "https://github.com/folke/twilight.nvim"
  },
  ["typescript.nvim"] = {
    config = { "\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\15typescript\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/typescript.nvim",
    url = "https://github.com/jose-elias-alvarez/typescript.nvim"
  },
  undotree = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/undotree",
    url = "https://github.com/mbbill/undotree"
  },
  ["vim-dadbod"] = {
    commands = { "DB" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-dadbod",
    url = "https://github.com/tpope/vim-dadbod"
  },
  ["vim-dadbod-completion"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-dadbod-completion/after/plugin/vim_dadbod_completion.lua", "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-dadbod-completion/after/plugin/vim_dadbod_completion.vim" },
    load_after = {
      ["nvim-cmp"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-dadbod-completion",
    url = "https://github.com/kristijanhusak/vim-dadbod-completion"
  },
  ["vim-dadbod-ui"] = {
    commands = { "DBUI", "DBUIToggle" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-dadbod-ui",
    url = "https://github.com/kristijanhusak/vim-dadbod-ui"
  },
  ["vim-gh-line"] = {
    commands = { "GH", "GHInteractive" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-gh-line",
    url = "https://github.com/ruanyl/vim-gh-line"
  },
  ["vim-mailquery"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/vim-mailquery",
    url = "https://github.com/Konfekt/vim-mailquery"
  },
  ["vim-matchup"] = {
    after_files = { "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-matchup/after/plugin/matchit.vim" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-matchup",
    url = "https://github.com/andymass/vim-matchup"
  },
  ["vim-moonfly-colors"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/vim-moonfly-colors",
    url = "https://github.com/bluz71/vim-moonfly-colors"
  },
  ["vim-mutt-aliases"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/vim-mutt-aliases",
    url = "https://github.com/Konfekt/vim-mutt-aliases"
  },
  ["vim-notmuch-addrlookup"] = {
    config = { "\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16config.mail\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/vim-notmuch-addrlookup",
    url = "https://github.com/Konfekt/vim-notmuch-addrlookup"
  },
  ["vim-startuptime"] = {
    commands = { "StartupTime" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-startuptime",
    url = "https://github.com/dstein64/vim-startuptime"
  },
  ["vim-trello"] = {
    commands = { "VimTrello" },
    config = { "\27LJ\2\n;\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\18config.trello\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vim-trello",
    url = "https://github.com/yoshio15/vim-trello"
  },
  ["vista.vim"] = {
    commands = { "Vista" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vista.vim",
    url = "https://github.com/liuchengxu/vista.vim"
  },
  ["vscode-angular-snippets"] = {
    load_after = {
      LuaSnip = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vscode-angular-snippets",
    url = "https://github.com/johnpapa/vscode-angular-snippets"
  },
  ["vscode-js-debug"] = {
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/opt/vscode-js-debug",
    url = "https://github.com/microsoft/vscode-js-debug"
  },
  ["which-key.nvim"] = {
    config = { "\27LJ\2\nZ\0\0\3\0\4\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\rkeys.git\nsetup\20config.whichkey\frequire\0" },
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/which-key.nvim",
    url = "https://github.com/folke/which-key.nvim"
  },
  ["yop.nvim"] = {
    loaded = true,
    path = "/Users/zachary/.local/share/nvim/site/pack/packer/start/yop.nvim",
    url = "https://github.com/zdcthomas/yop.nvim"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^dap"] = "nvim-dap",
  ["^neogen"] = "neogen",
  ["^neogit"] = "neogit",
  ["^neotest"] = "neotest",
  ["^nx"] = "nx.nvim",
  ["^refactoring"] = "refactoring.nvim",
  ["^telescope"] = "telescope.nvim",
  ["^twilight"] = "twilight.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\nB\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\25config.file-explorer\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: dressing.nvim
time([[Config for dressing.nvim]], true)
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14config.ui\frequire\0", "config", "dressing.nvim")
time([[Config for dressing.nvim]], false)
-- Config for: which-key.nvim
time([[Config for which-key.nvim]], true)
try_loadstring("\27LJ\2\nZ\0\0\3\0\4\0\v6\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\0016\0\0\0'\2\3\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\rkeys.git\nsetup\20config.whichkey\frequire\0", "config", "which-key.nvim")
time([[Config for which-key.nvim]], false)
-- Config for: hardtime.nvim
time([[Config for hardtime.nvim]], true)
try_loadstring("\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20config.hardtime\frequire\0", "config", "hardtime.nvim")
time([[Config for hardtime.nvim]], false)
-- Config for: noice.nvim
time([[Config for noice.nvim]], true)
try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.noice\frequire\0", "config", "noice.nvim")
time([[Config for noice.nvim]], false)
-- Config for: JABS.nvim
time([[Config for JABS.nvim]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16config.jabs\frequire\0", "config", "JABS.nvim")
time([[Config for JABS.nvim]], false)
-- Config for: typescript.nvim
time([[Config for typescript.nvim]], true)
try_loadstring("\27LJ\2\n<\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\15typescript\frequire\0", "config", "typescript.nvim")
time([[Config for typescript.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22config.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: mason.nvim
time([[Config for mason.nvim]], true)
try_loadstring("\27LJ\2\n3\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\nmason\frequire\0", "config", "mason.nvim")
time([[Config for mason.nvim]], false)
-- Config for: nvim-treesitter-context
time([[Config for nvim-treesitter-context]], true)
try_loadstring("\27LJ\2\nG\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\30config.treesitter-context\frequire\0", "config", "nvim-treesitter-context")
time([[Config for nvim-treesitter-context]], false)
-- Config for: inc-rename.nvim
time([[Config for inc-rename.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15inc_rename\frequire\0", "config", "inc-rename.nvim")
time([[Config for inc-rename.nvim]], false)
-- Config for: mason-lspconfig.nvim
time([[Config for mason-lspconfig.nvim]], true)
try_loadstring("\27LJ\2\n_\0\0\4\1\5\0\t6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0-\3\0\0=\3\4\2B\0\2\1K\0\1\0\0\0\21ensure_installed\1\0\0\nsetup\20mason-lspconfig\frequire\0", "config", "mason-lspconfig.nvim")
time([[Config for mason-lspconfig.nvim]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\nG\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\14max_width\3x\nsetup\vnotify\frequire\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: vim-notmuch-addrlookup
time([[Config for vim-notmuch-addrlookup]], true)
try_loadstring("\27LJ\2\n9\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\16config.mail\frequire\0", "config", "vim-notmuch-addrlookup")
time([[Config for vim-notmuch-addrlookup]], false)
-- Config for: code-shot.nvim
time([[Config for code-shot.nvim]], true)
try_loadstring("\27LJ\2\nE\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\28config.code-screenshots\frequire\0", "config", "code-shot.nvim")
time([[Config for code-shot.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-navic ]]
vim.cmd [[ packadd nvim-lspconfig ]]
time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.api.nvim_create_user_command, 'Telescope', function(cmdargs)
          require('packer.load')({'telescope.nvim'}, { cmd = 'Telescope', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'telescope.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Telescope ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Vista', function(cmdargs)
          require('packer.load')({'vista.vim'}, { cmd = 'Vista', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vista.vim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Vista ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Tabularize', function(cmdargs)
          require('packer.load')({'tabular'}, { cmd = 'Tabularize', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'tabular'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Tabularize ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Obsidian', function(cmdargs)
          require('packer.load')({'obsidian.nvim'}, { cmd = 'Obsidian', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'obsidian.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Obsidian ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'ObsidianNew', function(cmdargs)
          require('packer.load')({'obsidian.nvim'}, { cmd = 'ObsidianNew', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'obsidian.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('ObsidianNew ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'ObsidianOpen', function(cmdargs)
          require('packer.load')({'obsidian.nvim'}, { cmd = 'ObsidianOpen', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'obsidian.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('ObsidianOpen ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Other', function(cmdargs)
          require('packer.load')({'other.nvim'}, { cmd = 'Other', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'other.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Other ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'ObsidianTemplate', function(cmdargs)
          require('packer.load')({'obsidian.nvim'}, { cmd = 'ObsidianTemplate', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'obsidian.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('ObsidianTemplate ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'ObsidianQuickSwitch', function(cmdargs)
          require('packer.load')({'obsidian.nvim'}, { cmd = 'ObsidianQuickSwitch', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'obsidian.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('ObsidianQuickSwitch ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'ObsidianSearch', function(cmdargs)
          require('packer.load')({'obsidian.nvim'}, { cmd = 'ObsidianSearch', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'obsidian.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('ObsidianSearch ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Colortils', function(cmdargs)
          require('packer.load')({'colortils.nvim'}, { cmd = 'Colortils', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'colortils.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Colortils ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'VimTrello', function(cmdargs)
          require('packer.load')({'vim-trello'}, { cmd = 'VimTrello', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-trello'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('VimTrello ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'TroubleToggle', function(cmdargs)
          require('packer.load')({'trouble.nvim'}, { cmd = 'TroubleToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'trouble.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('TroubleToggle ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'RunFile', function(cmdargs)
          require('packer.load')({'code_runner.nvim'}, { cmd = 'RunFile', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'code_runner.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('RunFile ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Prettier', function(cmdargs)
          require('packer.load')({'prettier.nvim'}, { cmd = 'Prettier', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'prettier.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Prettier ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'RestNvim', function(cmdargs)
          require('packer.load')({'rest.nvim'}, { cmd = 'RestNvim', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'rest.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('RestNvim ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'PrettierPartial', function(cmdargs)
          require('packer.load')({'prettier.nvim'}, { cmd = 'PrettierPartial', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'prettier.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('PrettierPartial ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Neogen', function(cmdargs)
          require('packer.load')({'neogen'}, { cmd = 'Neogen', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'neogen'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Neogen ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Octo', function(cmdargs)
          require('packer.load')({'octo.nvim'}, { cmd = 'Octo', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'octo.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Octo ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Neogit', function(cmdargs)
          require('packer.load')({'neogit'}, { cmd = 'Neogit', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'neogit'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Neogit ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'StartupTime', function(cmdargs)
          require('packer.load')({'vim-startuptime'}, { cmd = 'StartupTime', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-startuptime'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('StartupTime ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'GHInteractive', function(cmdargs)
          require('packer.load')({'vim-gh-line'}, { cmd = 'GHInteractive', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-gh-line'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('GHInteractive ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'DBUI', function(cmdargs)
          require('packer.load')({'vim-dadbod-ui'}, { cmd = 'DBUI', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dadbod-ui'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('DBUI ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'DBUIToggle', function(cmdargs)
          require('packer.load')({'vim-dadbod-ui'}, { cmd = 'DBUIToggle', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dadbod-ui'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('DBUIToggle ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Twilight', function(cmdargs)
          require('packer.load')({'twilight.nvim'}, { cmd = 'Twilight', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'twilight.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Twilight ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'DB', function(cmdargs)
          require('packer.load')({'vim-dadbod'}, { cmd = 'DB', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-dadbod'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('DB ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Dash', function(cmdargs)
          require('packer.load')({'dash.nvim'}, { cmd = 'Dash', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'dash.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Dash ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'DashWord', function(cmdargs)
          require('packer.load')({'dash.nvim'}, { cmd = 'DashWord', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'dash.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('DashWord ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'Easypick', function(cmdargs)
          require('packer.load')({'easypick.nvim'}, { cmd = 'Easypick', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'easypick.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('Easypick ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'GH', function(cmdargs)
          require('packer.load')({'vim-gh-line'}, { cmd = 'GH', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'vim-gh-line'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('GH ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'CodeActionMenu', function(cmdargs)
          require('packer.load')({'nvim-code-action-menu'}, { cmd = 'CodeActionMenu', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'nvim-code-action-menu'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('CodeActionMenu ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'RunCode', function(cmdargs)
          require('packer.load')({'code_runner.nvim'}, { cmd = 'RunCode', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'code_runner.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('RunCode ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'PrettierFragment', function(cmdargs)
          require('packer.load')({'prettier.nvim'}, { cmd = 'PrettierFragment', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'prettier.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('PrettierFragment ', 'cmdline')
      end})
pcall(vim.api.nvim_create_user_command, 'ObsidianToday', function(cmdargs)
          require('packer.load')({'obsidian.nvim'}, { cmd = 'ObsidianToday', l1 = cmdargs.line1, l2 = cmdargs.line2, bang = cmdargs.bang, args = cmdargs.args, mods = cmdargs.mods }, _G.packer_plugins)
        end,
        {nargs = '*', range = true, bang = true, complete = function()
          require('packer.load')({'obsidian.nvim'}, {}, _G.packer_plugins)
          return vim.fn.getcompletion('ObsidianToday ', 'cmdline')
      end})
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <leader>f <cmd>lua require("packer.load")({'telescope.nvim'}, { keys = "<lt>leader>f", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType css ++once lua require("packer.load")({'nvim-highlight-colors'}, { ft = "css" }, _G.packer_plugins)]]
vim.cmd [[au FileType scss ++once lua require("packer.load")({'nvim-highlight-colors'}, { ft = "scss" }, _G.packer_plugins)]]
vim.cmd [[au FileType uml ++once lua require("packer.load")({'plantuml-syntax', 'plantuml-previewer.vim'}, { ft = "uml" }, _G.packer_plugins)]]
vim.cmd [[au FileType bash ++once lua require("packer.load")({'nvim-highlight-colors'}, { ft = "bash" }, _G.packer_plugins)]]
vim.cmd [[au FileType zsh ++once lua require("packer.load")({'nvim-highlight-colors'}, { ft = "zsh" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'neodev.nvim', 'nvim-highlight-colors'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType hbs ++once lua require("packer.load")({'emmet-vim'}, { ft = "hbs" }, _G.packer_plugins)]]
vim.cmd [[au FileType sh ++once lua require("packer.load")({'nvim-highlight-colors'}, { ft = "sh" }, _G.packer_plugins)]]
vim.cmd [[au FileType json ++once lua require("packer.load")({'package-info.nvim'}, { ft = "json" }, _G.packer_plugins)]]
vim.cmd [[au FileType jsx ++once lua require("packer.load")({'nvim-highlight-colors', 'emmet-vim'}, { ft = "jsx" }, _G.packer_plugins)]]
vim.cmd [[au FileType tsx ++once lua require("packer.load")({'nvim-highlight-colors', 'emmet-vim'}, { ft = "tsx" }, _G.packer_plugins)]]
vim.cmd [[au FileType html ++once lua require("packer.load")({'emmet-vim'}, { ft = "html" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufReadPost * ++once lua require("packer.load")({'range-highlight.nvim', 'nvim-regexplainer', 'nvim-lint', 'obsidian.nvim', 'neogit', 'formatter.nvim', 'vim-matchup', 'Comment.nvim', 'neoscroll.nvim', 'undotree', 'hlargs.nvim', 'marks.nvim', 'todo-comments.nvim', 'lualine.nvim', 'hover.nvim', 'nvim-surround', 'gitsigns.nvim', 'LuaSnip'}, { event = "BufReadPost *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'ts-node-action'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /Users/zachary/.local/share/nvim/site/pack/packer/opt/plantuml-syntax/ftdetect/plantuml.vim]], true)
vim.cmd [[source /Users/zachary/.local/share/nvim/site/pack/packer/opt/plantuml-syntax/ftdetect/plantuml.vim]]
time([[Sourcing ftdetect script at: /Users/zachary/.local/share/nvim/site/pack/packer/opt/plantuml-syntax/ftdetect/plantuml.vim]], false)
vim.cmd("augroup END")

_G._packer.inside_compile = false
if _G._packer.needs_bufread == true then
  vim.cmd("doautocmd BufRead")
end
_G._packer.needs_bufread = false

if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
