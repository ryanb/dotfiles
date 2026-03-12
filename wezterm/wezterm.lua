local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Dracula+'

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
}

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

return config
