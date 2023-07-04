local M = {}

function M.setup()
  local opts = {
    -- dir = "/mnt/c/Users/comra/code/notes",
    dir = "~/code/notes",
    completion = { nvim_cmp = true },
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
      vim.fn.jobstart({ "cmd.exe /C start", url }) -- Linux in WSL
      -- vim.fn.jobstart({"open", url})  -- Mac OS
      -- vim.fn.jobstart({"xdg-open", url})  -- linux
    end,
    open_app_foreground = true,
  }

  require("obsidian").setup(opts)

  vim.keymap.set("n", "gf", function()
    if require("obsidian").util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end, { noremap = false, expr = true })
end

return M
