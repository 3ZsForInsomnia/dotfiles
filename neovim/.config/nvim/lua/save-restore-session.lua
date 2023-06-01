local function getSessions()
  local files = {}
  for dir in io.popen([[ls -pa ~/vim-sessions/ | grep .vim]]):lines() do
    table.insert(files, dir)
  end
  return files
end

local function determineIfChangesPresent()
  local filesChanged = io.popen("git status --porcelain=v1 2>/dev/null | wc -l"):read()
  return filesChanged == 0
end

local function getCurrentBranch()
  return io.popen("git branch --show-current"):read()
end

local function getBranches()
  local branches = {}
  for branch in io.popen("git branch"):lines() do
    table.insert(branches, branch)
  end
  return branches
end

local function safeBranchNames(branch)
  local result = string.gsub(branch, "\\", "_")
  result = string.gsub(result, "* ", "")
  result = string.gsub(result, " ", "")

  return result
end

function _G.SaveSession(name)
  vim.cmd("mksession! ~/vim-sessions/" .. tostring(name) .. ".vim")
  vim.cmd("wshada! ~/vim-sessions/" .. tostring(name) .. ".shada")
end

function _G.SaveSessionByName()
  vim.ui.input({ prompt = "Session name", default = "name" }, function(input)
    if input then
      _G.SaveSession(input)
    end
  end)
end

function _G.RestoreSessionByName()
  local files = getSessions()
  for i = 1, #files do
    files[i] = string.gsub(files[i], ".vim", "")
  end
  vim.ui.select(files, { prompt = "Restore Session: " }, function(choice)
    _G.RestoreSession(choice)
  end)
end

function _G.RestoreSession(name)
  vim.cmd("source ~/vim-sessions/" .. name .. ".vim")
  vim.cmd("rshada ~/vim-sessions/" .. name .. ".shada")
end

function _G.DeleteSession(name)
  os.execute("rm -rf ~/vim-sessions/" .. name .. ".*")
end

function _G.DeleteSessionByName()
  local files = getSessions()
  for i = 1, #files do
    files[i] = string.gsub(files[i], ".vim", "")
  end
  vim.ui.select(files, { prompt = "Delete Session: " }, function(choice)
    if choice then
      _G.DeleteSession(choice)
    end
  end)
end

function _G.SaveCurrentBranchSessionAndSwitch()
  local currBranch = getCurrentBranch()
  local sessionName = safeBranchNames(currBranch)
  _G.SaveSession(sessionName)

  vim.ui.select({ "close", "keep" }, {
    "What do you want to do with the existing session?",
    format_item = function(item)
      return string.sub(item, 1, 1):upper() .. string.sub(item, 2) .. " the tabs"
    end,
  }, function(choice)
    if choice == "close" then
      vim.cmd("%bd")
    end
  end)

  local sessions = getSessions()
  local branches = getBranches()
  for i = 1, #branches do
    branches[i] = safeBranchNames(branches[i])
  end

  vim.ui.select(branches, {
    prompt = "Select branch: \nNote: * means this branch is *not* associated with a session yet",
    format_item = function(item)
      for _, session in pairs(sessions) do
        if session == item then
          return item
        end
      end

      return item .. "*"
    end,
  }, function(choice)
    if choice then
      if choice == sessionName then
        return -- If we select the branch we are already on, do nothing
      end
      local changesPresent = determineIfChangesPresent()
      if not changesPresent then
        vim.ui.select({ "commit", "stash", "discard" }, {
          "You have changes in git - what do you want to do with them?",
          format_item = function(item)
            return string.sub(item, 1, 1):upper() .. string.sub(item, 2)
          end,
        }, function(selection)
          if selection == "commit" then
            vim.ui.input({
              prompt = "Commit message:",
              default = "temp commit nvim session: " .. choice,
            }, function(input)
              os.execute('git commit -m "' .. input .. '"')
            end)
          end
          if selection == "stash" then
            vim.ui.input({
              prompt = "Stash name:",
              default = "stash nvim session: " .. choice,
            }, function(input)
              os.execute("git stash push -m " .. input)
            end)
          end
          if selection == "discard" then
            os.execute("git fetch origin; git reset --hard origin/" .. choice)
          end
        end)
      end

      os.execute("git checkout " .. choice)

      for _, session in pairs(sessions) do
        if session == choice then
          _G.RestoreSession(choice)
        end
      end
    end
  end)
end
