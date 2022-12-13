local wezterm = require 'wezterm'
local keybinds = require 'keybinds'
require 'on'

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

return {
  term = 'wezterm',
  font = wezterm.font 'Fira Code',
  font_size = 20,
  underline_position = -3,
  underline_thickness = 2,
  switch_to_last_active_tab_when_closing_tab = true,
  use_fancy_tab_bar = true,
  window_frame = {
    font_size = 20,
    active_titlebar_bg = '#000',
    inactive_titlebar_bg = '#666',
  },
  window_padding = {
    bottom = 0,
    top = 0,
  },
  keys = keybinds.create_keybinds(),
  key_tables = keybinds.key_tables,
	mouse_bindings = keybinds.mouse_bindings,
  colors = {
    compose_cursor = 'orange',
  },
  inactive_pane_hsb = {
    saturation = 0.6,
    brightness = 0.4,
  },
}
