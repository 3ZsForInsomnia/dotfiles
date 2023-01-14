function _G.SaveSession(name)
  vim.cmd('mksession! ~/vim-sessions/' .. tostring(name) .. '.vim')
  vim.cmd('wshada! ~/vim-sessions/' .. tostring(name) .. '.shada')
end

function _G.SaveSessionByName()
  vim.ui.input({
    prompt = "Session name",
    default = "name",
  },
    function(input)
      if input then
        _G.SaveSession(input)
      end
    end
  )
end

function _G.RestoreSessionByName()
  local files = {}
  for dir in io.popen([[ls -pa ~/vim-sessions/ | grep .vim]]):lines() do table.insert(files, dir) end
  for i = 1, #files do files[i] = string.gsub(files[i], '.vim', '') end
  vim.ui.select(
    files,
    { prompt = 'Restore Session: ' },
    function(choice) _G.RestoreSession(choice) end
  )
end

function _G.RestoreSession(name)
  vim.cmd('source ~/vim-sessions/' .. name .. '.vim')
  vim.cmd('rshada ~/vim-sessions/' .. name .. '.shada')
end

function _G.DeleteSession(name)
  os.execute("rm -rf ~/vim-sessions/" .. name .. ".*")
end

function _G.DeleteSessionByName()
  local files = {}
  for dir in io.popen([[ls -pa ~/vim-sessions/ | grep .vim]]):lines() do table.insert(files, dir) end
  for i = 1, #files do files[i] = string.gsub(files[i], '.vim', '') end
  vim.ui.select(
    files,
    { prompt = 'Delete Session: ' },
    function(choice)
      if choice then
        _G.DeleteSession(choice)
      end
    end
  )
end
