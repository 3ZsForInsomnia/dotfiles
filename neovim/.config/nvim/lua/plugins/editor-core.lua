local v = vim
local s = v.keymap.set
local getbuf = v.api.nvim_get_current_buf
local k_cmd = require("helpers").k_cmd
local k = require("helpers").k
local l = "<leader>"
local z = l .. "zs"
local ll = l .. "ll"
local a = 'lua require("ts-node-action").'

local bk = "<leader>bl"

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = v.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = v.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = v.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      local custom_folds = {}

      local function custom_regions_fold(bufnr)
        return function()
          local regions = custom_folds[bufnr]
          if regions and #regions > 0 then
            return regions
          end

          return {}
        end
      end

      local provider_selector = function(bufnr, filetype, buftype)
        return { "lsp", custom_regions_fold(bufnr) }
      end

      s("v", "<leader>zf", function()
        local bufnr = getbuf()
        local start = v.fn.line("v") - 1
        local finish = v.fn.line(".") - 1
        if start > finish then
          start, finish = finish, start
        end
        custom_folds[bufnr] = custom_folds[bufnr] or {}
        for _, region in ipairs(custom_folds[bufnr]) do
          if region[1] == start and region[2] == finish then
            return
          end
        end
        table.insert(custom_folds[bufnr], { start, finish })
        require("ufo").closeAllFolds()
        require("ufo").openFoldsExceptKinds()
      end, { desc = "Add custom fold (UFO)", silent = true })

      -- Remove all
      s("n", "<leader>zF", function()
        local bufnr = getbuf()
        custom_folds[bufnr] = nil
        require("ufo").closeAllFolds()
        require("ufo").openFoldsExceptKinds()
      end, { desc = "Remove all custom folds (UFO)", silent = true })

      -- Remove under cursor
      s("n", "<leader>zd", function()
        local bufnr = getbuf()
        local linenr = v.fn.line(".") - 1
        local regions = custom_folds[bufnr]
        if regions then
          for i = #regions, 1, -1 do
            local region = regions[i]
            if region[1] <= linenr and linenr <= region[2] then
              table.remove(regions, i)
            end
          end
          if #regions == 0 then
            custom_folds[bufnr] = nil
          end
          require("ufo").closeAllFolds()
          require("ufo").openFoldsExceptKinds()
        end
      end, { desc = "Remove custom fold under cursor (UFO)", silent = true })

      require("ufo").setup({
        fold_virt_text_handler = handler,
        provider_selector = provider_selector,
        open_fold_hl_timeout = 0,
      })

      s("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds with UFO" })
      s("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds with UFO" })
      s("n", "zr", require("ufo").openFoldsExceptKinds, { desc = "Open folds except kinds with UFO" })
      s("n", "zm", require("ufo").closeFoldsWith, { desc = "Close fold with UFO" })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "classic",
      win = {
        height = {
          min = 10,
          max = 20,
        },
        padding = {
          1,
          1,
        },
      },
      layout = {
        width = {
          max = 45,
        },
      },
    },
  },
  {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {
      force_write_shada = true,
      -- Bookmark as wrong
      bookmark_0 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as flagged/important
      bookmark_9 = {
        sign = "⚑",
        annotate = true,
      },
      -- Bookmark as confusing/with a question
      bookmark_8 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as info (useful but not wrong/good/home)
      bookmark_7 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as home (where I'm currently working)
      bookmark_6 = {
        sign = "",
        annotate = true,
      },
      -- Bookmark as known good
      bookmark_5 = {
        sign = "",
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
        delete_bookmark0 = "dm0",
        delete_bookmark9 = "dm9",
        delete_bookmark8 = "dm8",
        delete_bookmark7 = "dm7",
        delete_bookmark6 = "dm6",
        delete_bookmark5 = "dm5",
      },
    },
    keys = {
      k_cmd({
        key = bk .. "a",
        action = "MarksQFListAll",
        desc = "List all marks everywhere",
      }),
      k_cmd({
        key = bk .. "g",
        action = "MarksQFListGlobal",
        desc = "List all global marks",
      }),
      k_cmd({
        key = bk .. "l",
        action = "MarksQFListBuf",
        desc = "List all local marks in loclist",
      }),
      k({
        key = bk .. "G",
        action = ":BookmarksQFList ",
        desc = "List all bookmarks in group <x>",
      }),
      k_cmd({
        key = bk .. "A",
        action = "BookmarksQFListAll",
        desc = "List all bookmarks in all groups",
      }),
    },
  },
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    opts = {},
    keys = {
      k_cmd({
        key = ll .. "a",
        action = a .. "node_action()",
        desc = "Node action",
      }),
      k_cmd({
        key = ll .. "d",
        action = a .. "debug()",
        desc = "Debug node",
      }),
      k_cmd({
        key = ll .. "l",
        action = a .. "available_actions()",
        desc = "List available actions",
      }),
    },
  },
  { "andymass/vim-matchup" },
  { "winston0410/range-highlight.nvim", opts = {} },
  { "godlygeek/tabular", event = "VeryLazy" },
  { "kylechui/nvim-surround", config = true },
  {
    "olimorris/persisted.nvim",
    lazy = false,
    config = true,
    opts = {
      save_dir = v.fn.expand(v.fn.stdpath("data") .. "/sessions/"),
      silent = false,
      use_git_branch = true,
      default_branch = "main",
      -- Preferring to save and load manually since I keep switching branches recklessly
      autosave = false,
      should_autosave = nil,
      autoload = true,
      on_autoload_no_session = nil,
      follow_cwd = true,
      allowed_dirs = nil,
      ignored_dirs = nil,
      ignored_branches = nil,
      telescope = {
        reset_prompt = true,
        mappings = {
          change_branch = "<c-b>",
          copy_session = "<c-c>",
          delete_session = "<c-d>",
        },
        icons = {
          branch = " ",
          dir = " ",
          selected = " ",
        },
      },
    },
    keys = {
      k_cmd({
        key = z .. "s",
        action = "SessionSave",
        desc = "Save session",
      }),
      k_cmd({
        key = z .. "l",
        action = "SessionLoad",
        desc = "Load session",
      }),
      k_cmd({
        key = z .. "d",
        action = "SessionDelete",
        desc = "Delete session",
      }),
      k_cmd({
        key = z .. "a",
        action = "SessionLoadLast",
        desc = "Session load last",
      }),
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>st", false },
      { "<leader>sT", false },
    },
  },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
  },
}
