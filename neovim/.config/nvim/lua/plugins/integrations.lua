local keys = require("helpers")
local cmd = keys.k_cmd
local k = keys.k
local o = "<leader>n"

local daily_notes_folder = function()
  local parent_folder = "9 - Resources/94 - Old activity notes"
  local year = os.date("%Y")
  local quarter = "Q" .. math.ceil(tonumber(os.date("%m")) / 3)
  local month = os.date("%m")
  local month_name = os.date("%b")

  local quarterString = year .. "-" .. quarter
  local monthString = year .. "-" .. month .. "-" .. month_name

  return parent_folder .. "/" .. year .. "/" .. quarterString .. "/" .. monthString .. "/"
end

return {
  {
    "epwalsh/obsidian.nvim",
    event = "VeryLazy",
    config = function(_, opts)
      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })

      require("obsidian").setup(opts)
    end,
    opts = {
      dir = "~/Documents/notes",
      workspaces = { {
        name = "notes",
        path = "/home/zach/Documents/notes",
      } },
      open_notes_in = "current",
      finder = "telescope.nvim",
      completion = {
        nvim_cmp = true,
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
      attachments = {
        img_folder = "9 - Resources/98 - Attachments",
      },
      follow_url_func = function(url)
        -- vim.fn.jobstart({ "cmd.exe /C start", url }) -- Linux in WSL
        -- vim.fn.jobstart({ "open", url }) -- Mac OS
        vim.fn.jobstart({ "xdg-open", url }) -- linux
      end,
      open_app_foreground = true,
      daily_notes = {
        folder = daily_notes_folder(),
        date_format = "%Y-%m-%d-%A",
        template = "Daily Note.md",
      },
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,
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
