# My NixOS config

This is my NixOS config. As I only run NixOS solely on a single-user laptop, I've tried to keep everything very simple. As such this probably doesn't follow "best practices" (e.g. system and home config are in the same file), however I think it's still (hopefully) reasonably easy to read and follow along.

- [configuration.nix](configuration.nix) contains the bulk of the config, e.g. what kernel im using, what programs I have installed, etc.
- [dot/](dot/) contains files for configuring specific software when that config is longer than a few lines. E.g., my Gnome desktop settings, my Wezterm config, etc.
- [hardware-configuration.nix](hardware-configuration.nix) is auto generated from running `nixos-generate-config`
- [flake.nix](flake.nix) lists the dependencies (e.g. nixpkgs and home-manager) 
- [flake.lock](flake.lock) tracks the versions of those dependencies

