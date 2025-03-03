local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.hide_mouse_cursor_when_typing = false
config.window_decorations = "NONE" -- try changing back to RESIZE at some point, was causing issues
config.default_prog = { 'nu' }
config.use_fancy_tab_bar = false
config.front_end = "WebGpu" -- workaround for rendering bug
config.colors = { -- ferra theme
  ansi = {'#1f1e20','#c05862','#b1b695','#f5d76e','#ffa07a','#f6b6c9','#bfbfcf','#f5f5f5'},
  background = '#2b292d',
  brights = {'#6f5d63','#e06b75','#9f9f7c','#fff27a','#e88c6f','#ffb9cc','#d1d1e0','#ffffff'},
  cursor_bg = '#fecdb2',
  cursor_border = '#fecdb2',
  cursor_fg = '#383539',
  foreground = '#fecdb2',
  selection_bg = '#4d424b',
  selection_fg = '#fecdb2',
  tab_bar = { background = '#2b292d' }
}
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14
config.keys = {
  {key = 'Backspace', mods = 'ALT', action = act.CloseCurrentPane { confirm = false }},
  {key = 'Backspace', mods = 'ALT|SHIFT', action = act.CloseCurrentTab { confirm = false }},
  {key = 't', mods = 'ALT', action = act.SpawnTab 'DefaultDomain'},
  {key = 'LeftArrow', mods = 'ALT', action = act.ActivateTabRelative(-1)},
  {key = 'RightArrow', mods = 'ALT', action = act.ActivateTabRelative(1)},
  {key = 'LeftArrow', mods = 'ALT|SHIFT', action = act.MoveTabRelative(-1)},
  {key = 'RightArrow', mods = 'ALT|SHIFT', action = act.MoveTabRelative(1)},
  {key = '#', mods = 'ALT', action = act.EmitEvent 'dev-layout'},
  {key = 'm', mods = 'ALT', action = act.TogglePaneZoomState},
  {key = 'j', mods = 'ALT', action = act.EmitEvent 'run-just-in-last-pane'},
  {key = 'c', mods = 'ALT', action = act.EmitEvent 'ctrl-c-in-last-pane'}
}
workspaces = {{'q','default'},{'w','w'},{'e','e'},{'r','r'},{'a','a'},{'s','s'},{'d','d'},{'e','e'},{'f','f'},{'z','z'},{'x','x'}}
for _,ws in pairs(workspaces) do
  table.insert(config.keys, {key = ws[1], mods = 'ALT', action = act.SwitchToWorkspace{ name = ws[2] }})
end
for i = 1, 9 do
  table.insert(config.keys, {key = tostring(i), mods = 'ALT', action = act.ActivateTab(i - 1)})
end

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on('update-status', function(window, pane)
  window:set_left_status(wezterm.format {{ Text = window:active_workspace() .. ' ' }})
end)


wezterm.on('dev-layout', function(window, pane)
  local child_pane = pane:split {
    direction = 'Right',
    size = 0.33,
  }
  window:perform_action(act{SendString = "hx"}, pane)
  window:perform_action(act{SendKey={key="Enter"}}, pane)
  window:perform_action(act{SpawnCommandInNewTab={args={'gitui'}}}, pane)
  window:perform_action(act{SpawnCommandInNewTab={args={'yazi'}}}, pane)
  pane:activate()
end)

wezterm.on('run-just-in-last-pane', function(window, _)
  local panes = window:active_tab():panes()
  local pane = panes[#panes]
  window:perform_action(act{SendString = "just"}, pane)
  window:perform_action(act{SendKey={key="Enter"}}, pane)
end)

wezterm.on('ctrl-c-in-last-pane', function(window, _)
  local panes = window:active_tab():panes()
  local pane = panes[#panes]
  window:perform_action(act{SendKey = {key="c", mods="CTRL"}}, pane)
  window:perform_action(act{SendKey={key="Enter"}}, pane)
end)

return config
