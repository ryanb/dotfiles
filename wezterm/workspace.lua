local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

local last_used = {}

wezterm.on('update-status', function(window, _pane)
  local name = window:active_workspace()
  last_used[name] = os.time()
end)

M.switcher = wezterm.action_callback(function(window, pane)
  local current = window:active_workspace()
  local workspaces = wezterm.mux.get_workspace_names()

  table.sort(workspaces, function(a, b)
    local ta = last_used[a] or 0
    local tb = last_used[b] or 0
    return ta > tb
  end)

  local choices = {}
  for _, name in ipairs(workspaces) do
    if name ~= current then
      table.insert(choices, { label = name })
    end
  end

  window:perform_action(
    act.InputSelector {
      title = 'Switch Workspace',
      fuzzy = true,
      choices = choices,
      action = wezterm.action_callback(function(inner_window, inner_pane, _id, label)
        if label then
          inner_window:perform_action(act.SwitchToWorkspace { name = label }, inner_pane)
        end
      end),
    },
    pane
  )
end)

M.previous = wezterm.action_callback(function(window, pane)
  local current = window:active_workspace()
  local workspaces = wezterm.mux.get_workspace_names()

  local best_name = nil
  local best_time = 0
  for _, name in ipairs(workspaces) do
    local t = last_used[name] or 0
    if name ~= current and t > best_time then
      best_name = name
      best_time = t
    end
  end

  if best_name then
    window:perform_action(act.SwitchToWorkspace { name = best_name }, pane)
  end
end)

M.create = wezterm.action_callback(function(window, pane)
  local cwd = pane:get_current_working_dir()
  local dir = cwd.file_path:gsub('/$', '')
  local name = dir:match('([^/]+)$')

  window:perform_action(
    act.SwitchToWorkspace {
      name = name,
      spawn = { cwd = dir },
    },
    pane
  )
end)

M.rename = wezterm.action_callback(function(window, pane)
  local current = window:active_workspace()
  window:perform_action(
    act.PromptInputLine {
      description = 'Rename workspace (' .. current .. '):',
      action = wezterm.action_callback(function(inner_window, inner_pane, line)
        if line and #line > 0 then
          wezterm.mux.rename_workspace(current, line)
        end
      end),
    },
    pane
  )
end)

M.close = wezterm.action_callback(function(window, pane)
  local mux_win = window:mux_window()
  local tabs = mux_win:tabs()
  for _ = 1, #tabs do
    window:perform_action(act.CloseCurrentTab { confirm = false }, pane)
  end
end)

return M
