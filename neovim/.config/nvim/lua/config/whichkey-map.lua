local wk = require("which-key")

wk.add({
  --
  -- <Leader>a
  --
  { "<leader>a", group = "What's the A stand for..." },

  --
  -- <Leader>b
  --
  { "<leader>b", group = "Buffers" },
  { "<leader>bh", group = "Horizontal splits" },
  { "<leader>bl", group = "Marks & Bookmarks" },
  { "<leader>bv", group = "New vertical split" },

  --
  -- <Leader>c
  --
  { "<leader>c", group = "Code (LSP)" },
  { "<leader>cl", group = "Code lens" },
  { "<leader>cw", group = "Workspaces" },

  --
  -- <Leader>d
  --
  { "<leader>d", group = "Debugging" },
  { "<leader>D", group = "Databases" },

  --
  -- <Leader>e
  --
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
  -- <Leader>h Http (using Kulala)
  --
  { "<leader>h", group = "HTTP" },

  --
  -- <Leader>g
  --
  { "<leader>g", group = "Git" },
  { "<leader>gd", group = "Diffview" },
  { "<leader>gh", group = "Gitsigns" },
  { "<leader>gn", group = "Neogit" },
  { "<leader>gp", group = "Octo PRs" },
  { "<leader>gc", group = "Octo Comments, Threads, Reactions" },
  { "<leader>gr", group = "Octo Reviews, Assignees" },

  --
  -- Misc
  --
  { "<leader>k", group = "Kubectl and Docker" },
  { "<leader>l", group = "Location list" },
  { "<leader>n", group = "Obsidian" },
  { "<leader>na", group = "Helpers to add notes to AI context" },
  { "<leader>q", group = "Quickfix list" },
  { "<leader>r", group = "Refactoring" },
  { "<leader>p", group = "Revman" },

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
  { "m0", desc = "Investigating" },
  { "m9", desc = "Flagged/important" },
  { "m8", desc = "Bad" },
  { "m7", desc = "Good" },
  { "m6", desc = "Info" },
  { "m5", desc = "Home" },

  { "z=", desc = "Spell Suggestions" },

  --
  -- Previous ([)
  --
  { "[", group = "Previous..." },
  { "[b", desc = "Buffer" },
  { "[h", desc = "Hunk" },
  { "[0", desc = "Investigation bookmark" },
  { "[9", desc = "Flagged/important bookmark" },
  { "[8", desc = "Bad bookmark" },
  { "[7", desc = "Good bookmark" },
  { "[6", desc = "Info bookmark" },
  { "[5", desc = "Home bookmark" },
  { "[B", desc = "First buffer" },
  { "[Q", desc = "First error" },
  { "[T", desc = "Tag" },
  { "[<C-T>", desc = "Preview next tag" },

  --
  -- Next (])
  --
  { "]", group = "Next..." },
  { "]b", desc = "Buffer" },
  { "]h", desc = "Hunk" },
  { "]0", desc = "Investigation bookmark" },
  { "]9", desc = "Flagged/important bookmark" },
  { "]8", desc = "Bad bookmark" },
  { "]7", desc = "Good bookmark" },
  { "]6", desc = "Info bookmark" },
  { "]5", desc = "Home bookmark" },
  { "]B", desc = "Last buffer" },
  { "]Q", desc = "Last error" },
  { "]T", desc = "Tag" },
  { "]<C-T>", desc = "Preview previous tag" },

  --
  -- Ctrl
  --
  { "<C-w>o", desc = "Fullscreen current buffer if in buffer split" },
  { "<C-w>c", desc = "Close split" },
})
