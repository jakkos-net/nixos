local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.hide_mouse_cursor_when_typing = false;
config.window_decorations = "RESIZE"
config.default_prog = { 'nu' }
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Dracula'

local act = wezterm.action
config.keys = {
  { key = '1', mods = 'ALT', action = act.ActivatePaneByIndex(0) },
  { key = '2', mods = 'ALT', action = act.ActivatePaneByIndex(1) },
  { key = '3', mods = 'ALT', action = act.ActivatePaneByIndex(2) },
  { key = '4', mods = 'ALT', action = act.ActivatePaneByIndex(3) },
  { key = 'Backspace', mods = 'ALT', action = act.CloseCurrentPane { confirm = false }},
  { key = 'Backspace', mods = 'ALT|SHIFT', action = act.CloseCurrentTab { confirm = false }},
  { key = 'v', mods = 'ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }},
  { key = 'h', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }},
  { key = 't', mods = 'ALT', action = act.SpawnTab 'DefaultDomain'},
  { key = ',', mods = 'ALT', action = act.ActivateTabRelative(-1) },
  { key = '.', mods = 'ALT', action = act.ActivateTabRelative(1) },
  { key = '#', mods = 'ALT', action = act.EmitEvent 'rust-layout'},
}

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
  -- split into two thirds top, one third bottom
  child_pane:split {
    direction = 'Bottom',
    size = 0.33,
  }
  -- split the top two thirds in half, to get 3 thirds
  child_pane:split {
    direction = 'Bottom',
    args = {"nu", "-e", "gitui"},
    size = 0.5
  }
  window:perform_action(wezterm.action{SendString = "hx"}, pane)
  window:perform_action(wezterm.action{SendKey={key="Enter", mods="NONE"}}, pane)
  pane:activate()
end)

return config
