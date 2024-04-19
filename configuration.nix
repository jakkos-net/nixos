{pkgs, ...}: {
  # nix
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.auto-optimise-store = true;
  system.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

  # boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-a77d21c1-0d1e-41ba-915b-9d6377bf16ac".device = "/dev/disk/by-uuid/a77d21c1-0d1e-41ba-915b-9d6377bf16ac";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["amdgpu.sg_display=0"]; # currently a bug with some AMD iGPUs and white screen flickering

  # networking
  networking.networkmanager.enable = true;
  networking.hostName = "machine";
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  services.xserver.xkb.layout = "gb";
  console.keyMap = "uk";  

  # desktop environment
  services.xserver.enable = true;
  services.greetd.enable = true;
  services.greetd.settings = rec {
    initial_session.command = "${pkgs.sway}/bin/sway";
    initial_session.user = "jak";
    default_session = initial_session;
  };

  # sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  # other
  services.printing.enable = true;
  programs.steam.enable = true; # steam needs special FHS stuff, so has to be enabled outside home-manager
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
  programs.nix-ld.enable = true; # run unpatched binaries
  virtualisation.podman.enable = true; # used for distrobox
  security.pam.services.swaylock = {};
  # user
  users.users.jak.isNormalUser = true;
  users.users.jak.extraGroups = [ "networkmanager" "wheel" ];
  home-manager.users.jak = {  # home-manager is used for user-level configuration, e.g. dotfiles
    home.username = "jak";
    home.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.file."wallpaper".source = ./dot/wallpaper;
    home.packages = with pkgs; [
      ripgrep
      ripgrep-all
      jq
      poppler
      fzf
      unar
      ffmpeg
      ffmpegthumbnailer
      fd
      gitui
      mpv
      firefox
      google-chrome
      tokei
      gallery-dl
      gh
      sd
      ouch
      just
      deluge
      discord
      krita
      zotero
      deluge
      watchexec
      libreoffice
      wl-clipboard
      element-desktop
      obs-studio
      distrobox
      grim
      slurp
      mako
      bemenu
      swaylock-effects
      okular
    ];

    wayland.windowManager.sway.enable = true;
    wayland.windowManager.sway.extraConfig = builtins.readFile ./dot/sway;
    wayland.windowManager.sway.config.bars = [];
    services.swayosd.enable = true;
    programs = { # programs with extra config
      git.enable = true;
      git.extraConfig.user.name = "jakkos-net";
      git.extraConfig.user.email = "45759112+jakkos-net@users.noreply.github.com";

      helix.enable = true;
      helix.settings = builtins.fromTOML (builtins.readFile ./dot/helix.toml);
      helix.themes = { my_theme = { 
        inherits = "dracula"; 
        "ui.background" = {}; 
        "ui.virtual.jump-label" = { fg = "red"; modifiers = ["bold"]; };
      };};

      wezterm.enable = true;
      wezterm.extraConfig = builtins.readFile ./dot/wezterm.lua;

      nushell.enable = true;
      nushell.configFile.text = builtins.readFile ./dot/config.nu;
      nushell.envFile.text = builtins.readFile ./dot/env.nu;

      yazi.enable = true;
      yazi.enableNushellIntegration = true;

      direnv.enable = true;
      direnv.enableNushellIntegration = true;
      direnv.nix-direnv.enable = true; # more performant implementation

      zoxide.enable = true;
      zoxide.enableNushellIntegration = true;

      tealdeer.enable = true;
      tealdeer.settings.updates.auto_update = true;

      i3status-rust.enable = true;
      i3status-rust.bars.default.blocks = [
        {
          block = "net";
          format = "net:$ssid $signal_strength";
        }
        {
          block = "disk_space";
          path = "/";
          info_type = "available";
          interval = 60;
          format = "dsk:$available.eng(w:2)";
        }
        {
          block = "battery";
          charging_format = "pow:↑$percentage";
          format = "pow:↓$percentage";
          full_format = "pow:=$percentage";
          not_charging_format = "pow:↓$percentage";
          missing_format = "pow:?$percentage";
        }            
        {
          block = "sound";
          format = "vol:$volume.eng(w:2)";
        }
        {
          block = "time";
          format = "$timestamp.datetime(f:'%a %Y/%m/%d %R')";
          interval = 60;
        }
      ];
    };

    xdg.desktopEntries = { # app launcher shortcuts
      ff = {name="ff"; exec="firefox --new-window";};
      mu = {name="mu"; exec="firefox --new-window https://music.youtube.com";};
      wa = {name="wa"; exec="firefox --new-window https://web.whatsapp.com";};
      fp = {name="fp"; exec="firefox --private-window";};
    };
  };
}
