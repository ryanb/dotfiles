local wezterm = require 'wezterm'
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

config.colors = {
  cursor_bg = '#FFFFFF',
}

config.keys = {
  {
    key = 'k',
    mods = 'SUPER',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
  {
    key = 'n',
    mods = 'SUPER',
    action = wezterm.action_callback(function(window, pane)
      local tab, new_pane, new_window = wezterm.mux.spawn_window {}
      new_window:gui_window():maximize()
    end),
  },
}

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)


return config
