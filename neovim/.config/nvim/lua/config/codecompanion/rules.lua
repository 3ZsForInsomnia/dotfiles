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


return {
  when_buffer_matches = when_buffer_matches,
  conditional_rule = conditional_rule,
}
