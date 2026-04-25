local function wrap_input()
  local snacks_input = require("snacks.input")
  vim.ui.input = function(opts, on_confirm)
    opts = opts or {}
    local prompt = opts.prompt or ""
    -- Strip the prompt from snacks entirely so it doesn't render anywhere
    local snacks_opts = vim.tbl_extend("force", opts, { prompt = "" })
    local win = snacks_input.input(snacks_opts, on_confirm)
    if prompt ~= "" and win and win.buf then
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(win.buf) then
          return
        end
        local lines = vim.split(prompt, "\n", { plain = true })
        -- Insert: [prompt lines, blank separator] before the prompt-buffer's input line
        local insert_lines = {}
        vim.list_extend(insert_lines, lines)
        table.insert(insert_lines, "") -- blank separator
        vim.api.nvim_buf_set_lines(win.buf, 0, 0, false, insert_lines)
        -- Highlight the prompt lines
        local ns = vim.api.nvim_create_namespace("snacks_input_prompt")
        for i = 0, #lines - 1 do
          vim.api.nvim_buf_add_highlight(win.buf, ns, "SnacksInputTitle", i, 0, -1)
        end
        -- Move cursor to the input line (last line)
        local last = vim.api.nvim_buf_line_count(win.buf)
        pcall(vim.api.nvim_win_set_cursor, win.win, { last, 0 })
      end)
    end
    return win
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = wrap_input,
})

local PROMPT_WIDTH_PCT = 0.8 -- fraction of editor width  (0.0 - 1.0)
local PROMPT_ROW_PCT = 0.60 -- fraction from top of editor (0.0 - 1.0)
local PROMPT_MAX_HEIGHT = 10
local PROMPT_MIN_HEIGHT = 3
local PROMPT_BORDER = "rounded"
local PROMPT_TITLE = " Question "
local PROMPT_ZINDEX = 100 -- bump higher if the picker covers it

local function wrap_select()
  local inner = vim.ui.select

  vim.ui.select = function(items, opts, on_choice)
    opts = opts or {}
    local prompt = opts.prompt or ""

    local prompt_buf, prompt_win
    if prompt ~= "" then
      prompt_buf = vim.api.nvim_create_buf(false, true)
      local lines = vim.split(prompt, "\n", { plain = true })
      vim.api.nvim_buf_set_lines(prompt_buf, 0, -1, false, lines)
      vim.bo[prompt_buf].modifiable = false
      vim.bo[prompt_buf].bufhidden = "wipe"

      local width = math.floor(vim.o.columns * PROMPT_WIDTH_PCT)
      local height = math.min(PROMPT_MAX_HEIGHT, math.max(PROMPT_MIN_HEIGHT, #lines + 2))
      prompt_win = vim.api.nvim_open_win(prompt_buf, false, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor(vim.o.lines * PROMPT_ROW_PCT),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = PROMPT_BORDER,
        title = PROMPT_TITLE,
        title_pos = "center",
        zindex = PROMPT_ZINDEX,
      })
      vim.wo[prompt_win].wrap = true
      vim.wo[prompt_win].linebreak = true
      vim.wo[prompt_win].winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder"
    end

    local function close_prompt()
      if prompt_win and vim.api.nvim_win_is_valid(prompt_win) then
        vim.api.nvim_win_close(prompt_win, true)
      end
      prompt_win = nil
    end

    local stub_opts = vim.tbl_extend("force", opts, { prompt = "Choose:" })
    return inner(items, stub_opts, function(choice, idx)
      close_prompt()
      on_choice(choice, idx)
    end)
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = wrap_select,
})

return {
  {
    "folke/snacks.nvim",
    input = {
      enabled = true,
      prompt_pos = false,
      win = {
        relative = "editor",
        position = "float",
        -- row = 0.3,
        -- col = 0.5,
        width = 120,
        height = 10,
        border = "rounded",
        title_pos = "center",
        wo = {
          wrap = true,
          linebreak = true,
        },
      },
      init = function()
        -- Wrap snacks.input so the prompt is rendered as wrapped buffer text
        -- above the input line, not as a (non-wrapping) border title.
        vim.api.nvim_create_autocmd("User", {
          pattern = "SnacksInputOpened",
          callback = function() end,
        })
      end,
    },
  },
}
