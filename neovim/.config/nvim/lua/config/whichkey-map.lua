local wk = require("which-key")

wk.register({
  ["<leader>"] = {
    name = "Leader",
    a = {
      name = "AI tools",
      c = {
        name = "Copilot",
      },
      g = {
        name = "GPT",
        r = {
          name = "Run action...",
        },
      },
    },
    b = {
      name = "Buffers",
      h = {
        name = "Horizontal splits",
      },
      v = {
        name = "New vertical split",
      },
    },
    c = {
      name = "Code (LSP)",
      l = {
        name = "Code lens",
      },
      w = {
        name = "Workspaces",
      },
    },
    d = {
      name = "Debug & Dbs",
    },
    e = {
      name = "Explorer (Neotree)",
    },
    f = {
      name = "Telescope",
      b = {
        name = "Buffers, marks, registers and tags",
      },
      c = {
        name = "Changes, quick and location lists",
      },
      d = {
        name = "Docs and snippets",
      },
      g = {
        name = "Git",
      },
      l = {
        name = "LSP",
      },
      m = {
        name = "Misc",
      },
    },
    g = {
      name = "Git",
      d = {
        name = "Diffview",
      },
      h = {
        name = "Gitsigns",
      },
      n = {
        name = "Neogit",
      },
    },
    l = {
      name = "Location list",
    },
    o = {
      name = "Obsidian",
    },
    q = {
      name = "Quickfix list",
    },
    r = {
      name = "Refactoring",
    },
    s = {
      name = "Sessions and Custom Surrounds",
      ['"'] = "Surround with '\"'",
      ["'"] = "Surround with '",
      ["`"] = "Surround with `",
      ["("] = "Surround with ()",
      ["{"] = "Surround with {}",
      ["["] = "Surround with []",
      ["<"] = "Surround with <>",
      ["$"] = "Surround with ${}",
      w = {
        name = "Swap params",
      },
    },
    t = {
      name = "Testing",
    },
    u = {
      name = "UI toggles",
    },
    x = {
      name = "Trouble Diagnostics",
    },
    z = {
      name = "Misc",
      c = {
        name = "Colortils",
      },
      e = {
        name = "Emmet",
      },
    },
  },
  m = {
    name = "Marks",
    ["0"] = "Investigating",
    ["9"] = "Flagged/important",
    ["8"] = "Bad",
    ["7"] = "Good",
    ["6"] = "Info",
    ["5"] = "Home",
  },
  ["["] = {
    name = "Previous...",
    b = "Buffer",
    h = "Hunk",
    ["0"] = "Investigation bookmark",
    ["9"] = "Flagged/important bookmark",
    ["8"] = "Bad bookmark",
    ["7"] = "Good bookmark",
    ["6"] = "Info bookmark",
    ["5"] = "Home bookmark",
  },
  ["]"] = {
    name = "Next...",
    b = "Buffer",
    h = "Hunk",
    ["0"] = "Investigation bookmark",
    ["9"] = "Flagged/important bookmark",
    ["8"] = "Bad bookmark",
    ["7"] = "Good bookmark",
    ["6"] = "Info bookmark",
    ["5"] = "Home bookmark",
  },
  ["<C-"] = {
    ["w>o"] = "Fullscreen current buffer if in buffer split",
    ["w>c"] = "Close split",
    ["k>"] = "Show signature",
  },
})
