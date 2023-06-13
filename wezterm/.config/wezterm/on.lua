local wezterm = require("wezterm")
local mux = wezterm.mux
local utils = require("utils")

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

local getProjectPath = function(pane)
  local cwd = ''
  local hostname = ''
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8)
    local slash = cwd_uri:find '/'
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find '[.]'
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end
      -- and extract the cwd from the uri
      cwd = cwd_uri:sub(slash)
    end
  end

  cwd = utils.shortenPath(cwd)

  return cwd, hostname
end

local createStatusRight = function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  local cwd, hostname = getProjectPath(pane)
  table.insert(cells, ' ' .. cwd)
  table.insert(cells, hostname)
  table.insert(cells, pane:get_domain_name())
  local mode, n = string.gsub(pane:get_title(), "(.+) mode: .*", "%1", 1)
  if mode == nil or n == 0 then
    mode = 'Normal'
  end
  table.insert(cells, "Mode: " .. (window:active_key_table() or mode))

  local mem = utils.getMemoryUsage()
  table.insert(cells, mem)
  local cpu = utils.getCpuUsage()
  table.insert(cells, cpu)

  utils.setupWeatherRequests()
  table.insert(cells, utils.weather)

  -- Color palette for the backgrounds of each cell
  local colors = {
    "#330723",
    "#3F0936",
    "#480C4B",
    "#440F56",
    "#3c1361",
    "#514182",
    "#6F71A3",
    "#9EA9C2",
    "#CED9E1",
  }

  -- Foreground color for the text across the fade
  local text_fg = '#c0c0c0'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end

wezterm.on('update-status', function(window, pane)
  window:set_right_status(createStatusRight(window, pane))
end)

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = getProjectPath(mux.get_pane(tab.active_pane.pane_id))

  -- Doesn't seem to affect tab name in tab navigator :(
  mux.get_tab(tab.tab_id):set_title(title)

  local bg = '#080808'
  local fg = '#c6c6c6'

  if tab.tab_index < 9 then
    fg = utils.colors[tab.tab_index]
  end

  if tab.is_active then
    return {
      { Background = { Color = bg } },
      { Foreground = { Color = fg } },
      -- { Text = SOLID_LEFT_ARROW .. "   " .. pane_title .. "   " .. SOLID_RIGHT_ARROW },
      { Text = SOLID_LEFT_ARROW .. "   " .. title .. "   " .. SOLID_RIGHT_ARROW },
    }
  end

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    -- { Text = "   " .. pane_title .. "   " },
    { Text = "   " .. title .. "   " },
  }
end)

return {}
