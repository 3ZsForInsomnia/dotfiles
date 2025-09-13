local v = vim
local g = v.g

local red = "ErrorMsg"
local green = "SpellRare"
local blue = "Folded"
local yellow = "SpellCap"

local visited = {
  hl_group = blue,
}
local unvisited = {
  hl_group = green,
}

local js = "javascript"
local html = "html"
local ts = "typescript"
local snippetsLocation = v.fn.stdpath("config") .. "/snippets"

local colorful_menu_config = function()
  require("colorful-menu").setup({
    ls = {
      lua_ls = {
        -- Maybe you want to dim arguments a bit.
        arguments_hl = "@comment",
      },
      gopls = {
        -- By default, we render variable/function's type in the right most side,
        -- to make them not to crowd together with the original label.

        -- when true:
        -- foo             *Foo
        -- ast         "go/ast"

        -- when false:
        -- foo *Foo
        -- ast "go/ast"
        align_type_to_right = true,
        -- When true, label for field and variable will format like "foo: Foo"
        -- instead of go's original syntax "foo Foo". If align_type_to_right is
        -- true, this option has no effect.
        add_colon_before_type = false,
        -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
        preserve_type_when_truncate = true,
      },
      -- for lsp_config or typescript-tools
      ts_ls = {
        -- false means do not include any extra info,
        -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
        extra_info_hl = "@comment",
      },
      vtsls = {
        -- false means do not include any extra info,
        -- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
        extra_info_hl = "@comment",
      },
      ["rust-analyzer"] = {
        -- Such as (as Iterator), (use std::io).
        extra_info_hl = "@comment",
        -- Similar to the same setting of gopls.
        align_type_to_right = true,
        -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
        preserve_type_when_truncate = true,
      },
      clangd = {
        -- Such as "From <stdio.h>".
        extra_info_hl = "@comment",
        -- Similar to the same setting of gopls.
        align_type_to_right = true,
        -- the hl group of leading dot of "•std::filesystem::permissions(..)"
        import_dot_hl = "@comment",
        -- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
        preserve_type_when_truncate = true,
      },
      zls = {
        -- Similar to the same setting of gopls.
        align_type_to_right = true,
      },
      roslyn = {
        extra_info_hl = "@comment",
      },
      dartls = {
        extra_info_hl = "@comment",
      },
      -- The same applies to pyright/pylance
      basedpyright = {
        -- It is usually import path such as "os"
        extra_info_hl = "@comment",
      },
      pylsp = {
        extra_info_hl = "@comment",
        -- Dim the function argument area, which is the main
        -- difference with pyright.
        arguments_hl = "@comment",
      },
      -- If true, try to highlight "not supported" languages.
      fallback = true,
      -- this will be applied to label description for unsupport languages
      fallback_extra_info_hl = "@comment",
    },
    -- If the built-in logic fails to find a suitable highlight group for a label,
    -- this highlight is applied to the label.
    fallback_highlight = "@variable",
    -- If provided, the plugin truncates the final displayed text to
    -- this width (measured in display cells). Any highlights that extend
    -- beyond the truncation point are ignored. When set to a float
    -- between 0 and 1, it'll be treated as percentage of the width of
    -- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
    -- Default 60.
    max_width = 60,
  })
end

local filetypes_to_load_snippets_for = {
  "bash",
  "zsh",
  "css",
  "scss",
  "html",
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
  "python",
  "go",
  "sql",
  "json",
  "markdown",
  "lua",
}

local function load_snippets_for_ft()
  local ft = v.bo.filetype
  if ft and ft ~= "" then
    require("luasnip.loaders.from_vscode").lazy_load({
      include = { ft },
    })
  end
end

v.api.nvim_create_autocmd({ "FileType" }, {
  pattern = filetypes_to_load_snippets_for,
  callback = load_snippets_for_ft,
})

local luasnipSetupOptions = function()
  local types = require("luasnip.util.types")
  return {
    history = true,
    delete_check_events = "TextChanged",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "●", yellow } },
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

