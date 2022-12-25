local M = {}

M.capitalizeFirstChar = function(str)
  return str:gsub("^%l", string.upper)
end

M.lowerFirstChar = function(str)
  return str:gsub("^%l", string.lower)
end

M.camelToSnake = function(str)
  return string.gsub(str, '%u', '_%1'):lower()
end

M.getStringPart = function(args, _, user_args1, user_args2)
  local delimiter = user_args1 or '.'
  local text = args[1][1] or ""
  local split = vim.split(text, delimiter, { plain = true })
  local partNumber = user_args2 or #split
  return split[partNumber]
end

return M
