# aliases and custom commands for nushell

alias j = just
alias g = gitui
alias up = sudo nixos-rebuild switch --flake ~/nixos#machine
alias ns = nix-shell -p
alias tldr = tldr --update

def nr [pkg cmd] {
  nix-shell -p $pkg --run $"($pkg) ($cmd)"
}