return {
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    -- event = "InsertEnter",
    dependencies = {
      { "rafamadriz/friendly-snippets", lazy = true },
    },
    config = function()
      local ls = require("luasnip")
      ls.setup({
        history = true,
        delete_check_events = "TextChanged",
      })

      ls.config.setup(luasnipSetupOptions())

      ls.filetype_extend("typescript", { js })
      ls.filetype_extend("javascriptreact", { js, html })
      ls.filetype_extend("typescriptreact", { ts, js, html })

      require("luasnip.loaders.from_lua").lazy_load({ paths = { snippetsLocation } })

      ---@diagnostic disable-next-line: duplicate-set-field
      LazyVim.cmp.actions.snippet_forward = function()
        if ls.jumpable(1) then
          v.schedule(function()
            ls.jump(1)
          end)
          return true
        end
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      LazyVim.cmp.actions.snippet_stop = function()
        if ls.expand_or_jumpable() then -- or just jumpable(1) is fine?
          ls.unlink_current()
          return true
        end
      end
    end,
  },
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = not g.lazyvim_blink_main and "*",
    build = g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.default",
    },
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
      "disrupted/blink-cmp-conventional-commits",
      "bydlw98/blink-cmp-env",
      "Kaiser-Yang/blink-cmp-git",
      {
        "xzbdmw/colorful-menu.nvim",
        config = colorful_menu_config,
      },
      "moyiz/blink-emoji.nvim",
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql" },
      },
      "L3MON4D3/LuaSnip",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = {
        preset = "luasnip",
      },
      appearance = {
        kind_icons = {
          Copilot = "",
          Text = "󰉿",
          Method = "󰊕",
          Function = "󰊕",
          Constructor = "󰒓",

          Field = "󰜢",
          Variable = "󰆦",
          Property = "󰖷",

          Class = "󱡠",
          Interface = "󱡠",
          Struct = "󱡠",
          Module = "󰅩",

          Unit = "󰪚",
          Value = "󰦨",
          Enum = "󰦨",
          EnumMember = "󰦨",

          Keyword = "󰻾",
          Constant = "󰏿",

          Snippet = "󱄽",
          Color = "󰏘",
          File = "󰈔",
          Reference = "󰬲",
          Folder = "󰉋",
          Event = "󱐋",
          Operator = "󰪚",
          TypeParameter = "󰬛",
        },
      },
      completion = {
        menu = {
          min_width = 30,
          max_height = 20,
          draw = {
            treesitter = { "lsp" },
            padding = 2,
            gap = 2,
            columns = {
              { "kind_icon", "kind", "label" },
              { "label_description", "source_name" },
            },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            min_width = 20,
            max_height = 50,
          },
        },
        ghost_text = {
          enabled = g.ai_cmp,
          auto_show = true,
        },
      },
      sources = {
        default = {
          "snippets",
          "copilot",
          "lsp",
          "dadbod",
          "git",
          "env",
          "path",
          "emoji",
          "conventional_commits",
          "buffer",
          "path",
        },
        providers = {
          buffer = {
            name = "Buffer",
            max_items = 5,
          },
          conventional_commits = {
            name = "Conventional Commits",
            module = "blink-cmp-conventional-commits",
            enabled = function()
              return v.bo.filetype == "gitcommit"
            end,
          },
          copilot = {
            name = "copilot",
            kind = "Copilot",
            module = "blink-cmp-copilot",
            max_items = 2,
            score_offset = 100,
            async = true,
            transform_items = function(_, items)
              local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
              local kind_idx = #CompletionItemKind + 1
              CompletionItemKind[kind_idx] = "Copilot"

              for _, item in ipairs(items) do
                item.kind = kind_idx
              end

              return items
            end,
          },
          dadbod = {
            name = "Dadbod",
            module = "vim_dadbod_completion.blink",
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            max_items = 5,
            opts = { insert = true }, -- Insert emoji (default) or complete its name
          },
          env = {
            name = "Env",
            module = "blink-cmp-env",
            max_items = 3,
            --- @type blink-cmp-env.Options
            opts = {
              item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
              show_braces = false,
              show_documentation_window = true,
            },
          },
          git = {
            module = "blink-cmp-git",
            name = "Git",
            max_items = 5,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            max_items = 7,
            score_offset = 100, -- show at a higher priority than lsp
          },
          lsp = {
            max_items = 7,
          },
        },
        per_filetype = {
          codecompanion = { inherit_defaults = true, "codecompanion" },
        },
      },
      signature = {
        enabled = true,
        trigger = {
          enabled = true,
        },
        window = {
          scrollbar = true,
          min_width = 20,
          max_height = 50,
        },
      },
      cmdline = {
        enabled = true,
        keymap = {
          ["<Tab>"] = { "show", "accept" },
        },
        completion = {
          menu = {
            auto_show = true,
          },
          ghost_text = {
            enabled = true,
          },
        },
      },
      keymap = {
        preset = "super-tab",
        -- Allows C-e to toggle showing/hiding autocompletions rather than just hiding
        ["<C-e>"] = { "hide", "show" },
      },
    },
    ---@param opts blink.cmp.Config
    config = function(_, opts)
      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },
}
