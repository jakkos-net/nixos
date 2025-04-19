{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11"; 
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake"; # waiting for https://github.com/NixOS/nixpkgs/issues/327982
  };
  outputs = inputs:
  let
    hostName = "machine";
    userName = "jak";
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {inherit system; config.allowUnfree = true; };
    pkgs-unstable = import inputs.nixpkgs-unstable {inherit system; config.allowUnfree = true; };
    config-module= {lib, config, modulesPath, ...}: {
      # nix
      nixpkgs.pkgs = pkgs;
      nix.settings.experimental-features = "nix-command flakes"; # enable flakes
      nix.settings.download-buffer-size = 1073741824; # don't intermittently pause download during rebuild
      system.stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion

      # boot/kernel/hardware
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.systemd-boot.memtest86.enable = true; # have memtest as an option at boot
      boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_6; # issues with amd drivers on latest kernel
      boot.kernelModules = [ "kvm-amd" ];
      boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
      boot.initrd.luks.devices."luks-640f8339-e01f-4127-9cc6-c4aa20b27806".device = "/dev/disk/by-uuid/640f8339-e01f-4127-9cc6-c4aa20b27806";
      fileSystems."/" = {device = "/dev/disk/by-uuid/a4a93ab0-ee13-486c-9ba8-da6905f96115"; fsType = "ext4";};
      fileSystems."/boot" = {device = "/dev/disk/by-uuid/8798-D116"; fsType = "vfat";};
      swapDevices =[{ device = "/dev/disk/by-uuid/1e3a3b77-3746-47a9-b72c-c29edd9a9636"; }];
      hardware.cpu.amd.updateMicrocode = true;
      programs.cfs-zen-tweaks.enable = true; # make desktop more responsive while cpu is being slammed

      # networking
      networking.networkmanager.enable = true;
      networking.hostName = hostName;
      environment.etc."resolv.conf".text = "nameserver 9.9.9.9" + "\n" + "options edns0"; # force quad9 dns
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;

      # locale
      time.timeZone = "Europe/London";
      i18n.defaultLocale = "en_GB.UTF-8";
      services.xserver.xkb.layout = "gb";
      console.useXkbConfig = true;

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
      programs.steam.enable = true; # steam needs special FHS stuffr
      programs.nix-ld.enable = true; # run unpatched binaries
      services.fwupd.enable = true; # firmware updates

      # user
      users.users."${userName}" = {
        isNormalUser = true; # sets up homedir, adds to users group, etc.
        extraGroups = [ "networkmanager" "wheel" ]; # wheel group gives access to sudo
        packages = with pkgs; [
          carapace comma deluge discord diskonaut fd ffmpeg ffmpegthumbnailer
          framework-tool fzf git gitui google-chrome just krita mpv nix-index
          nushell ouch pkgs-unstable.helix poppler ripgrep sd signal-desktop
          smartmontools tokei unar vlc wezterm wl-clipboard yazi youtube-music
          zoxide (inputs.zen-browser.packages."${system}".default) ];
        };

      system.activationScripts.symlinkDotFiles.text = ''
        SRC_DIR=${lib.escapeShellArg "${./.}"}
        ${pkgs.nushell}/bin/nu -c "
          cd $SRC_DIR;
          ls .config/**/* | where type == 'file' | each {|file|
            ln -sf $SRC_DIR/(\$file.name) /home/${userName}/(\$file.name)} | ignore" '';
    };
  in { nixosConfigurations."${hostName}" = inputs.nixpkgs.lib.nixosSystem { modules = [config-module]; }; };
}
