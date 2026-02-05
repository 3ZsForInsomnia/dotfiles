local v = vim

local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")
local swap = require("nvim-treesitter-textobjects.swap")

local k = require("helpers").k
local treesitter = v.treesitter
local l = "<leader>l"

k({
  mode = "n",
  key = "gnn",
  desc = "TS: Init selection",
  action = function()
    treesitter.incremental_selection.init_selection()
  end,
})

k({
  mode = "n",
  key = "grn",
  desc = "TS: Node incremental",
  action = function()
    treesitter.incremental_selection.node_incremental()
  end,
})

k({
  mode = "n",
  key = "grc",
  desc = "TS: Scope incremental",
  action = function()
    treesitter.incremental_selection.scope_incremental()
  end,
})

k({
  mode = "n",
  key = "grm",
  desc = "TS: Node decremental",
  action = function()
    treesitter.incremental_selection.node_decremental()
  end,
})

k({
  mode = "n",
  key = l .. "le",
  desc = "Open floating diagnostics window",
  action = function()
    v.diagnostic.open_float()
  end,
})

-- SELECT textobjects: work in visual and operator-pending
k({
  mode = { "x", "o" },
  key = "af",
  desc = "TS textobj: function outer",
  action = function()
    select.select_textobject("@function.outer", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "if",
  desc = "TS textobj: function inner",
  action = function()
    select.select_textobject("@function.inner", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "aa",
  desc = "TS textobj: call outer",
  action = function()
    select.select_textobject("@call.outer", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "ia",
  desc = "TS textobj: call inner",
  action = function()
    select.select_textobject("@call.inner", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "ac",
  desc = "TS textobj: class outer",
  action = function()
    select.select_textobject("@class.outer", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "ic",
  desc = "TS textobj: class inner",
  action = function()
    select.select_textobject("@class.inner", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "al",
  desc = "TS textobj: loop outer",
  action = function()
    select.select_textobject("@loop.outer", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "il",
  desc = "TS textobj: loop inner",
  action = function()
    select.select_textobject("@loop.inner", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "ai",
  desc = "TS textobj: conditional outer",
  action = function()
    select.select_textobject("@conditional.outer", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "ii",
  desc = "TS textobj: conditional inner",
  action = function()
    select.select_textobject("@conditional.inner", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "ao",
  desc = "TS textobj: block outer",
  action = function()
    select.select_textobject("@block.outer", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "io",
  desc = "TS textobj: block inner",
  action = function()
    select.select_textobject("@block.inner", "textobjects")
  end,
})

k({
  mode = { "x", "o" },
  key = "am",
  desc = "TS textobj: comment inner",
  action = function()
    select.select_textobject("@comment.inner", "textobjects")
  end,
})

-- MOVE: work in normal, visual, and operator-pending
k({
  mode = { "n", "x", "o" },
  key = "[F",
  desc = "TS move: next function start",
  action = function()
    move.goto_next_start("@function.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[C",
  desc = "TS move: next class start",
  action = function()
    move.goto_next_start("@class.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[A",
  desc = "TS move: next call start",
  action = function()
    move.goto_next_start("@call.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[O",
  desc = "TS move: next block start",
  action = function()
    move.goto_next_start("@block.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[I",
  desc = "TS move: next conditional start",
  action = function()
    move.goto_next_start("@conditional.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[L",
  desc = "TS move: next loop start",
  action = function()
    move.goto_next_start("@loop.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]f",
  desc = "TS move: next function end",
  action = function()
    move.goto_next_end("@function.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]c",
  desc = "TS move: next class end",
  action = function()
    move.goto_next_end("@class.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]a",
  desc = "TS move: next call end",
  action = function()
    move.goto_next_end("@call.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]o",
  desc = "TS move: next block end",
  action = function()
    move.goto_next_end("@block.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]i",
  desc = "TS move: next conditional end",
  action = function()
    move.goto_next_end("@conditional.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]l",
  desc = "TS move: next loop end",
  action = function()
    move.goto_next_end("@loop.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[f",
  desc = "TS move: previous function start",
  action = function()
    move.goto_previous_start("@function.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[c",
  desc = "TS move: previous class start",
  action = function()
    move.goto_previous_start("@class.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[a",
  desc = "TS move: previous call start",
  action = function()
    move.goto_previous_start("@call.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[o",
  desc = "TS move: previous block start",
  action = function()
    move.goto_previous_start("@block.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[i",
  desc = "TS move: previous conditional start",
  action = function()
    move.goto_previous_start("@conditional.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "[l",
  desc = "TS move: previous loop start",
  action = function()
    move.goto_previous_start("@loop.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]F",
  desc = "TS move: previous function end",
  action = function()
    move.goto_previous_end("@function.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]C",
  desc = "TS move: previous class end",
  action = function()
    move.goto_previous_end("@class.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]A",
  desc = "TS move: previous call end",
  action = function()
    move.goto_previous_end("@call.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]O",
  desc = "TS move: previous block end",
  action = function()
    move.goto_previous_end("@block.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]I",
  desc = "TS move: previous conditional end",
  action = function()
    move.goto_previous_end("@conditional.outer", "textobjects")
  end,
})

k({
  mode = { "n", "x", "o" },
  key = "]L",
  desc = "TS move: previous loop end",
  action = function()
    move.goto_previous_end("@loop.outer", "textobjects")
  end,
})

-- SWAP: normal-mode editing commands
k({
  mode = "n",
  key = "<leader>swp",
  desc = "TS swap: next parameter",
  action = function()
    swap.swap_next("@parameter.inner", "textobjects")
  end,
})

k({
  mode = "n",
  key = "<leader>swP",
  desc = "TS swap: previous parameter",
  action = function()
    swap.swap_previous("@parameter.inner", "textobjects")
  end,
})
