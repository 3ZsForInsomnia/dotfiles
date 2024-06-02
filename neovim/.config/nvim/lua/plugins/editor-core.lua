return {
  {
    "chentoast/marks.nvim",
    opts = {
      default_mappings = true,
      builtin_marks = { ".", "<", ">", "^" },
      cyclic = true,
      force_write_shada = true,
      refresh_interval = 250,
      sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
      excluded_filetypes = {},
      bookmark_0 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as flagged/normal path of investigation
      bookmark_9 = {
        sign = "⚑",
        annotate = true,
      },
      -- Bookmark as confusing/with a question
      bookmark_8 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as wrong
      bookmark_7 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as home (where I'm currently working)
      bookmark_6 = {
        sign = "ﳐ",
        annotate = true,
      },
      -- Bookmark as info (useful but not wrong/good/home)
      bookmark_5 = {
        sign = "",
        annotate = true,
      },
      mappings = {
        next_bookmark0 = "]0",
        next_bookmark9 = "]9",
        next_bookmark8 = "]8",
        next_bookmark7 = "]7",
        next_bookmark6 = "]6",
        next_bookmark5 = "]5",
        prev_bookmark0 = "[0",
        prev_bookmark9 = "[9",
        prev_bookmark8 = "[8",
        prev_bookmark7 = "[7",
        prev_bookmark6 = "[6",
        prev_bookmark5 = "[5",
      },
    },
  },
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    opts = {},
  },
  { "andymass/vim-matchup" },
  { "winston0410/range-highlight.nvim", opts = {} },
  { "godlygeek/tabular",                event = "VeryLazy" },
  {
    "matbme/JABS.nvim",
    event = "VeryLazy",
    config = function()
      require("jabs").setup({
        position = { "left", "bottom" },
        relative = "editor",
        clip_popup_size = true,

        width = 90,
        height = 40,
        border = "single",

        offset = {
          top = 0,
          bottom = 0,
          left = 1,
          right = 1,
        },

        sort_mru = true,
        split_filename = true,
        split_filename_path_width = 50,

        preview_position = "right",
        preview = {
          width = 100,
          height = 40,
          border = "single",
        },

        highlight = {
          current = "WildMenu",
          hidden = "IncSearch",
          split = "WarningMsg",
          alternate = "DiffAdd",
        },

        symbols = {
          current = "",
          split = "",
          alternate = "",
          hidden = "﬘",
          locked = "",
          ro = "",
          edited = "",
          terminal = "",
          default_file = "",
          terminal_symbol = "",
        },

        keymap = {
          close = "D",
          jump = "<cr>",
          h_split = "h",
          v_split = "v",
          preview = "p",
        },

        use_devicons = true,
      })
    end,
  },
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup({
        mappings = {
          "<C-u>",
          "<C-d>",
          "<C-b>",
          "<C-f>",
          "<C-y>",
          "<C-e>",
          "zt",
          "zz",
          "zb",
        },
        hide_cursor = false,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "cubic",
        pre_hook = nil,
        post_hook = nil,
      })

      local t = {}
      t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100" } }
      t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100" } }
      t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "150" } }
      t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "150" } }
      t["<C-y>"] = { "scroll", { "-0.10", "false", "50" } }
      t["<C-e>"] = { "scroll", { "0.10", "false", "50" } }
      t["zt"] = { "zt", { "100" } }
      t["zz"] = { "zz", { "100" } }
      t["zb"] = { "zb", { "100" } }

      require("neoscroll.config").set_mappings(t)
    end
  },
  { "kylechui/nvim-surround" },
}
