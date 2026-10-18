---
paths:
  - "**/*.lua"
---

# Lua

- Keep everything `local`. Globals should be rare and deliberate. Modules build a local table (`local M = {}`) and return it.
- Wrap calls that can legitimately fail (`require` of an optional module, external commands, parsing) in `pcall`, and report failures with `vim.notify` at the right `vim.log.levels` level. Never swallow the error.
- Keep slow work off Neovim's main loop so the editor never blocks: run external commands with `vim.system` and an `on_exit` callback rather than `vim.fn.system` or `:wait()`, and use `vim.uv` for file and timer work. Callbacks run in a context where most of the API is off-limits, so wrap anything touching buffers, windows, or the UI in `vim.schedule`.
- In Zach's Neovim config, define keymaps with the helpers from `lua/helpers.lua`, not `vim.keymap.set` directly: `require("helpers").k` for Lua functions and raw key sequences, and `require("helpers").k_cmd` (usually imported as `cmd`) for Ex commands, which it wraps in `<cmd>…<cr>`.
