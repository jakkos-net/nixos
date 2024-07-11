{pkgs, ...}: {
  # nix
  nixpkgs.config.allowUnfree = true; # allow stuff non-open-source stuff like discord
  nix.settings.experimental-features = "nix-command flakes"; # enable flakes
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 10d"; # clean up nix files that haven't been used in 10 days
  system.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

  # boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-a77d21c1-0d1e-41ba-915b-9d6377bf16ac".device = "/dev/disk/by-uuid/a77d21c1-0d1e-41ba-915b-9d6377bf16ac";
  boot.kernelPackages = pkgs.linuxPackages_latest; # use the latest kernel
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

  # desktop environment (gnome)
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jak";

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
  programs.nix-ld.enable = true; # run unpatched binaries
  virtualisation.podman.enable = true; # used for distrobox
  services.fwupd.enable = true; # firmware updates
  programs.nix-index-database.comma.enable = true; # allow quickly running programs without installing them (e.g. `, cowsay hello`)
  programs.command-not-found.enable = false; # needed for above, otherwise they conflict

  # user
  users.users.jak.isNormalUser = true;
  users.users.jak.extraGroups = [ "networkmanager" "wheel" ];
  home-manager.users.jak = {  # home-manager is used for user-level configuration, e.g. dotfiles
    home.username = "jak";
    home.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.file."wallpaper".source = ./dot/wallpaper;
    home.packages = with pkgs; [ # programs with no extra config
      ripgrep
      ripgrep-all # install rg and rga because rga lets you search more but some other programs use rg
      poppler
      fzf
      unar
      ffmpeg
      ffmpegthumbnailer # used for file previews in some programs
      fd
      gitui
      mpv # video player
      firefox
      google-chrome # some websites don't like firefox
      gh # useful for creating github repos from local git repos
      sd
      ouch # zip/unzip lots of different formats
      discord
      krita # paint
      zotero
      deluge # torrents
      watchexec # runs commands on file changes
      libreoffice # word/excel
      wl-clipboard # needed so copy/paste works in some programs
      element-desktop
      obs-studio # screen recording
      distrobox # last resort if I can't get something to work on NixOS
    ];

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

      wezterm.enable = true; # best terminal emulator
      wezterm.extraConfig = builtins.readFile ./dot/wezterm.lua;

      nushell.enable = true; # best shell
      nushell.configFile.text = builtins.readFile ./dot/config.nu;
      nushell.envFile.text = builtins.readFile ./dot/env.nu;

      yazi.enable = true; # terminal file manager
      yazi.enableNushellIntegration = true;

      direnv.enable = true; # change environment when entering certain directories
      direnv.enableNushellIntegration = true;
      direnv.nix-direnv.enable = true; # more performant implementation

      zoxide.enable = true; # replaces `cd` with smarter `z` command
      zoxide.enableNushellIntegration = true;

      tealdeer.enable = true; # show common use cases for commands
      tealdeer.settings.updates.auto_update = true;
    };

    dconf.settings = import ./dot/gnome.nix; # gnome settings

    xdg.desktopEntries = { # app launcher shortcuts
      ff = {name="ff"; exec="firefox --new-window";};
      mu = {name="mu"; exec="firefox --new-window https://music.youtube.com";};
      wa = {name="wa"; exec="firefox --new-window https://web.whatsapp.com";};
      fp = {name="fp"; exec="firefox --private-window";};
    };
  };
}
