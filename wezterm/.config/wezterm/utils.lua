local M = {}

local lpad = function(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

local runShellCommand = function(cmd)
  local handle = io.popen(cmd)
  local result = handle:read("*a")
  handle:close()

  return result
end

function M.getMemoryUsage()
  local result = runShellCommand('memory_pressure')
  local memPercent = string.match(result, 'percentage: (%d+)')
  local memString = 'Mem: ' .. memPercent .. "%"
  return memString
end

function M.getCpuUsage()
  local result = runShellCommand('ps -A -o %cpu | awk \'{s+=$1} END {print s ""}\'')
  local formatted = string.format("%03d", result)
  return "CPU: " .. formatted .. "%"
end

function M.merge_lists(t1, t2, t3)
  local result = {}
  for _, v in pairs(t1) do
    table.insert(result, v)
  end
  for _, v in pairs(t2) do
    table.insert(result, v)
  end
  for _, v in pairs(t3) do
    table.insert(result, v)
  end
  return result
end

M.colors = {
  [0] = '#f09479',
  [1] = '#36c692',
  [2] = '#74b2ff',
  [3] = '#ff5189',
  [4] = '#d183e8',
  [5] = '#de935f',
  [6] = '#00875f',
  [7] = '#80a0ff',
  [8] = '#ae81ff',
}

return M
