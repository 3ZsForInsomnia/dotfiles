local wezterm = require 'wezterm'
local action = wezterm.action
local utils = require 'utils'

local M = {}

M.Tabs = {
  {
    key = '1',
    mods = 'ALT',
    action = action.ActivateTab(0),
  },
  {
    key = '2',
    mods = 'ALT',
    action = action.ActivateTab(1),
  },
  {
    key = '3',
    mods = 'ALT',
    action = action.ActivateTab(2),
  },
  {
    key = '4',
    mods = 'ALT',
    action = action.ActivateTab(3),
  },
  {
    key = '5',
    mods = 'ALT',
    action = action.ActivateTab(4),
  },
  {
    key = '6',
    mods = 'ALT',
    action = action.ActivateTab(5),
  },
  {
    key = '7',
    mods = 'ALT',
    action = action.ActivateTab(6),
  },
  {
    key = '8',
    mods = 'ALT',
    action = action.ActivateTab(7),
  },
  { key = '9', mods = 'ALT', action = wezterm.action.ShowTabNavigator },
}

M.Panes = {
  { key = "h", mods = "ALT", action = action({ ActivatePaneDirection = "Left" }) },
  { key = "l", mods = "ALT", action = action({ ActivatePaneDirection = "Right" }) },
  { key = "k", mods = "ALT", action = action({ ActivatePaneDirection = "Up" }) },
  { key = "j", mods = "ALT", action = action({ ActivatePaneDirection = "Down" }) },
  { key = 'z', mods = 'ALT', action = action.TogglePaneZoomState },
  { key = "'", mods = 'ALT', action = action.SplitHorizontal },
  { key = ';', mods = 'ALT', action = action.SplitVertical },
}

M.Misc = {
  -- Turn off the default CMD-m Hide action, allowing CMD-m to
  -- be potentially recognized and handled by the tab
  {
    key = 'Enter',
    mods = 'ALT',
    action = action.DisableDefaultAssignment,
  },
  -- Ctrl-Q is used by telescope
  {
    key = "Q",
    mods = "CTRL",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "q",
    mods = "CTRL",
    action = action.DisableDefaultAssignment,
  },
  {
    key = "q",
    mods = "CTRL|SHIFT",
    action = action.DisableDefaultAssignment,
  },
  -- Ctrl-R is used by zsh-autocomplete
  {
    key = "r",
    mods = "CTRL",
    action = action.DisableDefaultAssignment
  },
  {
    key = "R",
    mods = "CTRL",
    action = action.DisableDefaultAssignment
  },
  {
    key = "r",
    mods = "ALT",
    action = action({
      ActivateKeyTable = {
        name = "resize_pane",
        one_shot = false,
        timeout_milliseconds = 3000,
        replace_current = false,
      },
    }),
  },
  {
    key = "LeftArrow",
    mods = "OPT",
    action = action { SendString = "\x1bb" }
  },
  {
    key = "RightArrow",
    mods = "OPT",
    action = action { SendString = "\x1bf" }
  },
}

function M.create_keybinds()
  return utils.merge_lists(M.Tabs, M.Panes, M.Misc)
end

