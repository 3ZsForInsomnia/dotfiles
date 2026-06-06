local function parse_apply_to(filepath)
  local lines = vim.fn.readfile(filepath)

  if not lines or lines[1] ~= "---" then
    return nil
  end

  for i = 2, #lines do
    if lines[i] == "---" then
      break
    end

    local pattern = lines[i]:match("^applyTo:%s*(.+)$")
    if pattern then
      return vim.trim(pattern)
    end
  end

  return nil
end


local function normalize_glob(p)
  p = vim.trim(p)

  if p == "**" then
    return "**/*"
  end

  if p:sub(-3) == "/**" then
    return p .. "/*"
  end

  return p
end


local function path_matches(rel, pattern)
  local parts = vim.split(pattern, ",", { plain = true, trimempty = true })
  local positive, negative = {}, {}

  for _, part in ipairs(parts) do
    part = vim.trim(part)
    local is_negative = part:sub(1, 1) == "!"
    local glob = normalize_glob(is_negative and part:sub(2) or part)

    local ok, lpeg = pcall(vim.glob.to_lpeg, glob)
    if ok then
      table.insert(is_negative and negative or positive, lpeg)
    end
  end

  if #positive == 0 then
    return false
  end

  local matched = vim.iter(positive):any(function(lpeg)
    return lpeg:match(rel)
  end)

  if not matched then
    return false
  end

  return not vim.iter(negative):any(function(lpeg)
    return lpeg:match(rel)
  end)
end


local function any_buffer_matches(pattern)
  local root = vim.fs.root(vim.fn.getcwd(), { ".git", ".github" })

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)

      if name ~= "" then
        local rel = root and name:sub(#root + 2) or name

        if path_matches(rel, pattern) then
          return true
        end
      end
    end
  end

  return false
end


local function when_buffer_matches(pattern)
  return function()
    return any_buffer_matches(pattern)
  end
end


local function conditional_rule(description, pattern, files)
  return {
    description = description,
    enabled = when_buffer_matches(pattern),
    files = files,
  }
end


-- Lazily populated on first BufEnter; empty table = scanned but nothing found.
local instruction_map = nil
local instruction_root = nil


local function build_instruction_map(root)
  local dir = root .. "/.github/instructions"
  local files = vim.fn.glob(dir .. "/*.md", false, true)
  local map = {}

  for _, filepath in ipairs(files) do
    local pattern = parse_apply_to(filepath)

    if pattern then
      map[pattern] = filepath
    end
  end

  return map
end


local function setup_instruction_autocmd()
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(event)
      if instruction_map == nil then
        local root = vim.fs.root(event.buf, { ".git" })
        instruction_root = root
        instruction_map = root and build_instruction_map(root) or {}
      end

      if vim.tbl_isempty(instruction_map) then
        return
      end

      local chat = require("codecompanion").last_chat()
      if not chat then
        return
      end

      local bufname = vim.api.nvim_buf_get_name(event.buf)
      if bufname == "" then
        return
      end

      local rel = instruction_root and bufname:sub(#instruction_root + 2) or bufname
      if rel == "" then
        return
      end

      local helpers = require("codecompanion.interactions.chat.helpers")
      local rules_mod = require("codecompanion.interactions.shared.rules")
      local instr_dir = instruction_root .. "/.github/instructions"

      for pattern, filepath in pairs(instruction_map) do
        if path_matches(rel, pattern) then
          local filename = vim.fn.fnamemodify(filepath, ":t")
          local id = "<rules>" .. instr_dir .. "/" .. filename .. "</rules>"

          if not helpers.has_context(id, chat.messages) then
            rules_mod.add_to_chat_from_config(chat, {
              name = "instruction_" .. vim.fn.fnamemodify(filepath, ":t:r"),
              files = { { path = instr_dir, files = { filename } } },
            })
          end
        end
      end
    end,
  })
end


return {
  when_buffer_matches = when_buffer_matches,
  conditional_rule = conditional_rule,
  setup_instruction_autocmd = setup_instruction_autocmd,
}
