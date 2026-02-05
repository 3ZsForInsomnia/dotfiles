local g = vim.g
local cmd = require("helpers").k_cmd
local kcmd = require("helpers").k

local h = "<leader>h"
local k = function(command)
  return "lua require('kulala')." .. command .. "()"
end

local function split_env_var(var, sep)
  local str = os.getenv(var)
  if not str then
    return {}
  end
  local t = {}
  for s in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(t, s)
  end
  return t
end

return {
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest", "gql", "graphql" },
    opts = {
      ui = {
        split_direction = "horizontal",
      },
    },
    keys = {
      cmd({
        key = h .. "a",
        action = "enew<cr><cmd>set filetype=http",
        desc = "Open new HTTP buffer",
      }),
      cmd({
        key = h .. "A",
        action = k("scratchpad"),
        desc = "Open http scratchpad",
      }),
      cmd({
        key = h .. "C",
        action = k("close"),
        desc = "Close http scratchpad",
      }),
      cmd({
        key = h .. "t",
        action = k("toggle_view"),
        desc = "Toggle headers/body",
      }),
      cmd({
        key = h .. "s",
        action = k("show_stats"),
        desc = "Show stats",
      }),
      cmd({
        key = h .. "e",
        action = k("download_graphql_schema"),
        desc = "Download Gql Schema",
      }),
      cmd({
        key = h .. "c",
        action = k("run"),
        desc = "Run HTTP request",
      }),
      cmd({
        key = h .. "i",
        action = k("inspect"),
        desc = "Inspect HTTP request",
      }),
      cmd({
        key = h .. "p",
        action = k("jump_prev"),
        desc = "Jump to previous request",
      }),
      cmd({
        key = h .. "n",
        action = k("jump_next"),
        desc = "Jump to next request",
      }),
      cmd({
        key = h .. "r",
        action = k("replay"),
        desc = "Replay HTTP request",
      }),
    },
  },
  {
    "yoshio15/vim-trello",
    cmd = "VimTrello",
    config = function()
      g.vimTrelloApiKey = os.getenv("TRELLO_API_KEY")
      g.vimTrelloToken = os.getenv("TRELLO_API_TOKEN")
    end,
  },
  {
    -- dir = "~/src/jira-ai",
    "3ZsForInsomnia/jira-ai",
    event = "VeryLazy",
    config = true,
    opts = {
      log_level = "INFO",
      picker = "snacks",
      jira_projects = split_env_var("JIRA_PROJECTS", ","),
      jira_base_url = os.getenv("JIRA_BASE_URL"),
      jira_email_address = os.getenv("JIRA_EMAIL_ADDRESS"),
      jira_api_token = os.getenv("JIRA_API_TOKEN"),
    },
  },
  {
    "ramilito/kubectl.nvim",
    dependencies = "saghen/blink.download",
    lazy = true,
    config = true,
    keys = {
      cmd({
        key = "<leader>ko",
        action = "lua require('kubectl').open()",
        desc = "Open kubectl buffer",
      }),
      cmd({
        key = "<leader>kc",
        action = "lua require('kubectl').close()",
        desc = "Close kubectl buffer",
      }),
      cmd({
        key = "<leader>kt",
        action = "lua require('kubectl').toggle()",
        desc = "Toggle kubectl buffer",
      }),
    },
  },
  {
    "numToStr/Comment.nvim",
    config = true,
    event = "VeryLazy",
  },
  {
    "liuchengxu/vista.vim",
    cmd = "Vista",
    config = function()
      g.vista_default_executive = "nvim_lsp"
      g.vista_sidebar_position = "vertical topleft"
      g.vista_sidebar_width = 35
    end,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      cmd({
        key = "<leader>uu",
        action = "UndotreeToggle",
        desc = "Toggle UndoTree",
      }),
    },
  },
  {
    "lewis6991/hover.nvim",
    event = "VeryLazy",
    config = function()
      return {
        init = function()
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.jira")
          require("hover.providers.dictionary")
          require("hover.providers.dap")
          require("hover.providers.fold_preview")
          require("hover.providers.diagnostic")
          require("hover.providers.man")
          require("hover.providers.gh_user")
        end,

        preview_opts = {
          border = "single",
          width = 50,
        },
        preview_window = true,
        title = true,
      }
    end,
    keys = {
      cmd({
        key = "<C-k>",
        action = "lua require('hover').hover()",
        desc = "Hover",
      }),
      cmd({
        key = "<C-h>",
        action = "lua require('hover').hover_switch('next')",
        desc = "Hover next",
      }),
      cmd({
        key = "<C-l>",
        action = "lua require('hover').hover_switch('previous')",
        desc = "Hover prev",
      }),
      cmd({
        key = "<M-f>",
        action = "lua require('hover').hover_select()",
        desc = "Hover select",
      }),
    },
  },
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    opts = {
      -- The "" filetype is for `nofile`, which is used by VimTrello
      disabled_filetypes = {
        "netrw",
        "lazy",
        "mason",
        "neo-tree",
        "noice",
        "trouble",
        "dbui",
        "vista_kind",
        "dbout",
        "chatgpt-input",
        "copilot-chat",
        "NeogitPopup",
        "codecompanion",
        "octo",
        "mcphub",
        "snacks_notif_history",
        "k8s_pod_logs",
      },
      max_count = 4,
      restricted_keys = {
        ["w"] = { "n", "x" },
        ["b"] = { "n", "x" },
      },
      hints = {
        ["0w"] = {
          message = function()
            return "Use ^ instead of 0w"
          end,
          length = 2,
        },
        ["wh"] = {
          message = function()
            return "Use e instead of wh"
          end,
          length = 2,
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
    ft = { "markdown", "codecompanion" },
    opts = {
      preset = "obsidian",
      filetypes = { "markdown", "codecompanion" },
      debounce = 250,
      completions = {
        blink = { enabled = true },
        lsp = { enabled = true },
      },
    },
  },
  {
    "luckasRanarison/tailwind-tools.nvim",
    ft = {
      "html",
      "css",
      "scss",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      {
        document_color = {
          enabled = true,
          kind = "inline",
          inline_symbol = "󰝤 ",
          debounce = 200,
        },
        conceal = {
          enabled = true,
          min_length = 1,
          symbol = "󱏿",
          highlight = {
            fg = "#38BDF8",
          },
        },
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      filetypes = {
        codecompanion = {
          prompt_for_file_name = false,
          template = "[Image]($FILE_PATH)",
          use_absolute_path = true,
        },
      },
    },
    keys = {
      cmd({
        key = "<leader>zp",
        action = "PasteImage",
        desc = "Paste image form clipboard into buffer",
      }),
    },
  },
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "typescript",
    },
  },
  {
    "relf108/nvim-unstack",
    version = "*",
    lazy = true,
    cmd = { "NvimUnstack", "UnstackFromClipboard" },
    opts = {
      showsigns = true,
      mapkey = false,
    },
    keys = {
      kcmd({
        key = "<leader>zt",
        action = ":'<,'>NvimUnstack",
        desc = "Explore stacktrace from visual selection",
      }),
      cmd({
        key = "<leader>zT",
        action = "UnstackFromClipboard",
        desc = "Explore stacktrace from clipboard",
      }),
    },
  },
}
