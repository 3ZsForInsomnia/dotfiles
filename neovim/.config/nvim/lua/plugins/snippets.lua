local lspServers = {
  "gopls",
  "pyright",
  "cssls",
  "html",
  "jsonls",
  "bashls",
  "dockerls",
  "sumneko_lua",
  "vimls",
  "graphql",
  "angularls",
  "clangd",
  "cmake",
  "sqlls",
  "jdtls",
  "sqlls",
  "stylelint_lsp",
  "tailwindcss",
  "terraformls",
  "vimls",
  "yamlls",
}

local mocha = require("catppuccin.palettes").get_palette("mocha")

local red = mocha.red
local green = mocha.green
local blue = mocha.blue

local visited = {
  hl_group = blue,
}
local unvisited = {
  hl_group = green,
}

local js = "javascript"
local html = "html"
local ts = "typescript"

local luasnipSetupOptions = function(types)
  return {
    history = true,
    delete_check_events = "TextChanged",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "●", mocha.yellow } },
          hl_group = red,
        },
        visited = visited,
        unvisited = unvisited,
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "●", blue } },
          hl_group = red,
        },
        visited = visited,
        unvisited = unvisited,
      },
    },
  }
end

local cmpDependencies = {
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "hrsh7th/cmp-nvim-lsp-document-symbol",
  "kristijanhusak/vim-dadbod-completion",
  "ray-x/cmp-treesitter",
  "quangnguyen30192/cmp-nvim-tags",
  "dcampos/cmp-emmet-vim",
  {
    "zbirenbaum/copilot-cmp",
    config = true,
  },
}

local cmpOpts = function(cmp, defaults)
  return {
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<TAB>"] = LazyVim.cmp.confirm(),
      ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
      ["<C-CR>"] = function(fallback)
        cmp.abort()
        fallback()
      end,
    }),
    auto_brackets = {},
    sources = cmp.config.sources({
      { name = "copilot" },
      { name = "luasnip" },
      { name = "nvim_tags" },
      { name = "treesitter" },
      { name = "nvim_lsp" },
      { name = "nvim_lsp_signature" },
      { name = "nvim_lsp_document_symbol" },
      { name = "buffer" },
      { name = "path" },
      { name = "nvim_lua" },
      { name = "vim-dadbod-completion" },
      { name = "emmet" },
    }),
    formatting = {
      format = function(_, item)
        local icons = require("lazyvim.config").icons.kinds
        if icons[item.kind] then
          item.kind = icons[item.kind] .. item.kind
        end
        return item
      end,
    },
    experimental = {
      ghost_text = {
        hl_group = "CmpGhostText",
      },
    },
    sorting = defaults.sorting,
    window = {
      documentation = cmp.config.window.bordered(),
    },
  }
end

return {
  {
    "L3MON4D3/LuaSnip",
    build = (not LazyVim.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
        or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      {
        "nvim-cmp",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
        },
        opts = function(_, opts)
          opts.snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          }
          table.insert(opts.sources, { name = "luasnip", group_index = 0 })
        end,
      },
    },
    config = function()
      local ls = require("luasnip")
      local types = require("luasnip.util.types")

      require("luasnip.loaders.from_lua").lazy_load({ paths = { "~/.config/nvim/lua/snippets/" } })

      ls.filetype_extend("typescript", { js })
      ls.filetype_extend("javascriptreact", { js, html })
      ls.filetype_extend("typescriptreact", { ts, js, html })

      require("luasnip").config.setup(luasnipSetupOptions(types))
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = cmpDependencies,
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()

      return cmpOpts(cmp, defaults)
    end,
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      local parse = require("cmp.utils.snippet").parse
      require("cmp.utils.snippet").parse = function(input)
        local ok, ret = pcall(parse, input)
        if ok then
          return ret
        end
        return LazyVim.cmp.snippet_preview(input)
      end

      local cmp = require("cmp")

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { { name = "nvim_lsp_document_symbol" } },
          { { name = "buffer" } },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        -- mapping = cmp.mapping.preset.cmdline({
        --   c = function()
        --     if cmp.visible() then
        --       cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        --     else
        --       cmp.complete()
        --     end
        --   end,
        -- }),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
        ),
      })

      cmp.setup(opts)
      cmp.event:on("confirm_done", function(event)
        if vim.tbl_contains(opts.auto_brackets or {}, vim.bo.filetype) then
          LazyVim.cmp.auto_brackets(event.entry)
        end
      end)
      cmp.event:on("menu_opened", function(event)
        LazyVim.cmp.add_missing_snippet_docs(event.window)
      end)

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      for _, server in ipairs(lspServers) do
        local lsp = require("lspconfig")[server]
        if lsp and lsp.capabilities then
          lsp.setup({ capabilities = capabilities })
        end
      end
    end,
  },
}
