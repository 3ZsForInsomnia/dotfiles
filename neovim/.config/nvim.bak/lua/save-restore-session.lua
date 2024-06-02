local function getSessions()
	local files = {}
	for dir in io.popen([[ls -pa ~/vim-sessions/ | grep .vim]]):lines() do
		table.insert(files, dir)
	end
	return files
end

local function areThereChangesPresent()
	local filesChanged = io.popen("git status --porcelain=v1 2>/dev/null | wc -l"):read()
	return filesChanged > 0
end

local function getCurrentBranch()
	return io.popen("git branch --show-current"):read()
end

local function getBranchesAndStashes()
	local branches = {}

	for branch in io.popen("git branch"):lines() do
		local safeName = safeBranchNames(branch)
		table.insert(branches, safeName)
	end

	for stash in io.popen("git stash list"):lines() do
		if string.find(stash, "nvim session: ", 1) then
			local safeName = safeBranchNames(stash)
			table.insert(branches, safeName)
		end
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
	-- vim.cmd("wshada! ~/vim-sessions/" .. tostring(name) .. ".shada")
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
	-- vim.cmd("rshada ~/vim-sessions/" .. name .. ".shada")
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

local function gitStashOrCommit(text, choice)
	vim.ui.input({
		prompt = text .. " message:",
		default = "nvim session: " .. choice,
	}, function(input)
		os.execute("git " .. text .. ' -m "' .. input .. '"')
	end)
end

local function getAndSaveCurrBranch()
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

	return sessionName
end

local function restoreSessionWithGit(sessions, choice)
	if string.find(choice, "nvim session: ", 1) then
		os.execute("git stash apply stash^{/" .. choice .. "}")
	else
		os.execute("git checkout " .. choice)
	end

	for _, session in pairs(sessions) do
		if session == choice then
			_G.RestoreSession(choice)
		end
	end
end

local function handleGitChanges(choice)
	local changesPresent = areThereChangesPresent()
	if changesPresent then
		vim.ui.select({ "commit", "stash", "discard" }, {
			"You have changes in git - what do you want to do with them?",
			format_item = function(item)
				return string.sub(item, 1, 1):upper() .. string.sub(item, 2)
			end,
		}, function(selection)
			if selection == "commit" then
				gitStashOrCommit("commit", choice)
			end
			if selection == "stash" then
				gitStashOrCommit("stash", choice)
			end
			if selection == "discard" then
				os.execute("git fetch origin; git reset --hard origin/" .. choice)
			end
		end)
	end
end

local function formatBranchesBasedOnIfItHasASession(sessions)
	return function(item)
		for _, session in pairs(sessions) do
			if session == item then
				return item
			end
		end

		return item .. "*"
	end
end

function _G.SaveCurrentBranchSessionAndSwitch()
	local sessionName = getAndSaveCurrBranch()

	local sessions = getSessions()
	local branches = getBranchesAndStashes()

	vim.ui.select(branches, {
		prompt = "Select branch: \nNote: * means this branch is *not* associated with a session yet",
		format_item = formatBranchesBasedOnIfItHasASession(sessions),
	}, function(choice)
		if choice then
			if choice == sessionName then
				return -- If we select the branch we are already on, do nothing
			end

			handleGitChanges(choice)

			restoreSessionWithGit(sessions, choice)
		end
	end)
end
