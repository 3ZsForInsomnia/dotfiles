local wk = require("which-key")

wk.add({
  --
  -- <Leader>a
  --
  { "<leader>a", group = "AI Tools" },
  { "<leader>ac", group = "Claude" },
  { "<leader>ag", group = "GPT" },
  { "<leader>agr", group = "Run action..." },
  { "<leader>ap", group = "Copilot" },

  --
  -- <Leader>b
  --
  { "<leader>b", group = "Buffers" },
  { "<leader>bh", group = "Horizontal splits" },
  { "<leader>bv", group = "New vertical split" },

  --
  -- <Leader>c
  --
  { "<leader>c", group = "Code (LSP)" },
  { "<leader>cl", group = "Code lens" },
  { "<leader>cw", group = "Workspaces" },

  { "<leader>d", group = "Debug & Dbs" },
  { "<leader>e", group = "Explorer (Neotree)" },

  --
  -- <Leader>f Telescope
  --
  { "<leader>f", group = "Telescope" },
  { "<leader>fb", group = "Buffers, marks, registers and tags" },
  { "<leader>fc", group = "Changes, quick and location lists" },
  { "<leader>fd", group = "Docs and snippets" },
  { "<leader>fg", group = "Git" },
  { "<leader>fl", group = "LSP" },
  { "<leader>fm", group = "Misc" },

  --
  -- <Leader>g
  --
  { "<leader>g", group = "Git" },
  { "<leader>gd", group = "Diffview" },
  { "<leader>gh", group = "Gitsigns" },
  { "<leader>gn", group = "Neogit" },

  { "<leader>l", group = "Location list" },
  { "<leader>o", group = "Obsidian" },
  { "<leader>q", group = "Quickfix list" },
  { "<leader>r", group = "Refactoring" },

  --
  -- <Leader>s
  --
  { "<leader>s", group = "Sessions and Custom Surrounds" },
  { "<leader>sw", group = "Swap params" },

  --
  -- <Leader>s Surrounds
  --
  { '<leader>s"', desc = "Surround with '\"'" },
  { "<leader>s'", desc = "Surround with '" },
  { "<leader>s`", desc = "Surround with `" },
  { "<leader>s(", desc = "Surround with ()" },
  { "<leader>s{", desc = "Surround with {}" },
  { "<leader>s[", desc = "Surround with []" },
  { "<leader>s<", desc = "Surround with <>" },
  { "<leader>s$", desc = "Surround with ${}" },

  { "<leader>t", group = "Testing" },
  { "<leader>u", group = "UI toggles" },
  { "<leader>ut", group = "Neovim Feature Toggles" },
  { "<leader>x", group = "Trouble Diagnostics" },
  { "<leader>z", group = "Misc" },
  { "<leader>zc", group = "Colortils" },
  { "<leader>ze", group = "Emmet" },

  --
  -- Marks (m)
  --
  { "m", group = "Marks" },
  { "<leader>m0", desc = "Investigating" },
  { "<leader>m9", desc = "Flagged/important" },
  { "<leader>m8", desc = "Bad" },
  { "<leader>m7", desc = "Good" },
  { "<leader>m6", desc = "Info" },
  { "<leader>m5", desc = "Home" },

  --
  -- Previous ([)
  --
  { "<leader>[", group = "Previous..." },
  { "<leader>[b", desc = "Buffer" },
  { "<leader>[h", desc = "Hunk" },
  { "<leader>[0", desc = "Investigation bookmark" },
  { "<leader>[9", desc = "Flagged/important bookmark" },
  { "<leader>[8", desc = "Bad bookmark" },
  { "<leader>[7", desc = "Good bookmark" },
  { "<leader>[6", desc = "Info bookmark" },
  { "<leader>[5", desc = "Home bookmark" },

  --
  -- Next (])
  --
  { "<leader>]", group = "Next..." },
  { "<leader>]b", desc = "Buffer" },
  { "<leader>]h", desc = "Hunk" },
  { "<leader>]0", desc = "Investigation bookmark" },
  { "<leader>]9", desc = "Flagged/important bookmark" },
  { "<leader>]8", desc = "Bad bookmark" },
  { "<leader>]7", desc = "Good bookmark" },
  { "<leader>]6", desc = "Info bookmark" },
  { "<leader>]5", desc = "Home bookmark" },

  --
  -- Ctrl
  --
  { "<C-w>o", desc = "Fullscreen current buffer if in buffer split" },
  { "<C-w>c", desc = "Close split" },
  { "<C-k>", desc = "Show signature" },
})
