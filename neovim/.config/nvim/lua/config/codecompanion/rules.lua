local function parse_apply_to(filepath)
  local lines = vim.fn.readfile(filepath)
  if not lines or lines[1] ~= "---" then return nil end

  for i = 2, #lines do
    if lines[i] == "---" then break end
    local pattern = lines[i]:match("^applyTo:%s*(.+)$")
    if pattern then return vim.trim(pattern) end
  end
  return nil
end

local function any_buffer_matches(pattern)
  local lpeg = vim.glob.to_lpeg(pattern)
  local root = vim.fs.root(vim.fn.getcwd(), { ".git", ".github" })

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        local rel = root and name:sub(#root + 2) or name
        if lpeg:match(rel) then return true end
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

local function build_instruction_rules()
  local root = vim.fs.root(vim.fn.getcwd(), { ".git", ".github" })
  if not root then return {} end

  local dir = root .. "/.github/instructions"
  local files = vim.fn.glob(dir .. "/*.md", false, true)
  local rules = {}

  for _, filepath in ipairs(files) do
    local pattern = parse_apply_to(filepath)
    local name = vim.fn.fnamemodify(filepath, ":t:r")
    local key = "instruction_" .. name

    rules[key] = {
      description = "Instruction: " .. name,
      enabled = pattern and when_buffer_matches(pattern) or nil,
      files = { filepath },
      opts = {
        chat = { autoload = { "default", key }, enabled = true },
      },
    }
  end

  return rules
end

return {
  when_buffer_matches = when_buffer_matches,
  conditional_rule = conditional_rule,
  build_instruction_rules = build_instruction_rules,
}
