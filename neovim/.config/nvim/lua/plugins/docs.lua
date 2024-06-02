return {
  { "sunaku/vim-dasht", event = "VeryLazy" },
  {
    "luckasRanarison/nvim-devdocs",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      filetypes = {
        scss = "sass",
        javascript = { "node", "react", "javascript", "tailwind" },
        typescript = { "node", "javascript", "react", "typescript", "tailwind" },
        css = { "tailwind", "css" },
      },
      previewer_cmd = "glow",
    },
  },
}
