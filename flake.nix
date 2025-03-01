{
  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11"; 
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # sometimes want newer packages
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable"; # want newest packages in comma
    zen-browser.url = "github:0xc000022070/zen-browser-flake"; # waiting for https://github.com/NixOS/nixpkgs/issues/327982
  };
  outputs = {nixpkgs-unstable, nixpkgs-stable, home-manager, nix-index-database, zen-browser, ...}:
  let
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {inherit system; config.allowUnfree = true; };
    pkgs-unstable = (import nixpkgs-unstable {inherit system; config.allowUnfree = true; });
    pkgs-flake = {zen-browser = zen-browser.packages."${system}".default;};
  in {
    nixosConfigurations = {
      machine = nixpkgs-stable.lib.nixosSystem {
        modules = [
          ./configuration.nix # main config
          ./hardware-configuration.nix # auto-generated depending on hardware (`nixos-generate-config`)
          home-manager.nixosModules.home-manager # homemanager is very useful for user-level config (e.g. dotfiles)
          nix-index-database.nixosModules.nix-index # database of which packages contain which programs/files
        ];
        specialArgs = { inherit pkgs-stable pkgs-unstable pkgs-flake; };
      };
    };
  };
}
