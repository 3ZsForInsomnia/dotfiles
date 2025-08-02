local M = {}

local function is_ignored(path, ignore_list)
  for _, pat in ipairs(ignore_list) do
    if path:find(pat) then
      return true
    end
  end
  return false
end

local ignore_list = {
  ".git",
  "node_modules",
  "venv",
}

function M.recent_notes_to_quickfix_list(days, target_dir)
  days = tonumber(days) or 7
  target_dir = target_dir or vim.fn.getcwd()
  local current_time = os.time()
  local results = {}

  local fd_cmd =
    string.format('fd -t f -e md . "%s" 2>/dev/null || find "%s" -type f -name "*.md"', target_dir, target_dir)
  local handle = io.popen(fd_cmd)
  if not handle then
    return
  end

  for file in handle:lines() do
    if not is_ignored(file, ignore_list) then
      local stat = vim.loop.fs_stat(file)
      if stat and stat.mtime then
        local age_days = (current_time - stat.mtime.sec) / (60 * 60 * 24)
        if age_days <= days then
          table.insert(results, {
            filename = file,
          })
        end
      end
    end
  end
  handle:close()

  if #results > 0 then
    vim.fn.setqflist(results, "r")
    vim.cmd("copen")
    print(("Found %d markdown files modified within last %d days."):format(#results, days))
  else
    print("No markdown files modified within the specified window!")
  end
end

M.save_open_buffers = function()
  vim.g._pre_quickfix_buffers = vim.tbl_map(
    function(buf)
      return vim.api.nvim_buf_get_name(buf)
    end,
    vim.tbl_filter(function(buf)
      return vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
    end, vim.api.nvim_list_bufs())
  )
end

-- Step 3: Close buffers not in the original list
M.close_new_quickfix_buffers = function()
  local before = vim.g._pre_quickfix_buffers or {}
  local before_set = {}
  for _, name in ipairs(before) do
    before_set[name] = true
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and not before_set[name] then
        vim.api.nvim_buf_delete(buf, { force = true })
        print("Closed buffer: " .. name)
      end
    end
  end
  print("Closed all new quickfix buffers.")
end

function M.setup()
  vim.api.nvim_create_user_command("RecentNotesToQuickFixList", function(opts)
    M.save_open_buffers()
    print("Running RecentNotesToQuickFixList with args: " .. vim.inspect(opts.fargs))
    M.recent_notes_to_quickfix_list(opts.fargs[1], opts.fargs[2])
    vim.cmd("cfdo edit")
  end, {
    desc = "Find recently edited markdown files in folder (and put in quickfix)",
    nargs = "*",
    complete = "file",
  })
  vim.api.nvim_create_user_command("CloseNewQuickFixBuffers", function()
    M.close_new_quickfix_buffers()
  end, {
    desc = "Close buffers that were not in the saved list",
  })
end

return M
