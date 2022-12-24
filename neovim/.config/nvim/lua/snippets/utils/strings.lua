local M = {}

M.splitString = function(str)
  local ret = {}
  if string.len(str) == 0 then
    return ret
  end
  if string.find(str, ', ') then
    local i = 0
    for w in string.gmatch(str, '([^, ]+)') do
      print('w is ', w)
      table.insert(ret, w)
      i = i + 1
    end
  else
    table.insert(ret, str)
  end

  return ret
end

return M
