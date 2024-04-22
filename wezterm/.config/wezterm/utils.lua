local M = {}

M.shortenPath = function(cwd)
	print("cwd", cwd)
	-- cwd = string.gsub(cwd, '%20', '')
	-- cwd = string.gsub(cwd, '/Users/zachary/', '')
	-- cwd = string.gsub(cwd, '/Users/zachary', 'Home')
	cwd = string.gsub(cwd, "/home/zach", "")
	cwd = string.gsub(cwd, "/home/zach", "Home")
	cwd = string.gsub(cwd, "code/", "")
	cwd = string.gsub(cwd, ".config", ".c")
	cwd = string.gsub(cwd, "neovim", "nv")
	cwd = string.gsub(cwd, "wezterm", "wez", 1)
	cwd = string.gsub(cwd, "hedgineer", "Work", 1)
	cwd = string.gsub(cwd, "frontend", "fe", 1)
	cwd = string.gsub(cwd, "backend", "be", 1)
	cwd = string.gsub(cwd, "schemas", "data", 1)

	cwd = string.sub(cwd, 1, 1):upper() .. string.sub(cwd, 2, -1)
	return cwd
end

local readFile = function(file)
	local handle = io.open(file, "r")
	local data = handle:read("*a")
	handle:close()

	return data
end

local runShellCommand = function(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()

	return result
end

function M.getMemoryUsage()
	local result = runShellCommand("memory_pressure")
	local memPercent = string.match(result, "percentage: (%d+)")
	local memString = "Mem: " .. memPercent .. "%"
	return memString
end

function M.getCpuUsage()
	local result = runShellCommand("ps -A -o %cpu | awk '{s+=$1} END {print s \"\"}'")
	result = math.floor(result)
	local formatted = string.format("%03d", result)
	return "CPU: " .. formatted .. "%"
end

function M.getWeather()
	local weather = readFile("/Users/zachary/.local/state/weather/currentWeather.txt")
	weather = string.gsub(weather, "\n", "")
	return weather
end

function M.getNextEvent()
	local event = readFile("/Users/zachary/.local/state/cal/nextEvent.txt")
	event = string.gsub(event, "\n", "")
	print("event: ", event)
	return event .. "  "
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
	[0] = "#f09479",
	[1] = "#36c692",
	[2] = "#74b2ff",
	[3] = "#ff5189",
	[4] = "#d183e8",
	[5] = "#de935f",
	[6] = "#00875f",
	[7] = "#80a0ff",
	[8] = "#ae81ff",
}

return M
