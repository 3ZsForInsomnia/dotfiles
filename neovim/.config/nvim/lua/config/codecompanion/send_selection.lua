-- Send the visual selection to the last CodeCompanion chat as a fenced code
-- block, headed by its file path and line range (`src/foo.ts:42-58`).
local M = {}

-- Octo diff buffers: octo://<owner>/<repo>/review/<id>/file/<LEFT|RIGHT>/<path>
local OCTO_REVIEW_FILE = "^octo://.-/review/[^/]+/file/(%u+)/(.+)$"
local OCTO_BASE_SIDE = "LEFT"
local MIN_FENCE_LENGTH = 3

local function selected_lines()
  local start_pos, end_pos = vim.fn.getpos("v"), vim.fn.getpos(".")
  local lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.mode() })
  local first, last = start_pos[2], end_pos[2]

  return lines, math.min(first, last), math.max(first, last)
end

local function source_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  local side, octo_path = name:match(OCTO_REVIEW_FILE)

  if octo_path then
    return octo_path, side == OCTO_BASE_SIDE
  end

  return name ~= "" and vim.fn.fnamemodify(name, ":~:.") or nil, false
end

local function language(bufnr, path)
  local filetype = vim.bo[bufnr].filetype
  local is_real_filetype = filetype ~= "" and not vim.startswith(filetype, "octo")

  return is_real_filetype and filetype or (path and vim.filetype.match({ filename = path })) or ""
end

local function location(path, is_base_side, first, last)
  local range = first == last and tostring(first) or first .. "-" .. last
  local side_note = is_base_side and " (base version)" or ""

  local unnamed_label = first == last and "Line" or "Lines"

  return path and string.format("`%s:%s`%s", path, range, side_note) or string.format("%s %s:", unnamed_label, range)
end

local function fence(content, lang)
  local longest_backtick_run = 0
  for backticks in content:gmatch("`+") do
    longest_backtick_run = math.max(longest_backtick_run, #backticks)
  end
  local marker = string.rep("`", math.max(MIN_FENCE_LENGTH, longest_backtick_run + 1))

  return string.format("%s%s\n%s\n%s", marker, lang, content, marker)
end

local function last_or_new_chat()
  local codecompanion = require("codecompanion")

  return codecompanion.last_chat() or codecompanion.chat({ stop_context_insertion = true })
end

M.send_selection = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines, first, last = selected_lines()
  local path, is_base_side = source_path(bufnr)
  local content = table.concat(lines, "\n")
  local message = location(path, is_base_side, first, last) .. "\n" .. fence(content, language(bufnr, path)) .. "\n"

  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)

  local chat = last_or_new_chat()
  if not chat then
    return vim.notify("Could not open a CodeCompanion chat", vim.log.levels.WARN)
  end

  chat:add_buf_message({ role = require("codecompanion.config").constants.USER_ROLE, content = message })
  chat.ui:open()
end

return M
