local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

config.hide_mouse_cursor_when_typing = false
config.window_decorations = "RESIZE"
config.default_prog = { 'nu' }
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Dracula'
config.colors = { tab_bar = { background = '#000000'} }
config.window_background_image = wezterm.home_dir .. "/wallpaper"

config.keys = {
  {key = 'q', mods = 'ALT', action = act.ActivatePaneByIndex(0)},
  {key = 'w', mods = 'ALT', action = act.ActivatePaneByIndex(1)},
  {key = 'e', mods = 'ALT', action = act.ActivatePaneByIndex(2)},
  {key = 'r', mods = 'ALT', action = act.ActivatePaneByIndex(3)},
  {key = 'Backspace', mods = 'ALT', action = act.CloseCurrentPane { confirm = false }},
  {key = 'Backspace', mods = 'ALT|SHIFT', action = act.CloseCurrentTab { confirm = false }},
  {key = 'v', mods = 'ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }},
  {key = 'h', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }},
  {key = 't', mods = 'ALT', action = act.SpawnTab 'DefaultDomain'},
  {key = 'LeftArrow', mods = 'ALT', action = act.ActivateTabRelative(-1)},
  {key = 'RightArrow', mods = 'ALT', action = act.ActivateTabRelative(1)},
  {key = 'LeftArrow', mods = 'ALT|SHIFT', action = act.MoveTabRelative(-1)},
  {key = 'RightArrow', mods = 'ALT|SHIFT', action = act.MoveTabRelative(1)},
  {key = '#', mods = 'ALT', action = act.EmitEvent 'rust-layout'},
  {key = 'j', mods = 'ALT', action = act.EmitEvent 'run-just-in-pane-3'},
}
for i = 1, 9 do
  table.insert(config.keys, {key = tostring(i), mods = 'ALT', action = act.ActivateTab(i - 1)})
end

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on('rust-layout', function(window, pane)
  local child_pane = pane:split {
    direction = 'Right',
    args = {"nu", "-e", "nix develop --command bacon"},
    size = 0.33,
  }
  child_pane:split {
    direction = 'Bottom',
    size = 0.33,
  }
  child_pane:split {
    direction = 'Bottom',
    args = {"nu", "-e", "gitui"},
    size = 0.5
  }
  window:perform_action(act{SendString = "hx"}, pane)
  window:perform_action(act{SendKey={key="Enter"}}, pane)
  pane:activate()
end)

wezterm.on('run-just-in-pane-3', function(window, _)
  local pane = window:active_tab():panes()[4]
  window:perform_action(act{SendString = "just"}, pane)
  window:perform_action(act{SendKey={key="Enter"}}, pane)
end)

return config
