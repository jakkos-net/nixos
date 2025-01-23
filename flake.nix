{
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11"; # in case something unstable is broken
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable";  
  };
  outputs = {nixpkgs-unstable, nixpkgs-stable, home-manager, nix-index-database, ...}:
  let
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-unstable {inherit system; config.allowUnfree = true; };
    pkgs-unstable = import nixpkgs-unstable {inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations = {
      machine = nixpkgs-unstable.lib.nixosSystem {
        modules = [
          ./configuration.nix # main config
          ./hardware-configuration.nix # auto-generated depending on hardware (`nixos-generate-config`)
          home-manager.nixosModules.home-manager # homemanager is very useful for user-level config (e.g. dotfiles)
          nix-index-database.nixosModules.nix-index # database of which packages contain which programs/files
        ];
        specialArgs = { inherit pkgs-stable pkgs-unstable; };
      };
    };
  };
}
