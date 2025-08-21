return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    config = true,
    opts = {
      rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
    },
  },
  {
    "mistricky/codesnap.nvim",
    cmd = { "CodeSnap", "CodeSnapSave" },
    build = "make build_generator",
    opts = {
      save_path = os.getenv("HOME") .. "/Pictures/screenshots/code",
      has_breadcrumbs = true,
      bg_theme = "bamboo",
    },
    -- TODO: Update these
    keys = {
      { "<leader>zsc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Save selected code snapshot into clipboard" },
      { "<leader>zss", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Save selected code snapshot in ~/Pictures" },
    },
  },
}