M.key_tables = {
  resize_pane = {
    { key = "LeftArrow", action = action({ AdjustPaneSize = { "Left", 1 } }) },
    { key = "RightArrow", action = action({ AdjustPaneSize = { "Right", 1 } }) },
    { key = "UpArrow", action = action({ AdjustPaneSize = { "Up", 1 } }) },
    { key = "DownArrow", action = action({ AdjustPaneSize = { "Down", 1 } }) },

    { key = "h", action = action({ AdjustPaneSize = { "Left", 1 } }) },
    { key = "l", action = action({ AdjustPaneSize = { "Right", 1 } }) },
    { key = "k", action = action({ AdjustPaneSize = { "Up", 1 } }) },
    { key = "j", action = action({ AdjustPaneSize = { "Down", 1 } }) },

    { key = "H", action = action({ AdjustPaneSize = { "Left", 5 } }) },
    { key = "L", action = action({ AdjustPaneSize = { "Right", 5 } }) },
    { key = "K", action = action({ AdjustPaneSize = { "Up", 5 } }) },
    { key = "J", action = action({ AdjustPaneSize = { "Down", 5 } }) },

    -- Cancel the mode by pressing escape
    { key = "Escape", action = "PopKeyTable" },
  },
  copy_mode = {
    {
      key = "Escape",
      mods = "NONE",
      action = action.Multiple({
        action.ClearSelection,
        action.CopyMode("ClearPattern"),
        action.CopyMode("Close"),
      }),
    },
    { key = "q", mods = "NONE", action = action.CopyMode("Close") },

    -- move cursor
    { key = "h", mods = "NONE", action = action.CopyMode("MoveLeft") },
    { key = "j", mods = "NONE", action = action.CopyMode("MoveDown") },
    { key = "k", mods = "NONE", action = action.CopyMode("MoveUp") },
    { key = "l", mods = "NONE", action = action.CopyMode("MoveRight") },

    -- move word
    { key = "w", mods = "NONE", action = action.CopyMode("MoveForwardWord") },
    { key = "b", mods = "NONE", action = action.CopyMode("MoveBackwardWord") },

    -- Move to char/space at end of next word
    {
      key = "e",
      mods = "NONE",
      action = action({
        Multiple = {
          action.CopyMode("MoveRight"),
          action.CopyMode("MoveForwardWord"),
          action.CopyMode("MoveLeft"),
        },
      }),
    },

    -- move start/end
    { key = "0", mods = "NONE", action = action.CopyMode("MoveToStartOfLine") },
    { key = "^", mods = "CTRL", action = action.CopyMode("MoveToStartOfLineContent") },

    { key = "$", mods = "NONE", action = action.CopyMode("MoveToEndOfLineContent") },
    { key = "e", mods = "CTRL", action = action.CopyMode("MoveToEndOfLineContent") },

    { key = "\n", mods = "NONE", action = action.CopyMode("MoveToStartOfNextLine") },

    -- select
    { key = " ", mods = "NONE", action = action.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "v", mods = "NONE", action = action.CopyMode({ SetSelectionMode = "Cell" }) },
    {
      key = "v",
      mods = "SHIFT",
      action = action({
        Multiple = {
          action.CopyMode("MoveToStartOfLineContent"),
          action.CopyMode({ SetSelectionMode = "Cell" }),
          action.CopyMode("MoveToEndOfLineContent"),
        },
      }),
    },

    -- copy
    {
      key = "y",
      mods = "NONE",
      action = action({
        Multiple = {
          action({ CopyTo = "ClipboardAndPrimarySelection" }),
          action.CopyMode("Close"),
        },
      }),
    },
    {
      key = "y",
      mods = "SHIFT",
      action = action({
        Multiple = {
          action.CopyMode({ SetSelectionMode = "Cell" }),
          action.CopyMode("MoveToEndOfLineContent"),
          action({ CopyTo = "ClipboardAndPrimarySelection" }),
          action.CopyMode("Close"),
        },
      }),
    },

    -- scroll
    { key = "g", mods = "NONE", action = action.CopyMode("MoveToScrollbackTop") },
    { key = "G", mods = "SHIFT", action = action.CopyMode("MoveToScrollbackBottom") },

    { key = "H", mods = "SHIFT", action = action.CopyMode("MoveToViewportTop") },
    { key = "M", mods = "SHIFT", action = action.CopyMode("MoveToViewportMiddle") },
    { key = "L", mods = "SHIFT", action = action.CopyMode("MoveToViewportBottom") },

    { key = "o", mods = "NONE", action = action.CopyMode("MoveToSelectionOtherEnd") },
    { key = "O", mods = "NONE", action = action.CopyMode("MoveToSelectionOtherEndHoriz") },

    { key = "b", mods = "CTRL", action = action.CopyMode("PageUp") },
    { key = "f", mods = "CTRL", action = action.CopyMode("PageDown") },

    {
      key = "Enter",
      mods = "NONE",
      action = action.CopyMode("ClearSelectionMode"),
    },

    -- search
    { key = "/", mods = "NONE", action = action.Search("CurrentSelectionOrEmptyString") },
    {
      key = "n",
      mods = "NONE",
      action = action.Multiple({
        action.CopyMode("NextMatch"),
        action.CopyMode("ClearSelectionMode"),
      }),
    },
    {
      key = "N",
      mods = "NONE",
      action = action.Multiple({
        action.CopyMode("PriorMatch"),
        action.CopyMode("ClearSelectionMode"),
      }),
    },
  },
  search_mode = {
    { key = "Escape", mods = "NONE", action = action.CopyMode("Close") },
    {
      key = "Enter",
      mods = "NONE",
      action = action.Multiple({
        action.CopyMode("ClearSelectionMode"),
        action.ActivateCopyMode,
      }),
    },
    { key = "p", mods = "CTRL", action = action.CopyMode("PriorMatch") },
    { key = "n", mods = "CTRL", action = action.CopyMode("NextMatch") },
    { key = "r", mods = "CTRL", action = action.CopyMode("CycleMatchType") },
    { key = "/", mods = "NONE", action = action.CopyMode("ClearPattern") },
    { key = "u", mods = "CTRL", action = action.CopyMode("ClearPattern") },
  },
}

M.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = action({ CompleteSelection = "PrimarySelection" }),
  },
  {
    event = { Up = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = action({ CompleteSelection = "Clipboard" }),
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = "OpenLinkAtMouseCursor",
  },
}

return M
