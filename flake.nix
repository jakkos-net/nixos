{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {nixpkgs, home-manager, ...}: {
    nixosConfigurations = {
      machine = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix # main config
          ./hardware-configuration.nix # auto-generated depending on hardware (`nixos-generate-config`)
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
