local wezterm = require 'wezterm'
local config = {}
local act = wezterm.action
local io = require 'io'
local os = require 'os'
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.default_prog = { 'nu' }

config.keys = {
  { key = '1', mods = 'ALT', action = act.ActivatePaneByIndex(0) },
  { key = '2', mods = 'ALT', action = act.ActivatePaneByIndex(1) },
  { key = '3', mods = 'ALT', action = act.ActivatePaneByIndex(2) },
  { key = '4', mods = 'ALT', action = act.ActivatePaneByIndex(3) },
  { key = 'Backspace', mods = 'ALT', action = act.CloseCurrentTab { confirm = false }},
  { key = 'v', mods = 'ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }},
  { key = 'h', mods = 'ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }},
  { key = 'p', mods = 'ALT', action = act.ActivateCommandPalette},
  { key = 'k', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Down', 5 }},
  { key = 'i', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Up', 5 }},
  { key = 'j', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Left', 5 }},
  { key = 'l', mods = 'ALT|SHIFT', action = act.AdjustPaneSize { 'Right', 5 }},
  { key = 't', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain'},
  { key = 'l', mods = 'ALT', action = act.EmitEvent 'trigger-hx-with-visible-text'},
}
config.window_background_opacity = 0.9
-- for i = 1, 8 do
--   table.insert(config.keys, {
--     key = tostring(i),
--     mods = 'ALT|SHIFT',
--     action = act.ActivateTab(i - 1),
--   })
-- end

config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = 'Dracula'

wezterm.on('trigger-hx-with-visible-text', function(window, pane)
  local viewport_text = pane:get_lines_as_text()
  -- local viewport_text = pane:get_lines_as_text(2000)
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
