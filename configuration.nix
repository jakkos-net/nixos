{inputs, outputs, lib, config, pkgs, ...}: {

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

  # nix settings
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  system.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-a77d21c1-0d1e-41ba-915b-9d6377bf16ac".device = "/dev/disk/by-uuid/a77d21c1-0d1e-41ba-915b-9d6377bf16ac";
  boot.kernelParams = ["amdgpu.sg_display=0"];

  # network
  networking.networkmanager.enable = true;
  networking.hostName = "machine";
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # locale settings
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
  services.xserver = {
    layout = "gb";
    xkbVariant = "";
  };
  console.keyMap = "uk";  

  # desktop
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.autoLogin = {    
      enable = true;
      user = "jak";
  };

  services.printing.enable = true;

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
    
  users.users.jak = {
    isNormalUser = true;
    description = "jak";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users.jak = {
      home = {
        username = "jak";
        homeDirectory = "/home/jak";
      };
      home.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

      # installed programs
      home.packages = with pkgs; [
        ripgrep-all
        gitui
        mpv
        bacon
        rustup
        firefox
        skim
        tealdeer
        typst
        typst-lsp
        nil
        tokei
        nixfmt
        bat
        gallery-dl
        marksman
        lua-language-server
        unzip
        python311
        gh
        bat
        fd
        taplo
        ltex-ls
        sd
        p7zip
        ouch
        just
        deluge
        google-chrome
        discord
        krita
        zotero
        blender
        deluge
        watchexec
        ffmpeg
        lapce
        gnome.dconf-editor       
        wmctrl
      ];

      # other software configs
      imports = [
        ./dot/gnome.nix
        ./dot/desktop_entries.nix
      ];

      programs.git = {
        enable = true;
        extraConfig = {
          user.name = "jakkos-net";
          user.email = "45759112+jakkos-net@users.noreply.github.com";
        };
      };

      programs.helix = {
        enable = true;
        settings = builtins.fromTOML (builtins.readFile ./dot/helix_config.toml);
      };

      programs.wezterm = {
        enable = true;
        extraConfig = builtins.readFile ./dot/wezterm.lua;
      };

      programs.nushell = {
        enable = true;
        configFile.text = builtins.readFile ./dot/config.nu;
        envFile.text = builtins.readFile ./dot/env.nu;
        extraConfig = builtins.readFile ./dot/cmds.nu;
      };

      programs.zoxide = {
        enable = true;
        enableNushellIntegration = true;
      };

      programs.direnv = {
        enable = true;
        enableNushellIntegration = true;
      };
    };
  };

  programs.steam.enable = true; # steam needs special FHS stuff, so has to be enabled outside home-manager
  hardware.opengl.driSupport32Bit = true; # Enables support for 32bit libs that steam uses
}
