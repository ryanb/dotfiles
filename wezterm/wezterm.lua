local wezterm = require 'wezterm'
local workspace = require 'workspace'
local config = wezterm.config_builder()

local titlebar_bg = '#191919'

config.color_scheme = 'Dracula+'
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_frame = {
  active_titlebar_bg = titlebar_bg,
  inactive_titlebar_bg = titlebar_bg,
}

config.initial_cols = 120
config.initial_rows = 44

config.font = wezterm.font('DejaVu Sans Mono')
config.font_size = 18
config.line_height = 1.08
config.max_fps = 120
config.audible_bell = 'Disabled'

config.colors = {
  cursor_bg = '#FFFFFF',
  tab_bar = {
    active_tab = {
      bg_color = '#242424',
      fg_color = '#ffffff',
    },
    inactive_tab = {
      bg_color = titlebar_bg,
      fg_color = '#888888',
    },
    inactive_tab_hover = {
      bg_color = '#1e1e1e',
      fg_color = '#ffffff',
    },
    new_tab = {
      bg_color = titlebar_bg,
      fg_color = '#888888',
    },
    new_tab_hover = {
      bg_color = '#242424',
      fg_color = '#ffffff',
    },
  },
}

config.keys = {
  {
    key = 'k',
    mods = 'SUPER',
    action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
  },
  { key = 'n', mods = 'SUPER|SHIFT', action = workspace.create },
  { key = 'p', mods = 'SUPER', action = workspace.switcher },
  { key = 'p', mods = 'SUPER|CTRL', action = workspace.previous },
  { key = 'r', mods = 'SUPER|SHIFT', action = workspace.rename },
  { key = 'w', mods = 'SUPER|SHIFT', action = workspace.close },
  {
    key = 'Enter',
    mods = 'ALT',
    action = wezterm.action.SendString '\x1b\r',
  },
  {
    key = 'LeftArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bb',
  },
  {
    key = 'RightArrow',
    mods = 'OPT',
    action = wezterm.action.SendString '\x1bf',
  },
  {
    key = 'p',
    mods = 'SUPER|SHIFT',
    action = wezterm.action.ActivateCommandPalette,
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

config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = { WheelLeft = 1 } } },
    action = wezterm.action.SendString '',
  },
  {
    event = { Down = { streak = 1, button = { WheelRight = 1 } } },
    action = wezterm.action.SendString '',
  },
}

config.show_tab_index_in_tab_bar = false

config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[\bfile://\S+]],
  format = '$0',
})

wezterm.on('open-uri', function(window, pane, uri)
  uri = uri:gsub('%)+$', '')
  if uri:sub(1, 7) == 'file://' then
    local path = uri:gsub('^file://', '')
    wezterm.open_with(path, 'Visual Studio Code')
  else
    wezterm.open_with(uri)
  end
  return false
end)

wezterm.on('update-status', function(window, pane)
  local workspace = window:active_workspace()
  window:set_right_status(wezterm.format {
    { Background = { Color = titlebar_bg } },
    { Foreground = { Color = '#ffffff' } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = workspace .. '      ' },
  })
end)

wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'switch-workspace' then
    window:perform_action(wezterm.action.SwitchToWorkspace { name = value }, pane)
  end
end)

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)


return config
