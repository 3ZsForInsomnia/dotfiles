local M = {}

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
