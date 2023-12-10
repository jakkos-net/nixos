# this file contains all my settings for the Gnome desktop environment
{lib, ... } : 
let
  # a workspace is created and assigned for each key listed here
  workspaces = ["q" "w" "e" "r" "t" "a" "s" "d" "f" "g" "z" "x" "c" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"];
  custom_keybinds = [
    {name = "spawn terminal"; command = "wezterm"; binding = "<Super>Return";}
  ];
in
{ 
  dconf.settings = ({
      "org/gnome/desktop/sound" = {
        allow-volume-above-100-percent = true;
      };

      "org/gnome/desktop/interface" = {
        show-battery-percentage = true;
        clock-show-seconds = true;
        clock-show-weekday = true;
        color-scheme = "prefer-dark";
      };

      "org/gnome/shell/keybindings" = {
        toggle-application-view = [];
        toggle-message-tray = [];
        toggle-overview = [];
        toggle-quick-settings = [];
        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
        switch-to-application-5 = [];
        switch-to-application-6 = [];
        switch-to-application-7 = [];
        switch-to-application-8 = [];
        switch-to-application-9 = [];
      };

      "org/gnome/shell" = {
        favorite-apps = [];
        disabled-extensions = [];
        enabled-extensions = ["launch-new-instance@gnome-shell-extensions.gcampax.github.com"];
      };

      "org/gnome/shell/window-switcher" = {
        current-workspace-only = true;
      };
    
      "org/gnome/desktop/wm/keybindings" = {
        switch-windows = ["<Alt>Tab"];
        close = ["<Super>Backspace"];
      };

      "org/gnome/desktop/input-sources" = {
        xkb-options = ["caps:escape_shifted_capslock"];
      };
  } 
  # everything below here is just code to set up the custom keybindings and workspaces that i defined at the top of this file
  // 
  ( 
    let
      build_workspace_keybind = idx: ws: [
          # switch to a workspace with Super+<workspace key>
          {name = "switch_to_workspace-${toString idx}"; command = "wmctrl -s ${toString idx}"; binding = "<Super>${ws}";}
          # move the focus window to a workspace with Super+Shift+<workspace key>
          {name = "move_window_to_workspace-${toString idx}"; command = "wmctrl -r :ACTIVE: ${toString idx}"; binding = "<Super><Shift>${ws}";}
        ];
      workspace_keybinds = lib.lists.flatten (lib.lists.imap0 build_workspace_keybind workspaces);
      all_keybinds = custom_keybinds ++ workspace_keybinds;
    in
    (
      {
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = lib.imap0 (idx: _: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString idx}/") all_keybinds;
        };

        "org/gnome/desktop/wm/preferences" = {
          num-workspaces = builtins.length workspaces;
        };
      }
      //
      (lib.attrsets.mergeAttrsList 
        (lib.lists.imap0 
          (idx: kb: { "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${toString idx}" = kb; })
          all_keybinds
        )
      )
    )
  ));
}
