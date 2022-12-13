local wezterm = require 'wezterm'
local action = wezterm.action
local utils = require 'utils'

local PaneResizeAmount = 20

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
  {
    key = '-',
    mods = 'ALT',
    action = action.ShowTabNavigator,
  },
}

M.Panes = {
  { key = "a", mods = "ALT", action = action({ ActivatePaneDirection = "Left" }) },
  { key = "d", mods = "ALT", action = action({ ActivatePaneDirection = "Right" }) },
  { key = "w", mods = "ALT", action = action({ ActivatePaneDirection = "Up" }) },
  { key = "x", mods = "ALT", action = action({ ActivatePaneDirection = "Down" }) },
  {
    key = 'H',
    mods = 'CTRL|ALT',
    action = action.AdjustPaneSize { 'Left', PaneResizeAmount * 2 },
  },
  {
    key = 'J',
    mods = 'CTRL|ALT',
    action = action.AdjustPaneSize { 'Down', PaneResizeAmount * 2 },
  },
  { key = 'K', mods = 'ALT', action = action.AdjustPaneSize { 'Up', PaneResizeAmount * 2 } },
  {
    key = 'L',
    mods = 'CTRL|ALT',
    action = action.AdjustPaneSize { 'Right', PaneResizeAmount * 2 },
  },
  {
    key = 'h',
    mods = 'CTRL|ALT',
    action = action.AdjustPaneSize { 'Left', PaneResizeAmount },
  },
  {
    key = 'j',
    mods = 'ALT',
    action = action.AdjustPaneSize { 'Down', PaneResizeAmount },
  },
  { key = 'k', mods = 'ALT', action = action.AdjustPaneSize { 'Up', PaneResizeAmount } },
  {
    key = 'l',
    mods = 'ALT',
    action = action.AdjustPaneSize { 'Right', PaneResizeAmount },
  },
  -- { key = 't', mods = 'ALT', action = action.ActivatePaneByIndex(0) },
  -- { key = 'y', mods = 'ALT', action = action.ActivatePaneByIndex(1) },
  -- { key = 'u', mods = 'ALT', action = action.ActivatePaneByIndex(2) },
  -- { key = 'i', mods = 'ALT', action = action.ActivatePaneByIndex(3) },
  -- { key = 'o', mods = 'ALT', action = action.ActivatePaneByIndex(4) },
  -- { key = 'p', mods = 'ALT', action = action.ActivatePaneByIndex(5) },
  { key = 'z', mods = 'ALT', action = action.TogglePaneZoomState },
  { key = "'", mods = 'ALT', action = action.SplitHorizontal },
  { key = ';', mods = 'ALT', action = action.SplitVertical },
}

