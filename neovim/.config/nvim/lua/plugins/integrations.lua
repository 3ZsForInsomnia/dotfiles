local keys = require("helpers")
local cmd = keys.k_cmd
local k = keys.k
local o = "<leader>o"

return {
  {
    "epwalsh/obsidian.nvim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })
    end,
    opts = {
      dir = "~/Documents/notes",
      open_notes_in = "current",
      finder = "telescope.nvim",
      completion = {
        nvim_cmp = true,
        prepend_note_id = true,
      },
      note_id_func = function(title)
        return title
      end,
      disable_frontmatter = false,
      templates = {
        subdir = "9 - Resources/90 - Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      follow_url_func = function(url)
        -- vim.fn.jobstart({ "cmd.exe /C start", url }) -- Linux in WSL
        -- vim.fn.jobstart({ "open", url }) -- Mac OS
        vim.fn.jobstart({ "xdg-open", url }) -- linux
      end,
      open_app_foreground = true,
      daily_notes = {
        folder = "",
        date_format = "%Y-%m-%d",
      },
    },
    keys = {
      cmd({
        key = o .. "t",
        action = "ObsidianToday",
        desc = "Today's note",
      }),
      k({
        key = o .. "n",
        action = ":ObsidianNew ",
        desc = "Create a new note",
      }),
      cmd({
        key = o .. "q",
        action = "ObsidianQuickSwitch",
        desc = "Open quick switch",
      }),
      cmd({
        key = o .. "i",
        action = "ObsidianTemplate",
        desc = "Insert template",
      }),
      cmd({
        key = o .. "l",
        action = "ObsidianLink",
        desc = "Insert link",
      }),
      cmd({
        key = o .. "f",
        action = "ObsidianFollowLink",
        desc = "Follow link",
      }),
      cmd({
        key = o .. "o",
        action = "ObsidianOpen",
        desc = "Open note in buffer in Obsidian app",
      }),
      cmd({
        key = o .. "s",
        action = "ObsidianSearch",
        desc = "Search notes",
      }),
      k({
        key = o .. "e",
        action = ":ObsidianExtractNote ",
        desc = "Extract visual selection to a new note",
      }),
      cmd({
        key = o .. "r",
        action = "ObsidianRename",
        desc = "Rename note",
      }),
      k({
        key = o .. "p",
        action = ":ObsidianPasteImg ",
        desc = "Paste image from clipboard with name",
      }),
    },
  },
}
