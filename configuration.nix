{pkgs, ...}: {

  imports = [
    ./hardware-configuration.nix #auto-generated depending on hardware (`nixos-generate-config`)
  ];

  # nix
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
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
  services.xserver.displayManager.autoLogin = {    
      enable = true;
      user = "jak";
  };
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.cosmic.enable = true;
  # services.xserver.displayManager.cosmic-greeter.enable = true;

  # sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
    
  services.printing.enable = true;

  users.users.jak = {
    isNormalUser = true;
    description = "jak";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # home-manager is used for user-level configuration, e.g. dotfiles
  home-manager = {
    users.jak = {
      home = {
        username = "jak";
        homeDirectory = "/home/jak";
        stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      };
      
      imports = [
        ./dot/desktop_entries.nix # app launcher shortcuts
        ./dot/gnome.nix # gnome desktop settings
      ];

      home.file."wallpaper".source = ./dot/wallpaper;

      # installed programs
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
        typst
        typst-lsp
        nil
        nixfmt
        lua-language-server
        ltex-ls
        marksman
        taplo
        bacon
        tokei
        bat
        gallery-dl
        gh
        sd
        ouch
        unzip
        just
        deluge
        discord
        krita
        zotero
        blender
        deluge
        watchexec
        libreoffice
        wl-clipboard
        rclone
        # rustdesk
        distrobox
        element-desktop
        powertop
        bottom
        csview
        renderdoc
        zathura
      ];

      # installed programs that have extra config          
      programs.git = {
        enable = true;
        extraConfig = {
          user.name = "jakkos-net";
          user.email = "45759112+jakkos-net@users.noreply.github.com";
        };
      };

      programs.helix = {
        enable = true;
        settings = builtins.fromTOML (builtins.readFile ./dot/helix.toml);
        themes = { dracula_transparent = { inherits = "dracula"; "ui.background" = {}; }; };
      };

      programs.wezterm = {
        enable = true;
        extraConfig = builtins.readFile ./dot/wezterm.lua;
      };

      programs.nushell = {
        enable = true;
        configFile.text = builtins.readFile ./dot/config.nu;
        envFile.text = builtins.readFile ./dot/env.nu;
      };

      programs.yazi = {
        enable = true;
        enableNushellIntegration = true;
      };

      programs.direnv = {
        enable = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
      };

      programs.zoxide = {
        enable = true;
        enableNushellIntegration = true;
      };

      programs.tealdeer = {
        enable = true;
        settings.updates.auto_update = true;
      };
    };
  };

  virtualisation.podman.enable = true; # used for distrobox

  programs.steam.enable = true; # steam needs special FHS stuff, so has to be enabled outside home-manager
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
}