M.Misc = {
  {
    key = 'T',
    mods = 'CTRL|SHIFT|ALT',
    action = action.EmitEvent 'new-dev-tab'
  },
  -- {
  --   key = 'R',
  --   mods = 'CTRL|SHIFT|ALT',
  --   action = action.EmitEvent 'new-dev-env'
  -- },
  -- Turn off the default CMD-m Hide action, allowing CMD-m to
  -- be potentially recognized and handled by the tab
  {
    key = 'Enter',
    mods = 'ALT',
    action = action.DisableDefaultAssignment,
  },
  { key = 'v', mods = 'CTRL', action = action.PasteFrom 'Clipboard' },
  { key = "/", mods = "ALT", action = action.Search("CurrentSelectionOrEmptyString") },
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
    key = "s",
    mods = "ALT",
    action = action.PaneSelect({
      alphabet = "1234567890",
    })
  },
  {
    key = 'c',
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        window:perform_action(
          action.CopyTo 'ClipboardAndPrimarySelection',
          pane
        )

        window:perform_action(action.ClearSelection, pane)
      else
        window:perform_action(
          action.SendKey { key = 'c', mods = 'CTRL' },
          pane
        )
      end
    end),
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
    { key = "h", action = action({ AdjustPaneSize = { "Left", 1 } }) },
    { key = "RightArrow", action = action({ AdjustPaneSize = { "Right", 1 } }) },
    { key = "l", action = action({ AdjustPaneSize = { "Right", 1 } }) },
    { key = "UpArrow", action = action({ AdjustPaneSize = { "Up", 1 } }) },
    { key = "k", action = action({ AdjustPaneSize = { "Up", 1 } }) },
    { key = "DownArrow", action = action({ AdjustPaneSize = { "Down", 1 } }) },
    { key = "j", action = action({ AdjustPaneSize = { "Down", 1 } }) },
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
    { key = "LeftArrow", mods = "NONE", action = action.CopyMode("MoveLeft") },
    { key = "j", mods = "NONE", action = action.CopyMode("MoveDown") },
    { key = "DownArrow", mods = "NONE", action = action.CopyMode("MoveDown") },
    { key = "k", mods = "NONE", action = action.CopyMode("MoveUp") },
    { key = "UpArrow", mods = "NONE", action = action.CopyMode("MoveUp") },
    { key = "l", mods = "NONE", action = action.CopyMode("MoveRight") },
    { key = "RightArrow", mods = "NONE", action = action.CopyMode("MoveRight") },
    -- move word
    { key = "RightArrow", mods = "ALT", action = action.CopyMode("MoveForwardWord") },
    { key = "f", mods = "ALT", action = action.CopyMode("MoveForwardWord") },
    { key = "\t", mods = "NONE", action = action.CopyMode("MoveForwardWord") },
    { key = "w", mods = "NONE", action = action.CopyMode("MoveForwardWord") },
    { key = "LeftArrow", mods = "ALT", action = action.CopyMode("MoveBackwardWord") },
    { key = "b", mods = "ALT", action = action.CopyMode("MoveBackwardWord") },
    { key = "\t", mods = "SHIFT", action = action.CopyMode("MoveBackwardWord") },
    { key = "b", mods = "NONE", action = action.CopyMode("MoveBackwardWord") },
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
    { key = "\n", mods = "NONE", action = action.CopyMode("MoveToStartOfNextLine") },
    { key = "$", mods = "SHIFT", action = action.CopyMode("MoveToEndOfLineContent") },
    { key = "$", mods = "NONE", action = action.CopyMode("MoveToEndOfLineContent") },
    { key = "e", mods = "CTRL", action = action.CopyMode("MoveToEndOfLineContent") },
    { key = "m", mods = "ALT", action = action.CopyMode("MoveToStartOfLineContent") },
    { key = "^", mods = "SHIFT", action = action.CopyMode("MoveToStartOfLineContent") },
    { key = "^", mods = "NONE", action = action.CopyMode("MoveToStartOfLineContent") },
    { key = "a", mods = "CTRL", action = action.CopyMode("MoveToStartOfLineContent") },
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
    { key = "G", mods = "SHIFT", action = action.CopyMode("MoveToScrollbackBottom") },
    { key = "G", mods = "NONE", action = action.CopyMode("MoveToScrollbackBottom") },
    { key = "g", mods = "NONE", action = action.CopyMode("MoveToScrollbackTop") },
    { key = "H", mods = "NONE", action = action.CopyMode("MoveToViewportTop") },
    { key = "H", mods = "SHIFT", action = action.CopyMode("MoveToViewportTop") },
    { key = "M", mods = "NONE", action = action.CopyMode("MoveToViewportMiddle") },
    { key = "M", mods = "SHIFT", action = action.CopyMode("MoveToViewportMiddle") },
    { key = "L", mods = "NONE", action = action.CopyMode("MoveToViewportBottom") },
    { key = "L", mods = "SHIFT", action = action.CopyMode("MoveToViewportBottom") },
    { key = "o", mods = "NONE", action = action.CopyMode("MoveToSelectionOtherEnd") },
    { key = "O", mods = "NONE", action = action.CopyMode("MoveToSelectionOtherEndHoriz") },
    { key = "O", mods = "SHIFT", action = action.CopyMode("MoveToSelectionOtherEndHoriz") },
    { key = "PageUp", mods = "NONE", action = action.CopyMode("PageUp") },
    { key = "PageDown", mods = "NONE", action = action.CopyMode("PageDown") },
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
      mods = "SHIFT",
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
