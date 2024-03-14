# My NixOS config
- [configuration.nix](configuration.nix) contains the bulk of the config, e.g. which kernel im using, which programs I have installed, etc.
- [dot/](dot/) contains different software configs, e.g. Gnome desktop settings, Wezterm config, etc.
- [hardware-configuration.nix](hardware-configuration.nix) is auto-generated depending on hardware (`nixos-generate-config`)
- [flake.nix](flake.nix) lists the dependencies (just nixpkgs and home-manager) 
- [flake.lock](flake.lock) is auto-generated and tracks dependency versions (`nix flake update`)

