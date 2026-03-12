local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

M.switcher = {
  key = 'p',
  mods = 'SUPER|SHIFT',
  action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
}

M.create = {
  key = 'n',
  mods = 'SUPER|SHIFT',
  action = wezterm.action_callback(function(window, pane)
    local cwd = pane:get_current_working_dir()
    local dir = cwd.file_path
    local name = dir:match('([^/]+)$')

    window:perform_action(
      act.SwitchToWorkspace {
        name = name,
        spawn = { cwd = dir },
      },
      pane
    )
  end),
}

M.close = {
  key = 'w',
  mods = 'SUPER|SHIFT',
  action = wezterm.action_callback(function(window, pane)
    local mux_win = window:mux_window()
    local tabs = mux_win:tabs()
    for _ = 1, #tabs do
      window:perform_action(act.CloseCurrentTab { confirm = false }, pane)
    end
  end),
}

return M
