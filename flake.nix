{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";  
  };
  outputs = {nixpkgs, home-manager, nix-index-database, nixos-cosmic, ...}: {
    nixosConfigurations = {
      machine = nixpkgs.lib.nixosSystem {
        modules = [
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          ./configuration.nix
          ./hardware-configuration.nix # auto-generated depending on hardware (`nixos-generate-config`)
          home-manager.nixosModules.home-manager # homemanager is very useful for user-level config (e.g. dotfiles)
          nix-index-database.nixosModules.nix-index # database of which packages contain which programs/files
        ];
      };
    };
  };
}
