{
  "org/gnome/desktop/sound" = { allow-volume-above-100-percent = true; };

  "org/gnome/desktop/interface" = {
    show-battery-percentage = true;
    clock-show-weekday = true;
    color-scheme = "prefer-dark";
  };

  "org/gnome/shell" = {
    favorite-apps = ["org.wezfurlong.wezterm.desktop" "zen.desktop" "signal-desktop.desktop" "discord.desktop"];
    enabled-extensions = [
      "system-monitor@gnome-shell-extensions.gcampax.github.com"
    ];
  };

  "org/gnome/desktop/wm/keybindings" = {
    switch-windows = ["<Alt>Tab"];
    switch-groups = [];
    close = ["<Super>Backspace"];
  };

  "org/gnome/desktop/input-sources" = { xkb-options = ["caps:escape_shifted_capslock"]; };
}
