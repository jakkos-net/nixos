{pkgs-stable, pkgs-unstable, pkgs-flake, ...}: {
  # nix
  nixpkgs.config.allowUnfree = true; # allow stuff non-open-source stuff like discord
  nix.settings.experimental-features = "nix-command flakes"; # enable flakes
  nix.settings.auto-optimise-store = true; # dedupe store files (should turn off if I move to zfs with builtin dedupe)
  nix.gc.options = "--delete-older-than 10d"; # clean up nix files that haven't been used in 10 days
  nix.gc.automatic = true; # ..
  system.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

  # boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-a77d21c1-0d1e-41ba-915b-9d6377bf16ac".device = "/dev/disk/by-uuid/a77d21c1-0d1e-41ba-915b-9d6377bf16ac";
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/top-level/linux-kernels.nix
  boot.kernelPackages = pkgs-stable.linuxKernel.packages.linux_6_6; # issues with amd drives on latest kernel
  boot.loader.systemd-boot.memtest86.enable = true; # have memtest as an option at boot

  # networking
  networking.networkmanager.enable = true;
  networking.hostName = "machine";
  networking.nameservers = [ "9.9.9.9" ]; # use quad9 dns
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

  # sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  # other
  services.printing.enable = true; # you'll never guess what this does
  programs.steam.enable = true; # steam needs special FHS stuff, so has to be enabled outside home-manager
  programs.nix-ld.enable = true; # run unpatched binaries
  services.fwupd.enable = true; # firmware updates
  programs.nix-index-database.comma.enable = true; # allow quickly running programs without installing them (`, cowsay hello`)
  programs.command-not-found.enable = false; # needed for line above, otherwise they conflict

  # user
  users.users.jak.isNormalUser = true; # sets up homedir, adds to users group, etc.
  users.users.jak.extraGroups = [ "networkmanager" "wheel" ]; # wheel group gives access to sudo
  home-manager.users.jak = {  # home-manager is used for user-level configuration, e.g. dotfiles
    home.username = "jak";
    home.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.file."wallpaper".source = ./dot/wallpaper; # link wallpaper file to homedir so other programs can easily access
    home.packages =
    (with pkgs-stable; [
      gitui sd ouch wl-clipboard ripgrep poppler fzf unar ffmpeg ffmpegthumbnailer fd just diskonaut tokei # term tools
      mpv vlc # video players
      google-chrome # backup browser
      krita # paint
      deluge # torrents
      libreoffice # word/excel
      discord signal-desktop # comms
    ]) ++
    (with pkgs-unstable; [
    ]) ++
    (with pkgs-flake; [
      zen-browser
    ]);

    programs = { # programs with extra config
      git.enable = true;
      git.lfs.enable = true;
      git.extraConfig.user.name = "jakkos-net";
      git.extraConfig.user.email = "45759112+jakkos-net@users.noreply.github.com"; # makes github commits show as correct account

      helix.enable = true; # text editor
      helix.settings = builtins.fromTOML (builtins.readFile ./dot/helix.toml);
      helix.package = pkgs-unstable.helix; # i want the newest release

      wezterm.enable = true; # best terminal emulator
      wezterm.extraConfig = builtins.readFile ./dot/wezterm.lua;

      nushell.enable = true; # best shell
      nushell.configFile.text = builtins.readFile ./dot/config.nu;

      yazi.enable = true; # terminal file manager
      yazi.enableNushellIntegration = true;

      direnv.enable = true; # auto load devshell when entering specific directories
      direnv.enableNushellIntegration = true;
      direnv.nix-direnv.enable = true; # more performant implementation

      zoxide.enable = true; # replaces `cd` with smarter `z` command
      zoxide.enableNushellIntegration = true;
    };

    dconf.settings = import ./dot/gnome.nix; # gnome settings

    xdg.desktopEntries = { # app launcher shortcuts
      ff = {name="ff"; exec="zen --new-window";};
      mu = {name="mu"; exec="zen --new-window https://music.youtube.com";};
      fp = {name="fp"; exec="zen --private-window";};
    };
  };
}
