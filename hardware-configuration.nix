{ config, lib, pkgs, modulesPath, ... }: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" ={ 
    device = "/dev/disk/by-uuid/a4a93ab0-ee13-486c-9ba8-da6905f96115";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-640f8339-e01f-4127-9cc6-c4aa20b27806".device = "/dev/disk/by-uuid/640f8339-e01f-4127-9cc6-c4aa20b27806";

  fileSystems."/boot" = { 
    device = "/dev/disk/by-uuid/8798-D116";
    fsType = "vfat";
  };

  swapDevices =[{ device = "/dev/disk/by-uuid/1e3a3b77-3746-47a9-b72c-c29edd9a9636"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
