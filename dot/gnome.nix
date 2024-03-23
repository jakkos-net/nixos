{
  "org/gnome/desktop/sound" = {
    allow-volume-above-100-percent = true;
  };

  "org/gnome/desktop/interface" = {
    show-battery-percentage = true;
    clock-show-weekday = true;
    color-scheme = "prefer-dark";
  };

  "org/gnome/shell/keybindings" = {
    toggle-application-view = [];
    toggle-message-tray = [];
    toggle-overview = [];
    toggle-quick-settings = [];
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

    switch-to-workspace-1 = ["<Super>q"];
    move-to-workspace-1 = ["<Super><Shift>q"];
    switch-to-workspace-2 = ["<Super>w"];
    move-to-workspace-2 = ["<Super><Shift>w"];
    switch-to-workspace-3 = ["<Super>e"];
    move-to-workspace-3 = ["<Super><Shift>e"];
    switch-to-workspace-4 = ["<Super>r"];
    move-to-workspace-4 = ["<Super><Shift>r"];
    switch-to-workspace-5 = ["<Super>a"];
    move-to-workspace-5 = ["<Super><Shift>a"];
    switch-to-workspace-6 = ["<Super>s"];
    move-to-workspace-6 = ["<Super><Shift>s"];
    switch-to-workspace-7 = ["<Super>d"];
    move-to-workspace-7 = ["<Super><Shift>d"];
    switch-to-workspace-8 = ["<Super>f"];
    move-to-workspace-8 = ["<Super><Shift>f"];
    switch-to-workspace-9 = ["<Super>z"];
    move-to-workspace-9 = ["<Super><Shift>z"];
    switch-to-workspace-10 = ["<Super>x"];
    move-to-workspace-10 = ["<Super><Shift>x"];
    switch-to-workspace-11 = ["<Super>c"];
    move-to-workspace-11 = ["<Super><Shift>c"];
    switch-to-workspace-12 = ["<Super>v"];
    move-to-workspace-12 = ["<Super><Shift>v"];
  };

  "org/gnome/desktop/wm/preferences" = {
    num-workspaces = 12;
  };

  "org/gnome/desktop/input-sources" = {
    xkb-options = ["caps:escape_shifted_capslock"];
  };

  "org/gnome/settings-daemon/plugins/media-keys" = {
    custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
    ];
  };
  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    binding = "<Super>Return";
    command = "wezterm start --always-new-process";
    name = "open-terminal";
  };
}
