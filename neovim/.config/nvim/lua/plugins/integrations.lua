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
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,
      open_app_foreground = true,
      daily_notes = {
        folder = "",
        date_format = "%Y-%m-%d",
      },
    }
  }
}
