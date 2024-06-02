local sqlite = require "sqlite.db"
local tbl = require "sqlite.tbl"
local notify = require("notify")

local pomos = tbl("pomos", {
  id = true,
  name = "text",
  description = "text",
  started_at = "date",
  duration_set = "number",
  duration_used = "number",
  project = "text",
})

local buffer_to_string = function(buffer)
  return vim.api.nvim_buf_get_lines(buffer, 0, vim.api.nvim_buf_line_count(0), false)
end

local ms = function(numberOfMinutes)
  return numberOfMinutes * 60 * 1000
end

local Pomo = {}

Pomo.config = require('pomo.config')

Pomo.db = sqlite {
  uri = Pomo.config.logDb,
  pomos = pomos,
}

Pomo.tmpBufferName = '/tmp/temp-pomo-buffer'
Pomo.buffer = -1
Pomo.curr = {}

Pomo.levels = {
  vim.log.levels.DEBUG,
  vim.log.levels.WARN,
  vim.log.levels.ERROR,
}
Pomo.timers = {}

Pomo.initialize = function()
  table.insert(Pomo.config.projects, 'None')
  table.insert(Pomo.config.defaultPomoLengths, 'Custom')
end

Pomo.openPomoBuffer = function()
  os.execute('rm -rf /private/tmp/temp-pomo-buffer')
  vim.api.nvim_command('e ' .. Pomo.tmpBufferName)
  for k in ipairs(vim.api.nvim_list_bufs()) do
    if string.find(vim.fn.bufname(k), 'temp%-pomo') then
      Pomo.buffer = tonumber(k)
    end
  end

  vim.api.nvim_create_augroup('PomoOnSaveAndClose', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = "PomoOnSaveAndClose",
    pattern = 'temp-pomo-buffer',
    callback = function()
      Pomo.curr.name = buffer_to_string(0)[1]
      Pomo.startPomo()
    end
  })

  vim.api.nvim_create_autocmd('BufDelete', {
    group = "PomoOnSaveAndClose",
    pattern = 'temp-pomo-buffer',
    callback = function() Pomo.onFinish() end,
  })
end

Pomo.retrieveTimeTaken = function()
  local currTime = os.time()
  local diff = currTime - Pomo.curr.started_at
  local diffInMinutes = (diff / 1000) / 60

  Pomo.curr.duration_used = diffInMinutes
end

Pomo.notify = function(timeRemaining, level)
  if level == nil or level == '' then level = vim.log.levels.DEBUG end
  local message = Pomo.curr.name .. ' has ' .. timeRemaining .. ' minutes left'
  notify(message, level)
  os.execute('say ' .. message)
  os.execute(
    'terminal-notifier -title "' .. Pomo.curr.name ..
    '" -message "Pomo has ' .. timeRemaining .. ' minutes left"'
  )
end

Pomo.startTimers = function()
  notify('Starting ' .. Pomo.curr.name, vim.log.levels.INFO)

  local fullLengthTimer = vim.defer_fn(function()
    local message = 'Completed ' .. Pomo.curr.name .. '!'
    notify(message, vim.log.levels.INFO)
    os.execute('say ' .. message)
    os.execute('terminal-notifier -message "Pomo complete" -title "' .. Pomo.curr.name .. '"')
  end, ms(Pomo.curr.duration_set))
  table.insert(Pomo.timers, fullLengthTimer)

  for i, v in ipairs(Pomo.config.progressAlertsAtTimeRemaining) do
    local timer = vim.defer_fn(function() Pomo.notify(v, Pomo.levels[i]) end, ms(Pomo.curr.duration_set - v))
    table.insert(Pomo.timers, timer)
  end
end

Pomo.startPomo = function()
  Pomo.curr.started_at = os.time()
  vim.ui.select(Pomo.config.projects, nil,
    function(project)
      if project == nil or project == '' then
        error('No project no pomo')
      end

      Pomo.curr.project = project

      vim.ui.select(
        Pomo.config.defaultPomoLengths,
        { prompt = "Pomo length" },
        function(duration)
          if duration == nil or duration == '' then
            error('No time no pomo')
          end

          local kickStart = function(duration)
            Pomo.curr.duration_set = tonumber(duration)
            vim.fn.appendbufline(Pomo.buffer, "$", "\n")
            Pomo.startTimers()
          end

          if duration == 'Custom' then
            vim.ui.input({ prompt = "Custom Pomo Length: ", default = tostring(Pomo.config.defaultLength) },
              function(customVal)
                kickStart(customVal)
              end)
          else
            kickStart(duration)
          end
        end)
    end)
end

Pomo.extractPomoContents = function()
  local handle = io.open(Pomo.tmpBufferName, 'r')
  local data = handle:read("*a")

  local contents = {}
  for line in string.gmatch(data, '[^\n]+') do
    table.insert(contents, line)
  end

  local name = contents[1]
  local description = ''
  if #contents > 2 then
    local descriptionArray = vim.fn.remove(contents, 2, #contents - 1)
    description = table.concat(descriptionArray, '\n')
  end

  Pomo.curr.name = name
  Pomo.curr.description = description
  Pomo.retrieveTimeTaken()
end

Pomo.logToDb = function()
  pomos:insert(Pomo.curr)
end

Pomo.onFinish = function()
  for _, timer in ipairs(Pomo.timers) do
    if not timer:is_closing() then
      timer:close()
    end
  end

  vim.ui.select({ 'Yes', 'No' }, nil, function(selection)
    if selection == 'Yes' then
      Pomo.extractPomoContents()
      Pomo.logToDb()
    end
  end)
  vim.api.nvim_del_augroup_by_name('PomoOnSaveAndClose')
end

Pomo.initialize()

return Pomo
