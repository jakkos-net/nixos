local io = require 'io'
local os = require 'os'
local wezterm = require 'wezterm'

local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()

config.hide_mouse_cursor_when_typing = false;
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
  { key = '#', mods = 'ALT', action = act.EmitEvent 'rust-layout'},
  { key = ';', mods = 'ALT', action = act.EmitEvent 'second-brain-layout'},
}

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
  local layout = os.getenv("WEZTERM_LAYOUT")
   if layout == "second_brain" then
    wezterm.emit('second-brain-layout')
   end
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

wezterm.on('second-brain-layout', function(window,pane)
  local child_pane = pane:split {
    direction = 'Right',
    args = {"nu", "-e", "ls"},
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
