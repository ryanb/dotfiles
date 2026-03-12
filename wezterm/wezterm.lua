local wezterm = require 'wezterm'
local workspace = require 'workspace'
local config = wezterm.config_builder()

config.color_scheme = 'Dracula+'
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_frame = {
  active_titlebar_bg = '#191919',
  inactive_titlebar_bg = '#191919',
}

config.initial_cols = 120
config.initial_rows = 44

config.font = wezterm.font('DejaVu Sans Mono')
config.font_size = 18
config.line_height = 1.08
config.max_fps = 120

config.colors = {
  cursor_bg = '#FFFFFF',
}

config.keys = {
  {
    key = 'k',
    mods = 'SUPER',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
  { key = 'n', mods = 'SUPER|SHIFT', action = workspace.create },
  { key = 'p', mods = 'SUPER|SHIFT', action = workspace.switcher },
  { key = 'r', mods = 'SUPER|SHIFT', action = workspace.rename },
  { key = 'w', mods = 'SUPER|SHIFT', action = workspace.close },
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action.SendString '\x1b\r',
  },
  {
    key = '{',
    mods = 'SUPER|CTRL|SHIFT',
    action = wezterm.action.MoveTabRelative(-1),
  },
  {
    key = '}',
    mods = 'SUPER|CTRL|SHIFT',
    action = wezterm.action.MoveTabRelative(1),
  },
}

config.show_tab_index_in_tab_bar = false

wezterm.on('update-status', function(window, pane)
  local workspace = window:active_workspace()
  window:set_right_status(wezterm.format {
    { Background = { Color = '#191919' } },
    { Foreground = { Color = '#ffffff' } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = workspace .. '      ' },
  })
end)

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)


return config
