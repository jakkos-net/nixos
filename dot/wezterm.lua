local io = require 'io'
local os = require 'os'

local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.default_prog = { 'nu' }
config.window_background_opacity = 0.9
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Dracula'
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}
-- config.initial_cols = 5000
-- config.initial_rows = 5000
config.keys = {
  { key = '1', mods = 'ALT', action = act.ActivatePaneByIndex(0) },
  { key = '2', mods = 'ALT', action = act.ActivatePaneByIndex(1) },
  { key = '3', mods = 'ALT', action = act.ActivatePaneByIndex(2) },
  { key = '4', mods = 'ALT', action = act.ActivatePaneByIndex(3) },
  { key = 'Backspace', mods = 'ALT', action = act.CloseCurrentPane { confirm = false }},
  { key = 'Backspace', mods = 'ALT|SHIFT', action = act.CloseCurrentTab { confirm = false }},
  { key = 'v', mods = 'ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }},
  { key = 'h', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }},
  { key = 'DownArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Down', 5 }},
  { key = 'UpArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Up', 5 }},
  { key = 'LeftArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Left', 5 }},
  { key = 'RightArrow', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Right', 5 }},
  { key = 't', mods = 'ALT', action = act.SpawnTab 'DefaultDomain'},
  { key = 'l', mods = 'ALT', action = act.EmitEvent 'trigger-hx-with-visible-text'},
  { key = '.', mods = 'ALT', action = act.ActivateTabRelative(-1) },
  { key = ',', mods = 'ALT', action = act.ActivateTabRelative(1) },
  { key = '#', mods = 'ALT', action = act.EmitEvent 'dev-layout'}
}

wezterm.on('dev-layout', function(window,pane)
  local child_pane = pane:split {
    direction = 'Right',
    size = 0.2,
  }
  child_pane:split {
    direction = 'Bottom'
  }
  window:maximize()
end)

-- open the visible terminal text in editor
wezterm.on('trigger-hx-with-visible-text', function(window, pane)
  local viewport_text = pane:get_lines_as_text()
  local name = os.tmpname()
  local f = io.open(name, 'w+')
  f:write(viewport_text)
  f:flush()
  f:close()

  window:perform_action(
    act.SpawnCommandInNewTab {
      args = { 'hx', name },
    },
    pane
  )
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

return config
